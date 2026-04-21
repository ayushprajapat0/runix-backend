import { judgeCode } from "../modules/run/judge.service.js";

export async function processRunJob(data) {
    const { problemId, languageId, code } = data;

    const result = await judgeCode(problemId, languageId, code);

    return result;
}