import dotenv from 'dotenv';
dotenv.config({ path: '../../.env' });

import { Worker } from "bullmq";
import { redisConnection } from "./redis.connection.js";
import { processRunJob } from "./run.processor.js";
import client from '../configs/db.js';

async function startWorker() {
    try {
        await client.connect();
        console.log("PostgreSQL connected in worker");
    } catch (err) {
        console.error("Worker failed to connect to DB:", err);
        process.exit(1);
    }

    console.log("Worker file loaded, initializing BullMQ...");
    const worker = new Worker(
        "run-code",
        async (job) => {
            console.log(`Processing job ${job.id}...`);
            const result = await processRunJob(job.data);
            console.log(`Job ${job.id} produced result:`, result);
            return result;
        },
        {
            connection: redisConnection
        }
    );

    worker.on('ready', () => console.log('Worker is ready and listening to Redis!'));
    worker.on('error', err => console.error('Worker error:', err));
    worker.on('failed', (job, err) => console.error(`Job ${job?.id} failed:`, err));

    process.on('SIGINT', async () => {
        console.log('\nShutting down worker gracefully...');
        await worker.close();
        await client.end();
        process.exit(0);
    });
}

startWorker();