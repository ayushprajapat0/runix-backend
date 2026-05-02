import pool from "../../configs/db.js";
import { createClient } from "redis";
import { enqueueRun } from "../../configs/queue.js";
import { randomUUID } from "crypto";

// ─── Shared Redis client (re-uses the app-level connection if possible) ───────

let _redisClient = null;

async function getRedis() {
    if (_redisClient && _redisClient.isReady) return _redisClient;

    _redisClient = createClient({
        socket: {
            host: process.env.REDIS_HOST || "localhost",
            port: Number(process.env.REDIS_PORT) || 6379,
            reconnectStrategy: (retries) => Math.min(retries * 50, 500),
            family: 4,
        },
    });
    _redisClient.on("error", (err) =>
        console.error("[RunService] Redis error:", err.message)
    );
    await _redisClient.connect();
    return _redisClient;
}

// ─── Fetch test cases from DB ─────────────────────────────────────────────────

/**
 * Returns an array of test cases for the problem.
 * If customInput is provided, returns a single synthetic test case with
 * no expected output (user just wants to see what prints).
 */
export async function fetchTestCases(problemId, customInput) {
    if (customInput !== undefined && customInput !== null && customInput !== "") {
        return [{ id: "custom", input: String(customInput), expectedOutput: null }];
    }

    const result = await pool.query(
        `SELECT id, input, expected_output
       FROM test_cases
      WHERE problem_id = $1
      ORDER BY order_index ASC`,
        [problemId]
    );

    if (!result.rows.length) {
        throw Object.assign(new Error("No test cases found for this problem"), {
            statusCode: 404,
        });
    }

    return result.rows.map((row) => ({
        id: row.id,
        input: row.input,
        expectedOutput: row.expected_output,
    }));
}

// ─── Fetch runner harness from DB ─────────────────────────────────────────────

/**
 * Fetch the runner_code harness for a given problem + language.
 * Returns null if none is configured (caller should run user code as-is).
 *
 * @param {string} problemId  — problem UUID
 * @param {string} langSlug   — DB language slug (e.g. "java", "python3")
 */
export async function fetchRunnerCode(problemId, langSlug) {
    if (!problemId) return null;

    const result = await pool.query(
        `SELECT pt.runner_code
           FROM problem_templates pt
           JOIN languages l ON l.id = pt.language_id
          WHERE pt.problem_id = $1
            AND l.slug        = $2
          LIMIT 1`,
        [problemId, langSlug]
    );

    return result.rows[0]?.runner_code ?? null;
}


// ─── Enqueue job and poll Redis for result ────────────────────────────────────

const POLL_INTERVAL_MS = 300;  // How often to check Redis
const POLL_TIMEOUT_MS = 45_000; // Max wait before giving up

/**
 * Enqueue a code-run job and wait (polling Redis) until the worker writes
 * the result back, or until the timeout expires.
 *
 * @param {{ code: string, language: string, testCases: Array }} params
 * @returns {Promise<object>} — the execution result
 */
export async function enqueueAndWait({ code, language, testCases }) {
    // Unique key shared between this call and the worker
    const jobKey = randomUUID();
    const redisKey = `run:result:${jobKey}`;

    await enqueueRun({ code, language, testCases, jobKey });

    const redis = await getRedis();
    const deadline = Date.now() + POLL_TIMEOUT_MS;

    while (Date.now() < deadline) {
        const raw = await redis.get(redisKey);
        if (raw) {
            // Clean up immediately — worker set a 5-min TTL but no point keeping it
            await redis.del(redisKey);
            return JSON.parse(raw);
        }
        await sleep(POLL_INTERVAL_MS);
    }

    // Timed out — worker is overloaded or crashed
    return {
        status: "system_error",
        error: "Execution timed out waiting for worker",
        passedCount: 0,
        totalCount: testCases.length,
        testResults: [],
    };
}

function sleep(ms) {
    return new Promise((resolve) => setTimeout(resolve, ms));
}