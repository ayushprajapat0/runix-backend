import { Router } from 'express';
import authRouter from '../modules/auth/auth.routes.js';
import problemsRouter from '../modules/problems/problems.routes.js';

const router = Router();

router.use('/auth', authRouter);
router.use('/problems', problemsRouter);


export default router;
