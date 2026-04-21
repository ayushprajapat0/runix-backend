import dotenv from 'dotenv';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
dotenv.config({ path: path.resolve(__dirname, '../.env') });
import app from './app.js';
import pool from './configs/db.js';
import redis_client from './configs/redis.js';

const PORT = process.env.PORT || 5000;

const startServer = async () => {
    try {
        const c = await pool.connect();
        c.release();
        console.log('PostgreSQL connected');

        await redis_client.connect();
        console.log('Redis connected');

        app.listen(PORT, () => {
            console.log(` Server running on port ${PORT}`);
        });
    } catch (error) {
        console.error('Failed to start server:', error.message);
        process.exit(1);
    }
};

process.on('SIGINT', async () => {
    console.log('\n Shutting down gracefully...');
    await pool.end();
    await redis_client.quit();
    process.exit(0);
});

process.on('SIGTERM', async () => {
    console.log('\nSIGTERM received. Shutting down...');
    await pool.end();
    await redis_client.quit();
    process.exit(0);
});

startServer();