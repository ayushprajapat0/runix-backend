import { Queue } from "bullmq";
import { redisConnection } from "./redis.connection.js";

export const runQueue = new Queue("run-code", {
    connection: redisConnection
});