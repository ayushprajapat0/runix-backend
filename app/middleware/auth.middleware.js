import { verifyAccessToken } from '../utils/jwt.js';

const authMiddleware = (req, res, next) => {
    try {
        // Accept token from cookie or Authorization header (Bearer)
        const token =
            req.cookies?.accessToken ||
            req.headers.authorization?.split(' ')[1];

        if (!token) {
            return res.status(401).json({ message: 'Unauthorized: No token provided' });
        }

        const payload = verifyAccessToken(token);
        req.user = { id: payload.id, username: payload.username, email: payload.email };
        next();
    } catch (error) {
        return res.status(401).json({ message: 'Unauthorized: Invalid or expired token' });
    }
};

export { authMiddleware };
