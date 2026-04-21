import client from "../../configs/db.js";
import { runCode } from "./execution.service.js";
import { normalize } from "./comparator.util.js";

export async function judgeCode(problemId, languageId, code) {
    console.log(`[Judge] Querying language for id ${languageId}`);
    const languageQuery = await client.query(
        `SELECT slug FROM languages WHERE id = $1`,
        [languageId]
    );

    console.log(`[Judge] Language query complete:`, languageQuery.rows);
    const languageSlug = languageQuery.rows[0].slug;

    console.log(`[Judge] Querying test cases for problem id ${problemId}`);
    const testCaseQuery = await client.query(
        `SELECT input, expected_output
     FROM test_cases
     WHERE problem_id = $1
     ORDER BY order_index
     LIMIT 2`,
        [problemId]
    );

    const testCases = testCaseQuery.rows;
    console.log(`[Judge] Found ${testCases.length} test cases`);

    let passed = 0;
    let results = [];

    for (let i = 0; i < testCases.length; i++) {
        const testCase = testCases[i];

        const executionResult = await runCode(
            languageSlug,
            code,
            testCase.input
        );

        if (executionResult.status === "compile_error") {
            return {
                status: "compile_error",
                error: executionResult.error
            };
        }

        if (executionResult.status === "runtime_error") {
            return {
                status: "runtime_error",
                error: executionResult.error
            };
        }

        if (executionResult.status === "time_limit_exceeded") {
            return {
                status: "time_limit_exceeded"
            };
        }

        const expected = normalize(testCase.expected_output);
        const actual = normalize(executionResult.output);

        if (expected !== actual) {
            return {
                status: "wrong_answer",
                failedCase: i + 1,
                expected,
                got: actual
            };
        }

        passed++;

        results.push({
            case: i + 1,
            status: "passed"
        });
    }

    return {
        status: "accepted",
        passed,
        total: testCases.length,
        results
    };
}