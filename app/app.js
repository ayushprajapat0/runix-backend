import express from 'express';
import cookieParser from 'cookie-parser';
import cors from 'cors';

import apiRouter from './routes/index.js';

const app = express();

app.use(cors({
    origin: process.env.CLIENT_URL || 'http://localhost:3000',
    credentials: true,
}));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cookieParser());

app.use('/api', apiRouter);

app.get('/health', (req, res) => {
    res.status(200).json({ status: 'ok', timestamp: new Date().toISOString() });
});

app.use((req, res) => {
    res.status(404).json({ message: `Route ${req.method} ${req.originalUrl} not found` });
});
app.use((err, req, res, next) => {
    console.error(`[ERROR] ${err.message}`);
    res.status(err.statusCode || 500).json({
        message: err.message || 'Internal Server Error',
    });
});

export default app;
