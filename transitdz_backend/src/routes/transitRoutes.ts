import { Router } from 'express';

import {
  getAlerts,
  getDepartures,
  getHealth,
  getLineById,
  getLines,
  getRoutes,
  getStopById,
  getStops,
  getVehicles,
  getWilayas,
} from '../controllers/transitController';

const router = Router();

router.get('/health', getHealth);
router.get('/stops', getStops);
router.get('/stops/:stopId', getStopById);
router.get('/lines', getLines);
router.get('/lines/:lineId', getLineById);
router.get('/departures', getDepartures);
router.get('/routes', getRoutes);
router.get('/vehicles', getVehicles);
router.get('/alerts', getAlerts);
router.get('/wilayas', getWilayas);

export default router;
