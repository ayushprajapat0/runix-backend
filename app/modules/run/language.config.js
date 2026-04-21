export const languageMap = {
    python3: {
        image: "python:3.10",
        fileName: "main.py",
        run: "python main.py"
    },

    javascript: {
        image: "node:18",
        fileName: "main.js",
        run: "node main.js"
    },

    cpp: {
        image: "gcc",
        fileName: "main.cpp",
        compile: "g++ main.cpp -o main",
        run: "./main"
    }
};