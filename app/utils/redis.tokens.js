import redis_client from '../configs/redis.js';

const TOKEN_EXPIRATION = 7 * 24 * 60 * 60; // 7 days in seconds

export const storeRefreshToken = async (userId, refreshToken) => {
    await redis_client.set(`refresh_token:${userId}`, refreshToken, {
        EX: TOKEN_EXPIRATION
    });
};

export const getRefreshToken = async (userId) => {
    return await redis_client.get(`refresh_token:${userId}`);
};

export const deleteRefreshToken = async (userId) => {
    await redis_client.del(`refresh_token:${userId}`);
};
