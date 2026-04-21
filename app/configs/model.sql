-- ─────────────────────────────────────────
-- Fix the users table (otp column typo)
-- ─────────────────────────────────────────
CREATE TABLE users (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username    VARCHAR(50)  UNIQUE NOT NULL,
    email       VARCHAR(255) UNIQUE NOT NULL,
    password    TEXT NOT NULL,
    full_name   VARCHAR(100),
    is_verified BOOLEAN DEFAULT FALSE,
    otp         INTEGER,                          -- 6-digit OTP
    otp_expires_at TIMESTAMP,                     -- expiry for OTP
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ─────────────────────────────────────────
-- Difficulty enum
-- ─────────────────────────────────────────
CREATE TYPE difficulty_level AS ENUM ('easy', 'medium', 'hard');

-- ─────────────────────────────────────────
-- Submission status enum
-- ─────────────────────────────────────────
CREATE TYPE submission_status AS ENUM (
    'pending',
    'running',
    'accepted',
    'wrong_answer',
    'time_limit_exceeded',
    'memory_limit_exceeded',
    'runtime_error',
    'compile_error'
);

-- ─────────────────────────────────────────
-- Problems
-- ─────────────────────────────────────────
CREATE TABLE problems (
    id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title             VARCHAR(200) UNIQUE NOT NULL,
    slug              VARCHAR(200) UNIQUE NOT NULL,     -- e.g. "two-sum"
    description       TEXT NOT NULL,                   -- supports Markdown/HTML
    difficulty        difficulty_level NOT NULL,
    is_published      BOOLEAN DEFAULT FALSE,
    time_limit_ms     INTEGER DEFAULT 2000,             -- execution time limit
    memory_limit_kb   INTEGER DEFAULT 262144,           -- 256 MB default
    total_submissions INTEGER DEFAULT 0,
    total_accepted    INTEGER DEFAULT 0,
    created_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ─────────────────────────────────────────
-- Tags  (e.g. "Arrays", "Dynamic Programming")
-- ─────────────────────────────────────────
CREATE TABLE tags (
    id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(50) UNIQUE NOT NULL,
    slug VARCHAR(50) UNIQUE NOT NULL
);

-- Junction: problems ↔ tags (M:N)
CREATE TABLE problem_tags (
    problem_id UUID REFERENCES problems(id) ON DELETE CASCADE,
    tag_id     UUID REFERENCES tags(id)     ON DELETE CASCADE,
    PRIMARY KEY (problem_id, tag_id)
);

-- ─────────────────────────────────────────
-- Test Cases
-- ─────────────────────────────────────────
CREATE TABLE test_cases (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    problem_id      UUID NOT NULL REFERENCES problems(id) ON DELETE CASCADE,
    input           TEXT NOT NULL,
    expected_output TEXT NOT NULL,
    is_sample       BOOLEAN DEFAULT FALSE,   -- TRUE = shown to user as example
    explanation     TEXT,                    -- shown only for sample cases
    order_index     INTEGER DEFAULT 0,       -- controls display order
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ─────────────────────────────────────────
-- Languages  (Python 3, JavaScript, C++, Java …)
-- ─────────────────────────────────────────
CREATE TABLE languages (
    id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name      VARCHAR(50) UNIQUE NOT NULL,   -- "Python 3"
    slug      VARCHAR(50) UNIQUE NOT NULL,   -- "python3"
    version   VARCHAR(20),                   -- "3.11"
    is_active BOOLEAN DEFAULT TRUE
);

-- ─────────────────────────────────────────
-- Problem Templates  (starter code per language)
-- ─────────────────────────────────────────
CREATE TABLE problem_templates (
    id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    problem_id    UUID NOT NULL REFERENCES problems(id)  ON DELETE CASCADE,
    language_id   UUID NOT NULL REFERENCES languages(id) ON DELETE CASCADE,
    starter_code  TEXT NOT NULL,    -- shown in the editor
    solution_code TEXT,             -- hidden; used by the judge
    UNIQUE (problem_id, language_id)
);

-- ─────────────────────────────────────────
-- Submissions
-- ─────────────────────────────────────────
CREATE TABLE submissions (
    id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id            UUID NOT NULL REFERENCES users(id)     ON DELETE CASCADE,
    problem_id         UUID NOT NULL REFERENCES problems(id)  ON DELETE CASCADE,
    language_id        UUID NOT NULL REFERENCES languages(id),
    code               TEXT NOT NULL,
    status             submission_status NOT NULL DEFAULT 'pending',
    runtime_ms         INTEGER,           -- NULL until judged
    memory_kb          INTEGER,
    error_message      TEXT,              -- compile / runtime error output
    passed_test_cases  INTEGER DEFAULT 0,
    total_test_cases   INTEGER DEFAULT 0,
    created_at         TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ─────────────────────────────────────────
-- User Problem Status  (solved / attempted tracker)
-- ─────────────────────────────────────────
CREATE TABLE user_problem_status (
    user_id           UUID REFERENCES users(id)    ON DELETE CASCADE,
    problem_id        UUID REFERENCES problems(id) ON DELETE CASCADE,
    status            VARCHAR(20) DEFAULT 'attempted',  -- 'attempted' | 'solved'
    best_runtime_ms   INTEGER,
    best_memory_kb    INTEGER,
    first_solved_at   TIMESTAMP,
    last_attempted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, problem_id)
);

-- ─────────────────────────────────────────
-- Indexes for common query patterns
-- ─────────────────────────────────────────
CREATE INDEX idx_submissions_user      ON submissions(user_id);
CREATE INDEX idx_submissions_problem   ON submissions(problem_id);
CREATE INDEX idx_submissions_status    ON submissions(status);
CREATE INDEX idx_problems_difficulty   ON problems(difficulty);
CREATE INDEX idx_problems_slug         ON problems(slug);
CREATE INDEX idx_test_cases_problem    ON test_cases(problem_id);
CREATE INDEX idx_ups_user              ON user_problem_status(user_id);