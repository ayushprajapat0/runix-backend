import dotenv from "dotenv";
import path from "path";
import { fileURLToPath } from "url";
import { createClient } from "redis";
import { Worker } from "bullmq";
import { bullmqConnection } from "../configs/queue.js";
import { executeCode, pullImages } from "../executor/docker.js";

// Load env from backend root
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
dotenv.config({ path: path.resolve(__dirname, "../../.env") });

// ─── Redis client for writing results ────────────────────────────────────────

const redisClient = createClient({
    socket: {
        host: process.env.REDIS_HOST || "localhost",
        port: Number(process.env.REDIS_PORT) || 6379,
        reconnectStrategy: (retries) => Math.min(retries * 50, 500),
        family: 4,
    },
});

redisClient.on("error", (err) =>
    console.error("[Worker] Redis error:", err.message)
);

await redisClient.connect();
console.log("[Worker] Redis connected");

// ─── Pre-pull Docker images ──────────────────────────────────────────────────
// Must happen before the worker starts so image-download time never eats
// into per-test-case timeouts (would cause spurious time_limit_exceeded).
await pullImages();

// ─── Result TTL ───────────────────────────────────────────────────────────────

const RESULT_TTL_SECONDS = 300; // 5 minutes

// ─── BullMQ Worker ───────────────────────────────────────────────────────────

const CONCURRENCY = Number(process.env.WORKER_CONCURRENCY) || 4;

const worker = new Worker(
    "code-runs",
    async (job) => {
        const { code, language, testCases, jobKey } = job.data;

        console.log(
            `[Worker] Processing job ${job.id} — lang: ${language}, cases: ${testCases.length}`
        );

        try {
            const result = await executeCode({ code, language, testCases });

            // Persist result to Redis so the API server can pick it up
            await redisClient.set(
                `run:result:${jobKey}`,
                JSON.stringify(result),
                { EX: RESULT_TTL_SECONDS }
            );

            console.log(
                `[Worker] Job ${job.id} done — status: ${result.status} ` +
                `(${result.passedCount ?? 0}/${result.totalCount ?? 0} passed)`
            );

            return result;
        } catch (err) {
            // Write an error token so the API doesn't hang
            const errResult = {
                status: "system_error",
                error: err.message,
                passedCount: 0,
                totalCount: testCases.length,
                testResults: [],
            };
            await redisClient.set(
                `run:result:${jobKey}`,
                JSON.stringify(errResult),
                { EX: RESULT_TTL_SECONDS }
            );
            throw err; // Re-throw so BullMQ marks the job as failed
        }
    },
    {
        connection: bullmqConnection,
        concurrency: CONCURRENCY,
        limiter: {
            max: 50,          // Max 50 jobs per 10s (Docker safety valve)
            duration: 10_000,
        },
    }
);

// ─── Lifecycle hooks ──────────────────────────────────────────────────────────

worker.on("completed", (job) =>
    console.log(`[Worker] Job ${job.id} completed`)
);

worker.on("failed", (job, err) =>
    console.error(`[Worker] Job ${job?.id} failed:`, err.message)
);

worker.on("stalled", (jobId) =>
    console.warn(`[Worker] Job ${jobId} stalled — will be retried`)
);

// Graceful shutdown: drain in-flight jobs before exiting
process.on("SIGTERM", async () => {
    console.log("[Worker] SIGTERM — draining queue...");
    await worker.close();
    await redisClient.quit();
    process.exit(0);
});

process.on("SIGINT", async () => {
    console.log("[Worker] SIGINT — draining queue...");
    await worker.close();
    await redisClient.quit();
    process.exit(0);
});

console.log(`[Worker] Started — concurrency=${CONCURRENCY}`);
