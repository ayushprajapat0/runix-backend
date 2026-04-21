import { Router } from 'express';
import authRouter from '../modules/auth/auth.routes.js';
import problemsRouter from '../modules/problems/problems.routes.js';
import runRouter from '../modules/run/run.routes.js';

const router = Router();

router.use('/auth', authRouter);
router.use('/problems', problemsRouter);
router.use('/run', runRouter);


export default router;
