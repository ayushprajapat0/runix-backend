import { LANGUAGES } from "../../configs/languages.js";
import { fetchTestCases, fetchRunnerCode, enqueueAndWait } from "../run/run.service.js";
import { saveSubmissionResult, updateUserProblemStatus, getUserSubmissions as fetchUserSubmissions } from "./submissions.service.js";

const SUPPORTED_LANGUAGES = Object.keys(LANGUAGES);

export async function submitCode(req, res, next) {
    try {
        const { code, language, problemId } = req.body;
        const userId = req.user.id;

        // ── Validate ────────────────────────────────────────────────────────────
        if (!code || typeof code !== "string" || code.length > 65_536) {
            return res.status(400).json({ error: "Invalid or missing code (max 64 KB)" });
        }

        if (!SUPPORTED_LANGUAGES.includes(language)) {
            return res.status(400).json({
                error: `Unsupported language. Supported: ${SUPPORTED_LANGUAGES.join(", ")}`,
            });
        }

        if (!problemId) {
            return res.status(400).json({ error: "problemId is required for submission" });
        }

        // ── Fetch test cases ─────────────────────────────────────────────────────
        // Passing undefined for customInput so it fetches all real test cases
        const testCases = await fetchTestCases(problemId);

        // ── Wrap user code with per-problem harness ──────────────────────────────
        const langConfig = LANGUAGES[language];
        const runnerCode = await fetchRunnerCode(problemId, langConfig.dbSlug);
        const finalCode = runnerCode
            ? runnerCode.replace("{{USER_CODE}}", code)
            : code;

        // ── Enqueue & wait ───────────────────────────────────────────────────────
        const result = await enqueueAndWait({ code: finalCode, language, testCases });

        // ── Save Result ──────────────────────────────────────────────────────────
        const submissionRecord = await saveSubmissionResult({
            userId,
            problemId,
            languageSlug: langConfig.dbSlug,
            code,
            status: result.status,
            runtimeMs: result.maxElapsedMs || null,
            memoryKb: null, // Note: Memory profiling not yet extracted from docker
            errorMessage: result.compileError || result.error || null,
            passedTestCases: result.passedCount,
            totalTestCases: result.totalCount
        });

        // ── Update User Progress ─────────────────────────────────────────────────
        await updateUserProblemStatus({
            userId,
            problemId,
            status: result.status,
            runtimeMs: result.maxElapsedMs || null,
            memoryKb: null
        });

        return res.status(200).json({
            submissionId: submissionRecord.id,
            ...result
        });
    } catch (err) {
        next(err);
    }
}

export async function getUserSubmissions(req, res, next) {
    try {
        const userId = req.user.id;
        const { problemId } = req.query;

        const submissions = await fetchUserSubmissions(userId, problemId);
        return res.status(200).json(submissions);
    } catch (err) {
        next(err);
    }
}
