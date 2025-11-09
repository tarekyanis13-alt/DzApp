import { Request, Response } from 'express';
import { StatusCodes } from 'http-status-codes';

import { transitDataService } from '../services/transitDataService';

export const getHealth = (_req: Request, res: Response) => {
  res.status(StatusCodes.OK).json({
    status: 'ok',
    service: 'transitdz-backend',
    timestamp: new Date().toISOString(),
  });
};

export const getStops = (req: Request, res: Response) => {
  const { q } = req.query;
  if (typeof q === 'string' && q.length > 0) {
    return res.status(StatusCodes.OK).json(transitDataService.searchStops(q));
  }
  return res.status(StatusCodes.OK).json(transitDataService.getStops());
};

export const getStopById = (req: Request, res: Response) => {
  const stop = transitDataService.getStopById(req.params.stopId);
  if (!stop) {
    return res.status(StatusCodes.NOT_FOUND).json({ message: 'Stop not found' });
  }
  return res.status(StatusCodes.OK).json(stop);
};

export const getLines = (_req: Request, res: Response) => {
  return res.status(StatusCodes.OK).json(transitDataService.getLines());
};

export const getLineById = (req: Request, res: Response) => {
  const line = transitDataService.getLineById(req.params.lineId);
  if (!line) {
    return res.status(StatusCodes.NOT_FOUND).json({ message: 'Line not found' });
  }
  return res.status(StatusCodes.OK).json({
    ...line,
    stops: transitDataService.getLineStops(line.id),
    alerts: transitDataService.getAlertsByScope('line', line.id),
  });
};

export const getDepartures = (req: Request, res: Response) => {
  const { stopId } = req.query;
  if (typeof stopId === 'string') {
    return res
      .status(StatusCodes.OK)
      .json(transitDataService.getDepartures(stopId));
  }
  return res.status(StatusCodes.OK).json(transitDataService.getDepartures());
};

export const getRoutes = (req: Request, res: Response) => {
  const { optimization } = req.query;
  if (
    typeof optimization === 'string' &&
    ['fastest', 'leastWalking', 'cheapest'].includes(optimization)
  ) {
    return res
      .status(StatusCodes.OK)
      .json(transitDataService.getRouteOptions(optimization as any));
  }
  return res.status(StatusCodes.OK).json(transitDataService.getRouteOptions());
};

export const getVehicles = (_req: Request, res: Response) => {
  return res.status(StatusCodes.OK).json(transitDataService.getVehicles());
};

export const getAlerts = (req: Request, res: Response) => {
  const { scope, id } = req.query;
  if (scope === 'line' || scope === 'stop') {
    return res
      .status(StatusCodes.OK)
      .json(transitDataService.getAlertsByScope(scope, typeof id === 'string' ? id : undefined));
  }
  return res.status(StatusCodes.OK).json(transitDataService.getAlerts());
};

export const getWilayas = (_req: Request, res: Response) => {
  return res.status(StatusCodes.OK).json(transitDataService.getWilayas());
};
