import { Router } from "express";
import { runCodeHandler } from "./run.controller.js";
import { authMiddleware } from "../../middleware/auth.middleware.js";
const router = Router();

router.post("/", authMiddleware, runCodeHandler);

export default router;
