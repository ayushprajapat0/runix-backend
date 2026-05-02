import { LANGUAGES } from "../../configs/languages.js";
import { fetchTestCases, fetchRunnerCode, enqueueAndWait } from "./run.service.js";

const SUPPORTED_LANGUAGES = Object.keys(LANGUAGES);

export async function runCode(req, res, next) {
    try {
        const { code, language, problemId, customInput } = req.body;

        // ── Validate ────────────────────────────────────────────────────────────
        if (!code || typeof code !== "string" || code.length > 65_536) {
            return res.status(400).json({ error: "Invalid or missing code (max 64 KB)" });
        }

        if (!SUPPORTED_LANGUAGES.includes(language)) {
            return res.status(400).json({
                error: `Unsupported language. Supported: ${SUPPORTED_LANGUAGES.join(", ")}`,
            });
        }

        // problemId required unless a customInput-only run (no problem context)
        if (!problemId && (customInput === undefined || customInput === null)) {
            return res.status(400).json({ error: "problemId or customInput is required" });
        }

        // ── Fetch test cases ─────────────────────────────────────────────────────
        const testCases = await fetchTestCases(problemId, customInput);

        // ── Wrap user code with per-problem harness ──────────────────────────────
        // runner_code contains {{USER_CODE}} which is replaced by the submitted function.
        // Falls back to running the user's code as-is when no harness is configured.
        const langConfig = LANGUAGES[language];
        const runnerCode = await fetchRunnerCode(problemId, langConfig.dbSlug);
        const finalCode = runnerCode
            ? runnerCode.replace("{{USER_CODE}}", code)
            : code;

        // ── Enqueue & wait ───────────────────────────────────────────────────────
        const result = await enqueueAndWait({ code: finalCode, language, testCases });

        return res.status(200).json(result);
    } catch (err) {
        next(err);
    }
}