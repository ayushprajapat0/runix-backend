import { Router } from 'express';
import { submitCode, getUserSubmissions } from './submissions.controller.js';
import { authMiddleware } from '../../middleware/auth.middleware.js';

const router = Router();

// Apply authentication middleware to all submission routes
router.use(authMiddleware);

router.post('/', submitCode);
router.get('/', getUserSubmissions);

export default router;
