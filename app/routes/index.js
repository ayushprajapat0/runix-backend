import { Router } from 'express';
import authRouter from '../modules/auth/auth.routes.js';
import problemsRouter from '../modules/problems/problems.routes.js';
import runRouter from '../modules/run/run.routes.js';
import submissionsRouter from '../modules/submissions/submissions.routes.js';

const router = Router();

router.use('/auth', authRouter);
router.use('/problems', problemsRouter);
router.use('/run', runRouter);
router.use('/submissions', submissionsRouter);

export default router;
