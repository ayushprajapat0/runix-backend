import client from '../../configs/db.js';

const VALID_DIFFICULTIES = ['easy', 'medium', 'hard'];
const MAX_LIMIT = 50;

const SORT_MAP = {
    newest: 'p.created_at DESC',
    acceptance: 'acceptance_rate DESC NULLS LAST',
    difficulty: "CASE p.difficulty WHEN 'easy' THEN 1 WHEN 'medium' THEN 2 WHEN 'hard' THEN 3 END ASC",
};

export const getAllProblemsService = async ({ page = 1, limit = 10, difficulty, tags, search, sort = 'newest' }) => {
    const pageNum = Math.max(1, parseInt(page, 10));
    const limitNum = Math.min(MAX_LIMIT, Math.max(1, parseInt(limit, 10)));
    const offset = (pageNum - 1) * limitNum;
    const orderBy = SORT_MAP[sort] || SORT_MAP.newest;

    // shared SELECT expressions
    const tagAgg = `
        COALESCE(
            json_agg(DISTINCT jsonb_build_object('id', t.id, 'name', t.name, 'slug', t.slug))
            FILTER (WHERE t.id IS NOT NULL),
        '[]') AS tags`;

    const acceptRate = `
        ROUND(p.total_accepted::numeric / NULLIF(p.total_submissions, 0) * 100, 1)
        AS acceptance_rate`;

    const baseJoin = `
        FROM problems p
        LEFT JOIN problem_tags pt ON p.id = pt.problem_id
        LEFT JOIN tags t          ON pt.tag_id = t.id
        WHERE p.is_published = TRUE`;

    const params = [];
    let idx = 1;
    let filters = '';

    if (difficulty && VALID_DIFFICULTIES.includes(difficulty)) {
        filters += ` AND p.difficulty = $${idx++}`;
        params.push(difficulty);
    }

    if (search && search.trim()) {
        filters += ` AND p.title ILIKE $${idx++}`;
        params.push(`%${search.trim()}%`);
    }

    if (tags && tags.trim()) {
        const tagsArr = tags.split(',').map(s => s.trim()).filter(Boolean);
        if (tagsArr.length) {
            filters += ` AND t.slug = ANY($${idx++})`;
            params.push(tagsArr);
        }
    }

    const countQuery = `SELECT COUNT(DISTINCT p.id) ${baseJoin}${filters}`;

    const listQuery = `
        SELECT p.id, p.title, p.slug, p.difficulty,
               p.total_submissions, p.total_accepted,
               ${acceptRate},
               ${tagAgg}
        ${baseJoin}${filters}
        GROUP BY p.id
        ORDER BY ${orderBy}
        LIMIT $${idx} OFFSET $${idx + 1}`;

    const [countResult, listResult] = await Promise.all([
        client.query(countQuery, params),
        client.query(listQuery, [...params, limitNum, offset]),
    ]);

    return {
        total: parseInt(countResult.rows[0].count, 10),
        page: pageNum,
        limit: limitNum,
        problems: listResult.rows,
    };
};

export const getProblemService = async (slug) => {
    const query = `
        SELECT p.id, p.title, p.slug, p.description, p.difficulty,
               p.time_limit_ms, p.memory_limit_kb,
               p.total_submissions, p.total_accepted,
               ROUND(p.total_accepted::numeric / NULLIF(p.total_submissions, 0) * 100, 1) AS acceptance_rate,
               COALESCE(
                   json_agg(DISTINCT jsonb_build_object('id', t.id, 'name', t.name, 'slug', t.slug))
                   FILTER (WHERE t.id IS NOT NULL),
               '[]') AS tags,
               COALESCE(
                   json_agg(
                       DISTINCT jsonb_build_object(
                           'input', tc.input,
                           'expected_output', tc.expected_output,
                           'explanation', tc.explanation,
                           'order_index', tc.order_index
                       )
                   ) FILTER (WHERE tc.id IS NOT NULL AND tc.is_sample = TRUE),
               '[]') AS sample_test_cases,
               COALESCE(
                   (SELECT json_object_agg(l.slug, pt_tmpl.starter_code)
                    FROM problem_templates pt_tmpl
                    JOIN languages l ON pt_tmpl.language_id = l.id
                    WHERE pt_tmpl.problem_id = p.id),
               '{}'::json) AS starter_code
        FROM problems p
        LEFT JOIN problem_tags pt ON p.id = pt.problem_id
        LEFT JOIN tags t          ON pt.tag_id = t.id
        LEFT JOIN test_cases tc   ON p.id = tc.problem_id
        WHERE p.slug = $1 AND p.is_published = TRUE
        GROUP BY p.id`;

    const result = await client.query(query, [slug]);
    return result.rows[0] ?? null;
};
