
const LANGUAGES = {
    python: {
        dbSlug: "python3",
        image: "python:3.11-alpine",
        filename: "solution.py",
        runCmd: (file) => ["python3", file],
    },

    javascript: {
        dbSlug: "javascript",
        image: "node:18-alpine",
        filename: "solution.js",
        runCmd: (file) => ["node", file],
    },

    cpp: {
        dbSlug: "cpp",
        image: "gcc:13-bookworm",
        filename: "solution.cpp",
        compileCmd: (file) => ["g++", "-O2", "-o", "/code/solution", file],
        runCmd: () => ["/code/solution"],
    },

    java: {
        dbSlug: "java",
        image: "eclipse-temurin:17-jdk-alpine",
        filename: "Main.java",
        compileCmd: (file) => ["javac", file],
        runCmd: () => ["java", "-cp", "/code", "Main"],
    },
};

const DEFAULT_LIMITS = {
    memoryMb: 256,
    cpus: 0.5,
    timeoutMs: 5000,
    maxOutputBytes: 10240,
    pidsLimit: 50,
};

const LANGUAGE_LIMITS = {
    java: { memoryMb: 512, timeoutMs: 10000 },
    cpp: { memoryMb: 256, timeoutMs: 5000 },
};

function getLanguageConfig(lang) {
    const config = LANGUAGES[lang];
    if (!config) {
        const supported = Object.keys(LANGUAGES).join(", ");
        throw new Error(`Unsupported language: "${lang}". Supported: ${supported}`);
    }
    const limits = { ...DEFAULT_LIMITS, ...(LANGUAGE_LIMITS[lang] || {}) };
    return { ...config, limits };
}

export { getLanguageConfig, LANGUAGES };
