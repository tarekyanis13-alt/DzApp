import { config } from 'dotenv';

import { createServer } from './server';

config();

const PORT = Number(process.env.PORT ?? 8080);
const HOST = process.env.HOST ?? '0.0.0.0';
const CORS = process.env.CORS_ORIGINS?.split(',') ?? ['*'];

const server = createServer({ port: PORT, host: HOST, corsOrigins: CORS });

server.start();
