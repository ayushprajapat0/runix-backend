import client from "../../configs/db.js";
import bcrypt from 'bcrypt';
import { sendOtp } from "../../utils/OtpSend.js";
import {
    generateAccessToken,
    generateRefreshToken,
    verifyRefreshToken
} from "../../utils/jwt.js";
import {
    storeRefreshToken,
    getRefreshToken,
    deleteRefreshToken
} from "../../utils/redis.tokens.js";

export class AuthError extends Error {
    constructor(message, statusCode = 400) {
        super(message);
        this.name = 'AuthError';
        this.statusCode = statusCode;
    }
}

export const signupUser = async (username, email, password, fullname) => {
    const usernameRegex = /^[a-zA-Z0-9_]+$/;
    if (!usernameRegex.test(username)) {
        throw new AuthError(
            'Username can only contain letters, numbers, and underscores. No special characters or @ allowed.',
            400
        );
    }

    const existing = await client.query(
        'SELECT id FROM users WHERE email=$1 OR username=$2',
        [email, username]
    );
    if (existing.rows.length > 0) {
        throw new AuthError('Email or username already in use', 409);
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const otp = Math.floor(100000 + Math.random() * 900000);

    await client.query(
        `INSERT INTO users (username, email, password, full_name, otp, otp_expires_at)
         VALUES ($1, $2, $3, $4, $5, $6)`,
        [username, email, hashedPassword, fullname, otp, new Date(Date.now() + 10 * 60 * 1000)]
    );

    await sendOtp(email, otp);
};

export const verifyUserOtp = async (email, otp) => {
    const result = await client.query('SELECT * FROM users WHERE email=$1', [email]);
    if (result.rows.length === 0) {
        throw new AuthError('User not found', 404);
    }

    const user = result.rows[0];

    if (String(user.otp) !== String(otp)) {
        throw new AuthError('Invalid OTP', 400);
    }

    if (new Date(user.otp_expires_at) < new Date()) {
        throw new AuthError('OTP expired', 400);
    }

    await client.query(
        'UPDATE users SET is_verified=TRUE, otp=NULL, otp_expires_at=NULL WHERE email=$1',
        [email]
    );

    return user;
};

export const resendUserOtp = async (email) => {
    const result = await client.query('SELECT id FROM users WHERE email=$1', [email]);
    if (result.rows.length === 0) {
        throw new AuthError('User not found', 404);
    }

    const otp = Math.floor(100000 + Math.random() * 900000);
    await client.query(
        'UPDATE users SET otp=$1, otp_expires_at=$2 WHERE email=$3',
        [otp, new Date(Date.now() + 10 * 60 * 1000), email]
    );

    await sendOtp(email, otp);
};

export const loginUser = async (identifier, password) => {
    const isEmail = identifier.includes('@');
    const query = isEmail
        ? 'SELECT * FROM users WHERE email=$1'
        : 'SELECT * FROM users WHERE username=$1';

    const result = await client.query(query, [identifier]);
    if (result.rows.length === 0) {
        throw new AuthError('User not found', 404);
    }

    const user = result.rows[0];

    if (!user.is_verified) {
        throw new AuthError('Email not verified. Please verify your account first.', 403);
    }

    const passwordMatch = await bcrypt.compare(password, user.password);
    if (!passwordMatch) {
        throw new AuthError('Invalid credentials', 401);
    }

    return user;
};

// ─── Issue token pair ─────────────────────────────────────────────────────────
export const issueTokens = async (user) => {
    const payload = { id: user.id, username: user.username, email: user.email };
    const accessToken = generateAccessToken(payload);
    const refreshToken = generateRefreshToken({ id: user.id });
    await storeRefreshToken(user.id, refreshToken);
    return { accessToken, refreshToken };
};

export const refreshUserToken = async (token) => {
    if (!token) {
        throw new AuthError('No refresh token provided', 401);
    }

    let payload;
    try {
        payload = verifyRefreshToken(token);
    } catch {
        throw new AuthError('Invalid or expired refresh token', 401);
    }

    const stored = await getRefreshToken(payload.id);
    if (!stored || stored !== token) {
        throw new AuthError('Session expired. Please log in again.', 401);
    }

    const result = await client.query('SELECT * FROM users WHERE id=$1', [payload.id]);
    if (result.rows.length === 0) {
        throw new AuthError('User not found', 401);
    }

    return result.rows[0];
};

export const logoutUser = async (token) => {
    if (!token) return;

    try {
        const payload = verifyRefreshToken(token);
        await deleteRefreshToken(payload.id);
    } catch {
    }
};

export const getUserById = async (id) => {
    const result = await client.query(
        'SELECT id, username, email, full_name, is_verified, created_at FROM users WHERE id=$1',
        [id]
    );
    if (result.rows.length === 0) {
        throw new AuthError('User not found', 404);
    }
    return result.rows[0];
};
