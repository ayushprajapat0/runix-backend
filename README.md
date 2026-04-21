# Execution Engine (Run Module)

This module handles the core logic for executing and judging user-submitted code in a secure and isolated environment.

## Architecture & Flow

### 1. Request Reception (`run.controller.js` & `run.routes.js`)
The `run.controller.js` file receives requests at the run endpoint containing `problemId`, `languageId`, and `code`. 
Instead of blocking the request thread with heavy code execution, it constructs a payload and pushes an `execute-code` job into a Redis-managed `runQueue`. The client is immediately returned a `jobId` to poll for status.

### 2. Judging Service (`judge.service.js`)
When a background worker picks up the job from the queue, it invokes the Judge Service:
- **Language Retrieval:** Queries the database (`languages` table) using the `languageId` to fetch the specific language `slug` (e.g., `python3`, `javascript`, `cpp`).
- **Test Case Retrieval:** Queries the `test_cases` table in the database to fetch constraints/inputs and the `expected_output` linked to the submitted `problemId`.
- **Iteration:** Iterates over the test cases sequentially and requests the Execution Service to run the user's code against the test case `input`.
- **Metrics & Validation:** Monitors the returned status. If it encounters a `compile_error`, `runtime_error`, or `time_limit_exceeded`, it halts and reports failure. Otherwise, it compares the output, aggregating passed cases, and returns a final `accepted` or `wrong_answer` status.

### 3. Execution Service (`execution.service.js`)
This forms the secure backend sandbox executing the code:
- **Temporary State:** Uses Node's `fs` to allocate a temporary directory under `tmp/code-{timestamp}` and saves the code onto the filesystem as a raw file (e.g., `main.cpp`).
- **Containerization Engine:** Spawns a lightweight, ephemeral **Docker container** running dynamically via Node's `child_process.exec()`.
- **Vulnerability Sandboxing:** 
  - Restricts container memory allocation (`--memory=128m`) to prevent Heap anomalies or memory exhaustion.
  - Limits CPU constraints (`--cpus=0.5`) to curb cryptojacking or fork-bombing behavior.
  - Totally disconnects execution from any networks (`--network none`) halting unauthorized data leakage or external web-requests.
  - Secures host machine by only allowing isolation using a `/app` volume mount.
- **Cleanup:** Unconditionally destroys the `tmp` folder after stdout/stderr evaluation, and strips out the container context using the `--rm` flag.

### 4. Language Configuration (`language.config.js`)
A mapping dictating how specific languages are containerized. Variables mapped:
- `image`: Docker image baseline (e.g., `python:3.10`, `node:18`, `gcc`).
- `fileName`: Base script terminology (e.g., `main.py`).
- `compile`: Optional compilation commands for strongly-typed languages.
- `run`: How the language executes and captures standard-in (`sh -c "echo '${input}' | ${config.run}"`).

### 5. Utilities (`comparator.util.js`)
Holds the `normalize(str)` algorithm, which sanitizes text. It ensures valid code evaluates favorably by stripping trailing spaces/newlines out of standard outputs so that exact-string matching evaluates flawlessly without being interrupted by invisible typography details.
