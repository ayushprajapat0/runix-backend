import { getAllProblemsService, getProblemService } from './problems.service.js';

const VALID_DIFFICULTIES = new Set(['easy', 'medium', 'hard']);
const VALID_SORTS = new Set(['newest', 'acceptance', 'difficulty']);

export const getAllProblems = async (req, res) => {
    try {
        const {
            page = 1,
            limit = 10,
            difficulty,
            tags,
            search,
            sort = 'newest',
        } = req.query;

        if (difficulty && !VALID_DIFFICULTIES.has(difficulty)) {
            return res.status(400).json({ success: false, message: 'difficulty must be easy | medium | hard' });
        }

        const result = await getAllProblemsService({
            page,
            limit,
            difficulty: difficulty || null,
            tags: tags || null,
            search: search || null,
            sort: VALID_SORTS.has(sort) ? sort : 'newest',
        });

        return res.status(200).json({ success: true, ...result });
    } catch (error) {
        console.error('Error in getAllProblems:', error);
        return res.status(500).json({ success: false, message: 'Failed to fetch problems' });
    }
};

export const getProblem = async (req, res) => {
    try {
        const { slug } = req.params;
        if (!slug || !/^[a-z0-9-]+$/.test(slug)) {
            return res.status(400).json({ success: false, message: 'Invalid problem slug' });
        }

        const problem = await getProblemService(slug);
        if (!problem) {
            return res.status(404).json({ success: false, message: 'Problem not found' });
        }

        return res.status(200).json({ success: true, problem });
    } catch (error) {
        console.error('Error in getProblem:', error);
        return res.status(500).json({ success: false, message: 'Failed to fetch problem' });
    }
};