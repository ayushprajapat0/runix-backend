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

export const getUserProfile = async (username) => {
    // 1. Get user details
    const userRes = await client.query(
        'SELECT id, username, full_name, email, created_at FROM users WHERE username=$1',
        [username]
    );
    if (userRes.rows.length === 0) {
        throw new AuthError('User not found', 404);
    }
    const user = userRes.rows[0];

    // 2. Platform totals
    const totalsRes = await client.query(`
        SELECT difficulty, COUNT(*) as count 
        FROM problems 
        GROUP BY difficulty
    `);
    const totals = { easy: 0, medium: 0, hard: 0 };
    totalsRes.rows.forEach(r => {
        if (totals[r.difficulty] !== undefined) {
            totals[r.difficulty] = parseInt(r.count, 10);
        }
    });

    // 3. Solved counts
    const solvedRes = await client.query(`
        SELECT p.difficulty, COUNT(DISTINCT ups.problem_id) as count
        FROM user_problem_status ups
        JOIN problems p ON ups.problem_id = p.id
        WHERE ups.user_id = $1 AND ups.status = 'solved'
        GROUP BY p.difficulty
    `, [user.id]);
    const solved = { easy: 0, medium: 0, hard: 0 };
    solvedRes.rows.forEach(r => {
        if (solved[r.difficulty] !== undefined) {
            solved[r.difficulty] = parseInt(r.count, 10);
        }
    });

    // 4. Submission Stats
    const statsRes = await client.query(`
        SELECT 
            COUNT(*) as total_submissions,
            SUM(CASE WHEN status = 'accepted' THEN 1 ELSE 0 END) as accepted_submissions
        FROM submissions
        WHERE user_id = $1
    `, [user.id]);
    const stats = statsRes.rows[0];
    const totalSubmissions = parseInt(stats.total_submissions, 10) || 0;
    const acceptedSubmissions = parseInt(stats.accepted_submissions, 10) || 0;
    const acceptanceRate = totalSubmissions > 0 ? parseFloat(((acceptedSubmissions / totalSubmissions) * 100).toFixed(1)) : 0;

    // 5. Recent Submissions
    const recentRes = await client.query(`
        SELECT s.id, p.title, p.slug, s.status, l.name as language_name, s.created_at, s.runtime_ms, s.memory_kb
        FROM submissions s
        JOIN problems p ON s.problem_id = p.id
        JOIN languages l ON s.language_id = l.id
        WHERE s.user_id = $1
        ORDER BY s.created_at DESC
        LIMIT 15
    `, [user.id]);

    return {
        user: {
            username: user.username,
            fullName: user.full_name,
            email: user.email,
            createdAt: user.created_at
        },
        solved,
        totals,
        stats: {
            totalSubmissions,
            acceptedSubmissions,
            acceptanceRate
        },
        recentSubmissions: recentRes.rows
    };
};

// ─── Update profile (name / username) ─────────────────────────────────────────
export const updateUserProfile = async (userId, { fullName, username }) => {
    if (username) {
        const usernameRegex = /^[a-zA-Z0-9_]+$/;
        if (!usernameRegex.test(username)) {
            throw new AuthError(
                'Username can only contain letters, numbers, and underscores.',
                400
            );
        }
        // check conflict with other users
        const conflict = await client.query(
            'SELECT id FROM users WHERE username=$1 AND id<>$2',
            [username, userId]
        );
        if (conflict.rows.length > 0) {
            throw new AuthError('Username already taken', 409);
        }
    }

    const result = await client.query(
        `UPDATE users SET
            full_name   = COALESCE($1, full_name),
            username    = COALESCE($2, username),
            updated_at  = NOW()
         WHERE id = $3
         RETURNING id, username, email, full_name`,
        [fullName || null, username || null, userId]
    );
    return result.rows[0];
};

// ─── Request email change (send OTP to new address) ───────────────────────────
export const requestEmailChange = async (userId, newEmail) => {
    // check duplicate
    const conflict = await client.query(
        'SELECT id FROM users WHERE email=$1 AND id<>$2',
        [newEmail, userId]
    );
    if (conflict.rows.length > 0) {
        throw new AuthError('Email already in use by another account', 409);
    }

    const otp = Math.floor(100000 + Math.random() * 900000);
    // Store OTP + pending new email in users row temporarily
    await client.query(
        `UPDATE users SET
            otp              = $1,
            otp_expires_at   = $2,
            pending_email    = $3
         WHERE id = $4`,
        [otp, new Date(Date.now() + 10 * 60 * 1000), newEmail, userId]
    );

    await sendOtp(newEmail, otp);
};

// ─── Verify email change OTP and apply new email ──────────────────────────────
export const verifyEmailChange = async (userId, otp) => {
    const result = await client.query(
        'SELECT * FROM users WHERE id=$1',
        [userId]
    );
    if (result.rows.length === 0) throw new AuthError('User not found', 404);

    const user = result.rows[0];

    if (!user.pending_email) throw new AuthError('No pending email change', 400);
    if (String(user.otp) !== String(otp)) throw new AuthError('Invalid OTP', 400);
    if (new Date(user.otp_expires_at) < new Date()) throw new AuthError('OTP expired', 400);

    const updated = await client.query(
        `UPDATE users SET
            email          = pending_email,
            pending_email  = NULL,
            otp            = NULL,
            otp_expires_at = NULL,
            updated_at     = NOW()
         WHERE id = $1
         RETURNING id, username, email, full_name`,
        [userId]
    );
    return updated.rows[0];
};
