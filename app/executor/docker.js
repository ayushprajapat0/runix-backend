import { execFile } from "child_process";
import { spawn } from "child_process";
import { promises as fs } from "fs";
import path from "path";
import os from "os";
import { promisify } from "util";
import { getLanguageConfig, LANGUAGES } from "../configs/languages.js";

const execFileAsync = promisify(execFile);

// Docker Desktop for Linux/Mac doesn't share /tmp with the VM.
// Use a path under the home directory instead (shared by Docker Desktop by default).
const SANDBOX_BASE = process.env.SANDBOX_BASE_DIR
    || path.join(os.homedir(), ".judge-sandbox");

// Ensure the base sandbox directory exists once at startup
await fs.mkdir(SANDBOX_BASE, { recursive: true });

// ─── Image warm-up ──────────────────────────────────────────────────────────

/**
 * Pull every configured language image so they are cached before any job runs.
 */
export async function pullImages() {
    const images = [...new Set(Object.values(LANGUAGES).map((l) => l.image))];
    console.log("[Executor] Pre-pulling Docker images:", images.join(", "));

    await Promise.all(
        images.map(async (image) => {
            try {
                await execFileAsync("docker", ["pull", image], { timeout: 300_000 });
                console.log(`[Executor] ✓ ${image} ready`);
            } catch (err) {
                console.warn(`[Executor] ⚠ Could not pull ${image}:`, err.message);
            }
        })
    );
}

// ─── Helpers ────────────────────────────────────────────────────────────────

async function createSandboxDir(code, filename) {
    const dir = await fs.mkdtemp(path.join(SANDBOX_BASE, "judge-"));
    await fs.writeFile(path.join(dir, filename), code, "utf8");
    return dir;
}

async function cleanupDir(dir) {
    try {
        await fs.rm(dir, { recursive: true, force: true });
    } catch (_) {
        // Intentionally swallowed
    }
}

/**
 * Build the `docker run` argument list.
 */
function buildDockerArgs({ image, limits, sandboxDir, cmd, readOnlyCode = true }) {
    return [
        "run",
        "--rm",
        "-i",
        "--network", "none",
        "--memory", `${limits.memoryMb}m`,
        "--memory-swap", `${limits.memoryMb}m`,
        "--cpus", String(limits.cpus),
        "--pids-limit", String(limits.pidsLimit),
        "--read-only",
        "--tmpfs", "/tmp:size=64m",
        "--cap-drop", "ALL",
        "--security-opt", "no-new-privileges",
        "-v", `${sandboxDir}:/code${readOnlyCode ? ":ro" : ""}`,
        "-w", "/code",
        image,
        ...cmd,
    ];
}

// ─── Compile step (C++ / Java) ───────────────────────────────────────────────

async function compileInDocker({ image, compileCmd, limits, sandboxDir }) {
    // Code dir must be writable so the compiler can write output files
    const args = buildDockerArgs({ image, limits, sandboxDir, cmd: compileCmd, readOnlyCode: false });
    try {
        await execFileAsync("docker", args, { timeout: 30_000 });
        return { success: true };
    } catch (err) {
        return {
            success: false,
            stderr: (err.stderr || err.message).slice(0, limits.maxOutputBytes),
        };
    }
}

// ─── Run one test case ────────────────────────────────────────────────────────

function runTestCase({ image, runCmd, limits, sandboxDir, stdin }) {
    return new Promise((resolve) => {
        // Run step ALWAYS uses readOnlyCode: true
        const args = buildDockerArgs({ image, limits, sandboxDir, cmd: runCmd, readOnlyCode: true });
        const child = spawn("docker", args);

        let stdout = "";
        let stderr = "";
        let timedOut = false;

        if (stdin !== undefined && stdin !== null) {
            child.stdin.write(String(stdin));
        }
        child.stdin.end();

        const timer = setTimeout(() => {
            timedOut = true;
            child.kill("SIGKILL");
        }, limits.timeoutMs);

        child.stdout.on("data", (chunk) => {
            stdout += chunk;
            if (stdout.length > limits.maxOutputBytes) {
                stdout = stdout.slice(0, limits.maxOutputBytes);
                child.kill("SIGKILL");
            }
        });

        child.stderr.on("data", (chunk) => {
            stderr += chunk;
            if (stderr.length > limits.maxOutputBytes) {
                stderr = stderr.slice(0, limits.maxOutputBytes);
            }
        });

        const startMs = Date.now();

        child.on("close", (code) => {
            clearTimeout(timer);
            resolve({
                stdout: stdout.trim(),
                stderr: stderr.trim(),
                exitCode: code,
                elapsedMs: Date.now() - startMs,
                timedOut,
                memoryExceeded: code === 137,
            });
        });

        child.on("error", (err) => {
            clearTimeout(timer);
            resolve({
                stdout: "",
                stderr: err.message,
                exitCode: -1,
                elapsedMs: 0,
                timedOut: false,
                memoryExceeded: false,
            });
        });
    });
}

// ─── Normalise before comparing ──────────────────────────────────────────────

function normalizeOutput(str) {
    const trimmed = String(str ?? "")
        .split("\n")
        .map((l) => l.trimEnd())
        .join("\n")
        .trim();

    try {
        return JSON.stringify(JSON.parse(trimmed));
    } catch {
        return trimmed;
    }
}

// ─── Public API ───────────────────────────────────────────────────────────────

/**
 * Execute code against a list of test cases.
 */
async function executeCode({ code, language, testCases }) {
    const config = getLanguageConfig(language);
    const { image, filename, runCmd, compileCmd, limits } = config;

    const sandboxDir = await createSandboxDir(code, filename);

    try {
        // ── Compile (C++ / Java) ──────────────────────────────────────────────
        if (compileCmd) {
            const compilation = await compileInDocker({
                image,
                compileCmd: compileCmd(path.join("/code", filename)),
                limits,
                sandboxDir,
            });

            if (!compilation.success) {
                return {
                    status: "compile_error",
                    compileError: compilation.stderr,
                    passedCount: 0,
                    totalCount: testCases.length,
                    testResults: [],
                };
            }
        }

        // ── Run each test case ────────────────────────────────────────────────
        const testResults = [];
        let overallStatus = "accepted";

        for (const [idx, tc] of testCases.entries()) {
            const tcNum = idx + 1;
            console.log(
                `[Judge] TC ${tcNum}/${testCases.length} — stdin: ${JSON.stringify(tc.input)}`
            );

            const result = await runTestCase({
                image,
                runCmd: runCmd(path.join("/code", filename)),
                limits,
                sandboxDir,
                stdin: tc.input,
            });

            let caseStatus;
            if (result.timedOut) {
                caseStatus = "time_limit_exceeded";
                overallStatus = "time_limit_exceeded";
            } else if (result.memoryExceeded) {
                caseStatus = "memory_limit_exceeded";
                overallStatus = "memory_limit_exceeded";
            } else if (result.exitCode !== 0) {
                caseStatus = "runtime_error";
                if (overallStatus === "accepted") overallStatus = "runtime_error";
            } else if (
                tc.expectedOutput !== null &&
                normalizeOutput(result.stdout) !== normalizeOutput(tc.expectedOutput)
            ) {
                caseStatus = "wrong_answer";
                if (overallStatus === "accepted") overallStatus = "wrong_answer";
            } else {
                caseStatus = "accepted";
            }

            console.log(
                `[Judge] TC ${tcNum} result: ${caseStatus}` +
                `  |  stdout: ${JSON.stringify(result.stdout)}` +
                `  |  expected: ${JSON.stringify(tc.expectedOutput)}` +
                (result.stderr ? `  |  stderr: ${JSON.stringify(result.stderr)}` : "")
            );

            testResults.push({
                id: tc.id,
                status: caseStatus,
                stdout: result.stdout,
                stderr: result.stderr,
                expectedOutput: tc.expectedOutput,
                elapsedMs: result.elapsedMs,
                passed: caseStatus === "accepted",
            });
        }

        const passedCount = testResults.filter((r) => r.passed).length;
        const maxElapsedMs =
            testResults.length > 0
                ? Math.max(...testResults.map((r) => r.elapsedMs))
                : 0;

        return {
            status: overallStatus,
            passedCount,
            totalCount: testCases.length,
            maxElapsedMs,
            testResults,
        };
    } finally {
        await cleanupDir(sandboxDir);
    }
}

export { executeCode };
