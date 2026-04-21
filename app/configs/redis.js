import redis from 'redis'

const redis_client = redis.createClient({
  host: process.env.REDIS_HOST,
  port: process.env.REDIS_PORT,
  socket: {
    reconnectStrategy: (retries) => Math.min(retries * 50, 500)
  }
});

redis_client.on('connect', () => {
  console.log('Connected to Redis');
});

redis_client.on('error', (err) => {
  console.error('Redis connection error:', err);
});

export default redis_client;

