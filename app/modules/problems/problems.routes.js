import { Router } from 'express';
import { getAllProblems, getProblem } from './problems.controller.js';

const router = Router();

router.get('/', getAllProblems);
router.get('/:slug', getProblem);

export default router;
