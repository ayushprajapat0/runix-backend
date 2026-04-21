import {
    signupUser,
    verifyUserOtp,
    resendUserOtp,
    loginUser,
    issueTokens,
    refreshUserToken,
    logoutUser,
    getUserById,
    AuthError,
} from './auth.service.js';

const ACCESS_COOKIE_OPTIONS = {
    httpOnly: true,
    secure: process.env.NODE_ENV === 'production',
    sameSite: 'strict',
    maxAge: 15 * 60 * 1000,
};

const REFRESH_COOKIE_OPTIONS = {
    httpOnly: true,
    secure: process.env.NODE_ENV === 'production',
    sameSite: 'strict',
    maxAge: 7 * 24 * 60 * 60 * 1000,
};

const handleError = (res, error) => {
    if (error instanceof AuthError) {
        return res.status(error.statusCode).json({ message: error.message });
    }
    console.error(error);
    return res.status(500).json({ message: 'Internal Server Error' });
};

export const signup = async (req, res) => {
    try {
        const { username, email, password, fullname } = req.body;
        if (!username || !email || !password || !fullname) {
            return res.status(400).json({ message: 'All fields are required' });
        }
        await signupUser(username, email, password, fullname);
        return res.status(201).json({ message: 'User created. Check your email for the OTP.' });
    } catch (error) {
        return handleError(res, error);
    }
};

export const verifyOtp = async (req, res) => {
    try {
        const { email, otp } = req.body;
        if (!email || !otp) {
            return res.status(400).json({ message: 'Email and OTP are required' });
        }
        const user = await verifyUserOtp(email, otp);
        const { accessToken, refreshToken } = await issueTokens(user);
        res.cookie('accessToken', accessToken, ACCESS_COOKIE_OPTIONS);
        res.cookie('refreshToken', refreshToken, REFRESH_COOKIE_OPTIONS);
        return res.status(200).json({
            message: 'Email verified successfully',
            user: {
                id: user.id,
                username: user.username,
                email: user.email,
                fullName: user.full_name,
            },
        });
    } catch (error) {
        return handleError(res, error);
    }
};

export const resendOtp = async (req, res) => {
    try {
        const { email } = req.body;
        if (!email) {
            return res.status(400).json({ message: 'Email is required' });
        }
        await resendUserOtp(email);
        return res.status(200).json({ message: 'OTP resent successfully' });
    } catch (error) {
        return handleError(res, error);
    }
};

export const login = async (req, res) => {
    try {
        const { identifier, password } = req.body;
        if (!identifier || !password) {
            return res.status(400).json({ message: 'Identifier and password are required' });
        }
        const user = await loginUser(identifier, password);
        const { accessToken, refreshToken } = await issueTokens(user);
        res.cookie('accessToken', accessToken, ACCESS_COOKIE_OPTIONS);
        res.cookie('refreshToken', refreshToken, REFRESH_COOKIE_OPTIONS);
        return res.status(200).json({
            message: 'Login successful',
            user: {
                id: user.id,
                username: user.username,
                email: user.email,
                fullName: user.full_name,
            },
        });
    } catch (error) {
        return handleError(res, error);
    }
};

export const refreshToken = async (req, res) => {
    try {
        const token = req.cookies?.refreshToken;
        const user = await refreshUserToken(token);
        const { accessToken, refreshToken: newRefreshToken } = await issueTokens(user);
        res.cookie('accessToken', accessToken, ACCESS_COOKIE_OPTIONS);
        res.cookie('refreshToken', newRefreshToken, REFRESH_COOKIE_OPTIONS);
        return res.status(200).json({ message: 'Tokens refreshed successfully' });
    } catch (error) {
        return handleError(res, error);
    }
};

export const logout = async (req, res) => {
    try {
        const token = req.cookies?.refreshToken;
        await logoutUser(token);
        res.clearCookie('accessToken', { httpOnly: true, sameSite: 'strict' });
        res.clearCookie('refreshToken', { httpOnly: true, sameSite: 'strict' });
        return res.status(200).json({ message: 'Logged out successfully' });
    } catch (error) {
        return handleError(res, error);
    }
};

export const getMe = async (req, res) => {
    try {
        const user = await getUserById(req.user.id);
        return res.status(200).json({ user });
    } catch (error) {
        return handleError(res, error);
    }
};