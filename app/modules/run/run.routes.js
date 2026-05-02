import express from "express";
import { authMiddleware } from "../../middleware/auth.middleware.js";
import { runCode } from "./run.controller.js";

const router = express.Router();

// POST /api/run
router.post("/", authMiddleware, runCode);

export default router;
