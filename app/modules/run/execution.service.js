import fs from "fs";
import path from "path";
import { exec } from "child_process";
import { languageMap } from "./language.config.js";

export async function runCode(languageSlug, code, input) {
    const config = languageMap[languageSlug];

    if (!config) {
        return {
            status: "runtime_error",
            error: "Unsupported language"
        };
    }

    const dir = `/tmp/code-${Date.now()}`;
    fs.mkdirSync(dir);

    const filePath = path.join(dir, config.fileName);
    fs.writeFileSync(filePath, code);

    let command = `
    docker run --rm \
    -v ${dir}:/app \
    -w /app \
    --memory=128m \
    --cpus=0.5 \
    --network none \
    ${config.image} \
  `;

    if (config.compile) {
        command += `sh -c "${config.compile} && echo '${input}' | ${config.run}"`;
    } else {
        command += `sh -c "echo '${input}' | ${config.run}"`;
    }

    console.log(`[Execution] Running command: ${command}`);

    return new Promise((resolve) => {
        exec(command, { timeout: 2000 }, (error, stdout, stderr) => {
            console.log(`[Execution] Callback fired! err: ${error?.message}, killed: ${error?.killed}`);
            fs.rmSync(dir, { recursive: true, force: true });

            if (error?.killed) {
                return resolve({
                    status: "time_limit_exceeded"
                });
            }

            if (stderr) {
                if (config.compile && !stdout) {
                    return resolve({
                        status: "compile_error",
                        error: stderr
                    });
                }

                return resolve({
                    status: "runtime_error",
                    error: stderr
                });
            }

            resolve({
                status: "success",
                output: stdout.trim()
            });
        });
    });
}