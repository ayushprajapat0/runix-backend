import { signup, verifyOtp, resendOtp, login, refreshToken, logout, getMe } from './auth.controller.js'
import { authMiddleware } from './../../middleware/auth.middleware.js'
import express from 'express';

const router = express.Router();

router.post('/signup', signup);
router.post('/verify-otp', verifyOtp);
router.post('/resend-otp', resendOtp);
router.post('/login', login);
router.post('/refresh-token', refreshToken);
router.post('/logout', logout);
router.get('/me', authMiddleware, getMe);

export default router;