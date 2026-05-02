import { Queue } from "bullmq";

// BullMQ requires an IORedis-compatible connection object (not the redis npm client).
// We pass host/port/family directly — BullMQ creates its own ioredis internally.
export const bullmqConnection = {
    host: process.env.REDIS_HOST || "localhost",
    port: Number(process.env.REDIS_PORT) || 6379,
    // family: 4 forces IPv4, avoids ENOTFOUND on some systems
    family: 4,
};

// The single queue all run requests are pushed into
export const codeRunQueue = new Queue("code-runs", {
    connection: bullmqConnection,
    defaultJobOptions: {
        attempts: 1,       // Don't retry user code failures
        removeOnComplete: { count: 100 },
        removeOnFail: { count: 100 },
    },
});

/**
 * Enqueue a code-run job and return the job id.
 * @param {{ code: string, language: string, testCases: Array, jobKey: string }} data
 */
export async function enqueueRun(data) {
    const job = await codeRunQueue.add("run", data, {
        // Job-level timeout as a safety net (ms) — worker also enforces per-test timeout
        timeout: 60_000,
    });
    return job.id;
}
