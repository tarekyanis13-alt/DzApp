import cors from 'cors';
import express, { Application } from 'express';
import helmet from 'helmet';
import http from 'http';
import { Server as SocketServer } from 'socket.io';

import transitRoutes from './routes/transitRoutes';
import { transitDataService } from './services/transitDataService';

export interface ServerConfig {
  port: number;
  host: string;
  corsOrigins: string[];
}

export const createServer = ({ port, host, corsOrigins }: ServerConfig) => {
  const app: Application = express();
  const httpServer = http.createServer(app);
  const io = new SocketServer(httpServer, {
    cors: {
      origin: corsOrigins,
      methods: ['GET', 'POST'],
    },
  });

  app.use(express.json());
  app.use(helmet());
  app.use(cors({ origin: corsOrigins }));

  app.use('/api', transitRoutes);

  io.on('connection', (socket) => {
    socket.emit('vehicles:init', transitDataService.getVehicles());

    const interval = setInterval(() => {
      const positions = transitDataService.simulateVehicleUpdate();
      socket.emit('vehicles:update', positions);
    }, 5000);

    socket.on('disconnect', () => {
      clearInterval(interval);
    });
  });

  const start = () =>
    new Promise<void>((resolve) => {
      httpServer.listen(port, host, () => {
        console.log(`TransitDZ backend listening on http://${host}:${port}`);
        resolve();
      });
    });

  return { app, httpServer, start };
};
