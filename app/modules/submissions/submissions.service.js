import pool from "../../configs/db.js";

// Fetch submission history for a user
export async function getUserSubmissions(userId, problemId = null) {
    let query = `
        SELECT s.id, s.problem_id, s.status, s.runtime_ms, s.memory_kb, 
               s.passed_test_cases, s.total_test_cases, s.created_at, s.language_id,
               l.name AS language_name, p.title AS problem_title
        FROM submissions s
        JOIN languages l ON l.id = s.language_id
        JOIN problems p ON p.id = s.problem_id
        WHERE s.user_id = $1
    `;
    const params = [userId];

    if (problemId) {
        query += ` AND s.problem_id = $2`;
        params.push(problemId);
    }

    query += ` ORDER BY s.created_at DESC LIMIT 50`;

    const result = await pool.query(query, params);
    return result.rows;
}

// Save the execution result to the DB
export async function saveSubmissionResult({
    userId, problemId, languageSlug, code, status, runtimeMs, memoryKb, 
    errorMessage, passedTestCases, totalTestCases
}) {
    const query = `
        INSERT INTO submissions (
            user_id, problem_id, language_id, code, status, 
            runtime_ms, memory_kb, error_message, passed_test_cases, total_test_cases
        )
        VALUES (
            $1, 
            $2, 
            (SELECT id FROM languages WHERE slug = $3), 
            $4, $5, $6, $7, $8, $9, $10
        )
        RETURNING id, created_at
    `;
    const params = [
        userId, problemId, languageSlug, code, status, 
        runtimeMs || null, memoryKb || null, errorMessage || null, 
        passedTestCases || 0, totalTestCases || 0
    ];

    const result = await pool.query(query, params);
    return result.rows[0];
}

// Update the user's progress for this problem
export async function updateUserProblemStatus({
    userId, problemId, status, runtimeMs, memoryKb
}) {
    const problemStatus = status === 'accepted' ? 'solved' : 'attempted';
    
    const query = `
        INSERT INTO user_problem_status (
            user_id, problem_id, status, best_runtime_ms, best_memory_kb, first_solved_at, last_attempted_at
        ) VALUES (
            $1, $2, $3::varchar, 
            CASE WHEN $3::varchar = 'solved' THEN $4::int ELSE NULL END, 
            CASE WHEN $3::varchar = 'solved' THEN $5::int ELSE NULL END,
            CASE WHEN $3::varchar = 'solved' THEN CURRENT_TIMESTAMP ELSE NULL END,
            CURRENT_TIMESTAMP
        )
        ON CONFLICT (user_id, problem_id) DO UPDATE SET
            status = CASE 
                        WHEN user_problem_status.status = 'solved' THEN 'solved' 
                        ELSE EXCLUDED.status 
                     END,
            last_attempted_at = CURRENT_TIMESTAMP,
            first_solved_at = CASE 
                                WHEN EXCLUDED.status = 'solved' AND user_problem_status.first_solved_at IS NULL 
                                THEN CURRENT_TIMESTAMP 
                                ELSE user_problem_status.first_solved_at 
                              END,
            best_runtime_ms = CASE 
                                WHEN EXCLUDED.status = 'solved' THEN 
                                    LEAST(user_problem_status.best_runtime_ms, EXCLUDED.best_runtime_ms)
                                ELSE user_problem_status.best_runtime_ms
                              END,
            best_memory_kb = CASE 
                                WHEN EXCLUDED.status = 'solved' THEN 
                                    LEAST(user_problem_status.best_memory_kb, EXCLUDED.best_memory_kb)
                                ELSE user_problem_status.best_memory_kb
                             END
    `;

    const params = [userId, problemId, problemStatus, runtimeMs || null, memoryKb || null];
    await pool.query(query, params);
}
