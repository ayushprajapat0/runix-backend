import { signup, verifyOtp, resendOtp, login, refreshToken, logout, getMe, getProfile, updateProfile, requestEmailUpdate, verifyEmailUpdate } from './auth.controller.js'
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
router.get('/profile/:username', getProfile);
router.put('/profile', authMiddleware, updateProfile);
router.post('/request-email-update', authMiddleware, requestEmailUpdate);
router.post('/verify-email-update', authMiddleware, verifyEmailUpdate);

export default router;