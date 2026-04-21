import { runQueue } from "../../queue/run.queue.js";

export async function runCodeHandler(req, res) {
    const { problemId, languageId, code } = req.body;

    const job = await runQueue.add("execute-code", {
        problemId,
        languageId,
        code
    });

    return res.json({
        success: true,
        jobId: job.id,
        status: "queued"
    });
}