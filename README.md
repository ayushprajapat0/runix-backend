# codeME — Backend

A secure, scalable LeetCode-style judge backend built with **Node.js (ESM)**, **PostgreSQL**, **Redis**, **BullMQ**, and **Docker**. The API server and the code-execution worker are two separate processes connected through a Redis-backed job queue.

---

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Directory Structure](#directory-structure)
3. [Environment Variables](#environment-variables)
4. [Database Schema](#database-schema)
5. [API Reference](#api-reference)
6. [Code Execution Pipeline](#code-execution-pipeline)
7. [Queue System (BullMQ)](#queue-system-bullmq)
8. [Worker Process](#worker-process)
9. [Docker Executor & Sandboxing](#docker-executor--sandboxing)
10. [Language Configuration](#language-configuration)
11. [Submission Flow](#submission-flow)
12. [Authentication System](#authentication-system)
13. [Running Locally](#running-locally)
14. [Docker Compose (Production)](#docker-compose-production)

---

## Architecture Overview

```
┌─────────────┐   HTTP    ┌──────────────────────┐
│   Frontend  │ ────────► │   API Server          │  app/server.js
│  (React)    │           │   Express + routes    │
└─────────────┘           └──────────┬───────────┘
                                     │ enqueueRun()
                          ┌──────────▼───────────┐
                          │   BullMQ Queue        │  configs/queue.js
                          │   "code-runs"         │  (backed by Redis)
                          └──────────┬───────────┘
                                     │ job consumed
                          ┌──────────▼───────────┐
                          │   Worker Process      │  worker/run.worker.js
                          │   (separate Node.js)  │
                          └──────────┬───────────┘
                                     │ docker run
                          ┌──────────▼───────────┐
                          │   Docker Sandbox      │  executor/docker.js
                          │   (isolated container)│
                          └──────────┬───────────┘
                                     │ result written
                          ┌──────────▼───────────┐
                          │   Redis (result key)  │
                          │   run:result:<uuid>   │
                          └──────────┬───────────┘
                                     │ polled by API
                          ┌──────────▼───────────┐
                          │   API Server sends    │
                          │   response to client  │
                          └──────────────────────┘
```

**Two processes, one codebase:**

| Process | Entry point | Role |
|---------|-------------|------|
| API Server | `app/server.js` | Handles HTTP requests, enqueues jobs, polls Redis for results |
| Worker | `app/worker/run.worker.js` | Consumes jobs from the queue, runs Docker, writes results to Redis |

Both connect to the **same** PostgreSQL and Redis instances.

---

## Directory Structure

```
backend/
├── Dockerfile                  # Container image for both API and worker
├── compose.yaml                # Docker Compose: api + worker + postgres + redis
├── package.json
├── .env                        # Environment variables (not committed)
└── app/
    ├── server.js               # Entry: connects DB+Redis, starts HTTP server
    ├── app.js                  # Express app factory (routes, middleware, CORS)
    ├── configs/
    │   ├── db.js               # PostgreSQL pool (pg)
    │   ├── redis.js            # Redis client (for API-level use)
    │   ├── queue.js            # BullMQ Queue + enqueueRun() helper
    │   ├── languages.js        # Language configs, Docker images, limits
    │   ├── model.sql           # Full database schema (DDL)
    │   └── seed.sql            # Initial problem seed data
    ├── executor/
    │   └── docker.js           # Core Docker execution engine
    ├── worker/
    │   └── run.worker.js       # BullMQ worker process
    ├── middleware/
    │   └── auth.middleware.js  # JWT authentication middleware
    ├── routes/
    │   └── index.js            # Mounts all module routers under /api
    ├── modules/
    │   ├── auth/               # Signup, login, OTP, JWT, profile
    │   ├── problems/           # Problem listing, detail by slug
    │   ├── run/                # "Run code" (sample test cases or custom input)
    │   └── submissions/        # Submit code, save result, user progress
    └── utils/
        ├── jwt.js              # Access + refresh token helpers
        ├── redis.tokens.js     # Refresh token storage in Redis
        └── OtpSend.js          # Email OTP via Nodemailer
```

---

## Environment Variables

Create `.env` in the `backend/` root:

```env
# Server
PORT=5000
CLIENT_URL=http://localhost:5173

# PostgreSQL
DB_HOST=localhost
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=your_password
DB_NAME=codeme

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379

# JWT
ACCESS_TOKEN_SECRET=your_access_secret
REFRESH_TOKEN_SECRET=your_refresh_secret
ACCESS_TOKEN_EXPIRY=15m
REFRESH_TOKEN_EXPIRY=7d

# Email (for OTP)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your@gmail.com
SMTP_PASS=your_app_password

# Worker
WORKER_CONCURRENCY=4           # Parallel Docker jobs
SANDBOX_BASE_DIR=~/.judge-sandbox  # Host path mounted into containers
```

---

## Database Schema

All tables are defined in `app/configs/model.sql`.

### Tables

| Table | Purpose |
|-------|---------|
| `users` | Registered users with OTP verification state |
| `problems` | Problem metadata, description (Markdown), limits |
| `tags` | Topic tags (Array, DP, etc.) |
| `problem_tags` | M:N join: problems ↔ tags |
| `test_cases` | Input/output pairs; `is_sample=TRUE` shown to user |
| `languages` | Supported languages (Python 3, C++, Java, JS, C) |
| `problem_templates` | Per-problem starter code + runner harness per language |
| `submissions` | Submission records with status, runtime, pass count |
| `user_problem_status` | Solved/attempted tracker per user per problem |

### Key Design: `problem_templates.runner_code`

Each problem stores a **runner harness** for every language. The harness is a complete program with a `{{USER_CODE}}` placeholder where the user's function body is injected at execution time:

```
runner_code (stored in DB):
┌─────────────────────────────────────┐
│ import json, sys                    │
│                                     │
│ {{USER_CODE}}          ← replaced   │
│                                     │
│ if __name__ == '__main__':          │
│     tc = json.loads(sys.stdin...)   │
│     sol = Solution()                │
│     result = sol.twoSum(...)        │
│     print(json.dumps(result))       │
└─────────────────────────────────────┘
```

This lets users submit only the function body (LeetCode-style) while the judge wraps it in a complete executable program.

### Submission Statuses (Enum)

```
pending | running | accepted | wrong_answer |
time_limit_exceeded | memory_limit_exceeded | runtime_error | compile_error
```

### Performance Indexes

```sql
idx_submissions_user      -- fast "my submissions" queries
idx_submissions_problem   -- per-problem submission history
idx_submissions_status    -- filter by verdict
idx_problems_difficulty   -- filter problems page
idx_problems_slug         -- slug-based problem lookup (O(log n))
idx_test_cases_problem    -- fetch test cases for a problem
idx_ups_user              -- user progress dashboard
```

---

## API Reference

Base URL: `http://localhost:5000/api`

### Auth — `/api/auth`

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| POST | `/signup` | — | Register with username, email, password, fullname. Sends OTP. |
| POST | `/verify-otp` | — | Verify email with 6-digit OTP |
| POST | `/resend-otp` | — | Resend OTP to email |
| POST | `/login` | — | Login with email or username + password. Returns JWT pair in cookies. |
| POST | `/refresh-token` | — | Issue new access token using refresh token cookie |
| POST | `/logout` | — | Invalidate refresh token in Redis |
| GET | `/me` | ✅ JWT | Returns current user info |
| GET | `/profile/:username` | — | Public profile: solved counts, stats, recent submissions |
| PUT | `/profile` | ✅ JWT | Update full name or username |
| POST | `/request-email-update` | ✅ JWT | Send OTP to new email address |
| POST | `/verify-email-update` | ✅ JWT | Confirm email change with OTP |

### Problems — `/api/problems`

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| GET | `/` | — | Paginated list with filters: `?difficulty=easy&tags=array&search=sum&sort=acceptance&page=1&limit=10` |
| GET | `/:slug` | — | Full problem detail: description, sample cases, starter code per language |

### Run — `/api/run`

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| POST | `/` | — | Run code against sample test cases or custom input. Enqueues job, polls Redis, returns results. |

**Request body:**
```json
{
  "code": "class Solution:\n    def twoSum...",
  "language": "python",
  "problemId": "uuid",
  "customInput": "optional raw stdin string"
}
```

**Response:**
```json
{
  "status": "accepted",
  "passedCount": 3,
  "totalCount": 3,
  "maxElapsedMs": 142,
  "testResults": [
    {
      "id": "tc-uuid",
      "status": "accepted",
      "stdout": "[0,1]",
      "stderr": "",
      "expectedOutput": "[0,1]",
      "elapsedMs": 142,
      "passed": true
    }
  ]
}
```

### Submissions — `/api/submissions`

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| POST | `/` | ✅ JWT | Submit code against ALL test cases. Saves result + updates user progress. |
| GET | `/` | ✅ JWT | Get user's submission history. Optional `?problemId=uuid` filter. |

---

## Code Execution Pipeline

This is the most critical path. Here is the full flow step by step:

```
POST /api/run  or  POST /api/submissions
          │
          ▼
1. Validate request (code ≤ 64KB, language supported, problemId present)
          │
          ▼
2. fetchTestCases(problemId)
   → SELECT from test_cases WHERE problem_id = ?
   → For /run: only sample cases (or single custom input case)
   → For /submit: ALL test cases
          │
          ▼
3. fetchRunnerCode(problemId, languageSlug)
   → SELECT runner_code FROM problem_templates JOIN languages ...
   → Returns the harness template string (or null)
          │
          ▼
4. Inject user code into harness:
   finalCode = runnerCode.replace("{{USER_CODE}}", userCode)
          │
          ▼
5. enqueueAndWait({ code: finalCode, language, testCases })
   → generates a unique jobKey (UUID)
   → pushes job to BullMQ "code-runs" queue
   → polls Redis key "run:result:<jobKey>" every 300ms
   → timeout after 45s
          │
          ▼  [crosses process boundary — worker picks up job]
          │
          ▼
6. Worker: executeCode({ code, language, testCases })
          │
          ▼
7. createSandboxDir(code, filename)
   → mkdtemp under ~/.judge-sandbox/
   → writes finalCode to solution.py / solution.js / solution.cpp / Main.java
          │
          ▼
8. [C++/Java only] compileInDocker()
   → docker run --rm ... gcc:13 g++ -O2 -o /code/solution /code/solution.cpp
   → docker run --rm ... eclipse-temurin:17 javac /code/Main.java
   → on failure: return { status: "compile_error", compileError: stderr }
          │
          ▼
9. For each test case: runTestCase()
   → spawn docker run with stdin = test case input JSON
   → collect stdout/stderr, enforce timeout via SIGKILL
   → compare normalizeOutput(stdout) vs normalizeOutput(expectedOutput)
   → assign status: accepted | wrong_answer | runtime_error | TLE | MLE
          │
          ▼
10. cleanupDir(sandboxDir) — always runs (finally block)
          │
          ▼
11. Worker writes result to Redis: SET run:result:<jobKey> <json> EX 300
          │
          ▼
12. API server polls, finds result, deletes Redis key, returns HTTP 200
          │
          ▼
13. [Submissions only] saveSubmissionResult() → INSERT into submissions
    updateUserProblemStatus() → UPSERT user_problem_status
```

---

## Queue System (BullMQ)

**File:** `app/configs/queue.js`

BullMQ is backed by Redis and handles job queuing, retries, and concurrency control.

```js
// Queue definition
const codeRunQueue = new Queue("code-runs", {
  connection: bullmqConnection,   // { host, port, family: 4 }
  defaultJobOptions: {
    attempts: 1,                  // No retries for user code failures
    removeOnComplete: { count: 100 },
    removeOnFail:     { count: 100 },
  },
});

// Enqueue a job
await codeRunQueue.add("run", { code, language, testCases, jobKey }, {
  timeout: 60_000,   // Job-level safety net (60s)
});
```

**Job payload:**
```json
{
  "code": "...final wrapped code...",
  "language": "python",
  "testCases": [{ "id": "uuid", "input": "{...}", "expectedOutput": "[0,1]" }],
  "jobKey": "550e8400-e29b-41d4-a716-446655440000"
}
```

**Result polling (in `run.service.js`):**
```js
// API server polls Redis every 300ms up to 45s
while (Date.now() < deadline) {
  const raw = await redis.get(`run:result:${jobKey}`);
  if (raw) {
    await redis.del(redisKey);    // clean up immediately
    return JSON.parse(raw);
  }
  await sleep(300);
}
```

---

## Worker Process

**File:** `app/worker/run.worker.js`

The worker is a **standalone Node.js process** — completely separate from the API server. It must be started independently.

### Startup sequence

1. Load `.env` from backend root
2. Connect to Redis (separate client from the API server's)
3. **Pull all Docker images** (`pullImages()`) — waits for all images to be cached before accepting any jobs. This prevents image-download time from eating into per-test-case timeouts.
4. Start BullMQ Worker listening on `"code-runs"` queue

### Worker configuration

```js
const worker = new Worker("code-runs", processor, {
  connection: bullmqConnection,
  concurrency: WORKER_CONCURRENCY,  // default 4 (env: WORKER_CONCURRENCY)
  limiter: {
    max: 50,          // max 50 jobs per 10 seconds (Docker safety valve)
    duration: 10_000,
  },
});
```

### Job processing

```js
async (job) => {
  const { code, language, testCases, jobKey } = job.data;

  const result = await executeCode({ code, language, testCases });

  await redisClient.set(
    `run:result:${jobKey}`,
    JSON.stringify(result),
    { EX: 300 }   // 5-minute TTL
  );

  return result;
}
```

### Error handling

If `executeCode` throws, the worker writes an error token to Redis (so the API doesn't hang on polling) then re-throws so BullMQ marks the job as `failed`.

### Lifecycle / Graceful shutdown

```js
process.on("SIGTERM", async () => {
  await worker.close();     // drain in-flight jobs
  await redisClient.quit();
  process.exit(0);
});
```

### Lifecycle events logged

| Event | Log |
|-------|-----|
| Job starts | `[Worker] Processing job 42 — lang: python, cases: 3` |
| Job done | `[Worker] Job 42 done — status: accepted (3/3 passed)` |
| Job completed | `[Worker] Job 42 completed` |
| Job failed | `[Worker] Job 42 failed: <error message>` |
| Job stalled | `[Worker] Job 42 stalled — will be retried` |

---

## Docker Executor & Sandboxing

**File:** `app/executor/docker.js`

This module is responsible for safely running untrusted user code inside isolated Docker containers.

### Sandbox directory

```js
const SANDBOX_BASE = process.env.SANDBOX_BASE_DIR
  || path.join(os.homedir(), ".judge-sandbox");
```

For every job, a **unique temporary directory** is created:
```js
const dir = await fs.mkdtemp(path.join(SANDBOX_BASE, "judge-"));
// e.g. ~/.judge-sandbox/judge-x7k2pQ/
await fs.writeFile(path.join(dir, filename), code, "utf8");
```

This directory is mounted read-only into the container (`/code:ro`), except during compilation where write access is needed so the compiler can output the binary.

### Docker run arguments (security flags)

```js
[
  "run",
  "--rm",                           // auto-remove container after exit
  "-i",                             // keep stdin open
  "--network", "none",              // NO network access
  "--memory", `${limits.memoryMb}m`,
  "--memory-swap", `${limits.memoryMb}m`,  // disable swap
  "--cpus", String(limits.cpus),    // CPU throttle
  "--pids-limit", String(limits.pidsLimit), // prevent fork bombs
  "--read-only",                    // read-only root filesystem
  "--tmpfs", "/tmp:size=64m",       // writable /tmp (no exec by default)
  "--cap-drop", "ALL",              // drop ALL Linux capabilities
  "--security-opt", "no-new-privileges",
  "-v", `${sandboxDir}:/code:ro`,   // user code (read-only)
  "-w", "/code",
  image,
  ...cmd,                           // e.g. ["python3", "solution.py"]
]
```

### Security model summary

| Protection | Mechanism |
|------------|-----------|
| No internet | `--network none` |
| Memory cap | `--memory` + `--memory-swap` |
| CPU cap | `--cpus` |
| No fork bombs | `--pids-limit 50` |
| No root escalation | `--cap-drop ALL` + `no-new-privileges` |
| No filesystem writes | `--read-only` (only `/tmp` writable) |
| No code persistence | Container auto-removed (`--rm`), sandbox dir deleted in `finally` |
| Timeout enforcement | `SIGKILL` sent after `limits.timeoutMs` ms |

### Compilation step (C++ and Java only)

```js
async function compileInDocker({ image, compileCmd, limits, sandboxDir }) {
  // readOnlyCode: false — compiler writes output binary/class files
  const args = buildDockerArgs({ ..., readOnlyCode: false });
  await execFileAsync("docker", args, { timeout: 30_000 });
}
```

- **C++:** `g++ -O2 -o /code/solution solution.cpp`
- **Java:** `javac Main.java`

On failure, `compileError: stderr` is returned immediately without running any test cases.

### Running a test case

Each test case runs in its **own container** (fresh isolated environment):

```js
function runTestCase({ image, runCmd, limits, sandboxDir, stdin }) {
  const child = spawn("docker", args);

  child.stdin.write(String(stdin));  // JSON-encoded test case input
  child.stdin.end();

  const timer = setTimeout(() => {
    timedOut = true;
    child.kill("SIGKILL");
  }, limits.timeoutMs);

  // Stream stdout/stderr, enforce maxOutputBytes (10KB)
  child.stdout.on("data", chunk => { stdout += chunk; ... });
  child.stderr.on("data", chunk => { stderr += chunk; });

  child.on("close", (exitCode) => resolve({
    stdout, stderr, exitCode,
    elapsedMs: Date.now() - startMs,
    timedOut,
    memoryExceeded: exitCode === 137,  // OOM killer exit code
  }));
}
```

### Output normalization

Before comparing, both actual and expected output are normalized:

```js
function normalizeOutput(str) {
  // 1. Trim trailing whitespace from each line
  // 2. Trim leading/trailing whitespace from the whole string
  // 3. If valid JSON, re-serialize (removes spacing differences)
  try {
    return JSON.stringify(JSON.parse(trimmed));
  } catch {
    return trimmed;  // plain string comparison
  }
}
```

This handles differences like `[0, 1]` vs `[0,1]` correctly.

### Verdict assignment logic

| Condition | Verdict |
|-----------|---------|
| `timedOut === true` | `time_limit_exceeded` |
| `exitCode === 137` | `memory_limit_exceeded` |
| `exitCode !== 0` | `runtime_error` |
| output mismatch | `wrong_answer` |
| all pass | `accepted` |

The overall job status is the worst verdict seen across all test cases (precedence: TLE/MLE > compile_error > runtime_error > wrong_answer > accepted).

---

## Language Configuration

**File:** `app/configs/languages.js`

```js
const LANGUAGES = {
  python: {
    image: "python:3.11-alpine",
    filename: "solution.py",
    runCmd: (file) => ["python3", file],
    // no compileCmd — interpreted
  },
  javascript: {
    image: "node:18-alpine",
    filename: "solution.js",
    runCmd: (file) => ["node", file],
  },
  cpp: {
    image: "gcc:13-bookworm",
    filename: "solution.cpp",
    compileCmd: (file) => ["g++", "-O2", "-o", "/code/solution", file],
    runCmd: () => ["/code/solution"],
  },
  java: {
    image: "eclipse-temurin:17-jdk-alpine",
    filename: "Main.java",
    compileCmd: (file) => ["javac", file],
    runCmd: () => ["java", "-cp", "/code", "Main"],
  },
};
```

### Resource limits

| Limit | Default | Java override |
|-------|---------|--------------|
| Memory | 256 MB | 512 MB |
| CPU | 0.5 cores | 0.5 cores |
| Timeout | 5,000 ms | 10,000 ms |
| Max output | 10 KB | 10 KB |
| Max PIDs | 50 | 50 |

---

## Submission Flow

The submission flow extends the run flow with persistence:

```
POST /api/submissions
          │
          ▼
1-12. [Same as run flow — all test cases, not just samples]
          │
          ▼
13. saveSubmissionResult()
    INSERT INTO submissions (user_id, problem_id, language_id, code,
    status, runtime_ms, passed_test_cases, total_test_cases, ...)
          │
          ▼
14. updateUserProblemStatus()
    UPSERT INTO user_problem_status
    - status = 'solved' if accepted, else 'attempted'
    - Once 'solved', status never reverts to 'attempted'
    - Tracks best_runtime_ms (LEAST of all accepted runs)
    - Records first_solved_at timestamp
          │
          ▼
15. Return { submissionId, status, passedCount, totalCount, testResults }
```

---

## Authentication System

**JWT-based with refresh token rotation stored in Redis.**

### Token pair

| Token | Storage | Expiry | Purpose |
|-------|---------|--------|---------|
| `accessToken` | HTTP-only cookie | 15 min | Authenticate API requests |
| `refreshToken` | HTTP-only cookie + Redis | 7 days | Issue new access tokens |

### Middleware (`auth.middleware.js`)

```js
// Accepts token from cookie OR Authorization: Bearer header
const token = req.cookies?.accessToken
  || req.headers.authorization?.split(" ")[1];

const payload = verifyAccessToken(token);
req.user = { id, username, email };  // available in all protected handlers
```

### OTP Email Verification

- Signup generates a 6-digit OTP, stores it in `users.otp` with 10-minute expiry
- OTP sent via Nodemailer (configurable SMTP)
- `POST /verify-otp` sets `is_verified = TRUE`, clears OTP columns
- Login blocked if `is_verified = FALSE`
- Same OTP mechanism used for email change requests (`pending_email` column)

---

## Running Locally

### Prerequisites

- Node.js ≥ 20
- PostgreSQL 15 running on port 5432
- Redis 7 running on port 6379
- Docker Desktop or Docker Engine (worker spawns containers)

### Setup

```bash
# 1. Install dependencies
cd backend
npm install

# 2. Create database
psql -U postgres -c "CREATE DATABASE codeme;"

# 3. Apply schema
PGPASSWORD=your_password psql -h localhost -U postgres -d codeme -f app/configs/model.sql

# 4. Seed problems (optional — one file per problem)
PGPASSWORD=your_password psql -h localhost -U postgres -d codeme -f ../dbproblems/twosum.sql

# 5. Configure environment
cp .env.example .env    # then fill in your values
```

### Start API server

```bash
nodemon app/server.js
# or
node app/server.js

# Logs:
# PostgreSQL connected
# Redis connected
# Server running on port 5000
```

### Start Worker (separate terminal)

```bash
nodemon app/worker/run.worker.js
# or
node app/worker/run.worker.js

# Logs:
# [Worker] Redis connected
# [Executor] Pre-pulling Docker images: python:3.11-alpine, node:18-alpine, ...
# [Executor] ✓ python:3.11-alpine ready
# [Worker] Started — concurrency=4
```

> **Both processes must be running** for code execution to work. The API server enqueues jobs; the worker runs them.

### Health check

```bash
curl http://localhost:5000/health
# {"status":"ok","timestamp":"2026-05-02T08:45:00.000Z"}
```

---

## Docker Compose (Production)

The `compose.yaml` defines **four services**: `api`, `worker`, `db`, `redis`.

```bash
# Build and start all services
docker compose up --build

# Start detached
docker compose up -d --build

# View logs
docker compose logs -f api
docker compose logs -f worker

# Stop all
docker compose down
```

### Service summary

| Service | Image | Port | Notes |
|---------|-------|------|-------|
| `api` | Built from Dockerfile | 5000 | Express HTTP server |
| `worker` | Built from Dockerfile | — | `node app/worker/run.worker.js` |
| `db` | `postgres:15-alpine` | 5432 | Persistent volume |
| `redis` | `redis:7-alpine` | 6379 | Session + job queue |

Both `api` and `worker` mount `/var/run/docker.sock` so they can spawn sibling containers for code execution (Docker-out-of-Docker pattern).

```yaml
volumes:
  - /var/run/docker.sock:/var/run/docker.sock
```

### Health checks

Both `api` and `worker` wait for `db` and `redis` to pass health checks before starting (`condition: service_healthy`), preventing startup race conditions.

---

## Key Design Decisions

| Decision | Rationale |
|----------|-----------|
| Two-process architecture | Worker can crash/restart without affecting API availability |
| Redis polling (not WebSocket) | Simple, stateless; works with any load balancer |
| Per-test-case containers | Complete isolation; one infinite loop can't affect other test cases |
| `--network none` | Prevents any outbound network calls from user code |
| `{{USER_CODE}}` harness pattern | LeetCode-style: users write only the function body |
| `ON CONFLICT DO NOTHING` in seeds | Idempotent — safe to re-run seed files |
| `attempts: 1` in BullMQ | User code failures are expected; no point retrying |
| `normalizeOutput` JSON re-serialization | Ignores cosmetic spacing differences in array/object output |
