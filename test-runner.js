import { processRunJob } from "./app/queue/run.processor.js";
import 'dotenv/config';

console.log("Starting test-runner...");
const data = {
    problemId: "c1000000-0000-0000-0000-000000000001",
    languageId: "a1000000-0000-0000-0000-000000000001",
    code: "print('hello')"
};
processRunJob(data).then(console.log).catch(console.error).finally(() => process.exit(0));
