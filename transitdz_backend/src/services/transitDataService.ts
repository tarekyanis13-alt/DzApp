import { randomUUID } from 'crypto';

import alertsData from '../data/alerts.json';
import departuresData from '../data/departures.json';
import linesData from '../data/lines.json';
import routesData from '../data/routes.json';
import stopsData from '../data/stops.json';
import vehiclesData from '../data/vehicles.json';
import wilayasData from '../data/wilayas.json';
import {
  Departure,
  RouteOption,
  TransitAlert,
  TransitLine,
  TransitMode,
  TransitStop,
  VehiclePosition,
} from '../types/transit';

interface VehicleState extends VehiclePosition {
  lastJitter: number;
}

class TransitDataService {
  private stops: TransitStop[] = stopsData as TransitStop[];

  private lines: TransitLine[] = linesData as TransitLine[];

  private departures: Departure[] = departuresData as Departure[];

  private vehicles: VehicleState[] = (vehiclesData as VehiclePosition[]).map(
    (vehicle) => ({ ...vehicle, lastJitter: Date.now() }),
  );

  private alerts: TransitAlert[] = alertsData as TransitAlert[];

  private routes: RouteOption[] = routesData as RouteOption[];

  private wilayas: string[] = wilayasData as string[];

  getStops(): TransitStop[] {
    return this.stops;
  }

  getStopById(id: string): TransitStop | undefined {
    return this.stops.find((stop) => stop.id === id);
  }

  searchStops(query: string): TransitStop[] {
    const lower = query.toLowerCase();
    return this.stops.filter(
      (stop) =>
        stop.name.toLowerCase().includes(lower) ||
        stop.wilaya.toLowerCase().includes(lower),
    );
  }

  getLines(): TransitLine[] {
    return this.lines;
  }

  getLineById(id: string): TransitLine | undefined {
    return this.lines.find((line) => line.id === id);
  }

  getLineStops(lineId: string): TransitStop[] {
    const line = this.getLineById(lineId);
    if (!line) return [];
    return line.stops
      .map((stopId) => this.getStopById(stopId))
      .filter((stop): stop is TransitStop => Boolean(stop));
  }

  getAlerts(): TransitAlert[] {
    return this.alerts;
  }

  getAlertsByScope(scope: 'network' | 'line' | 'stop', id?: string): TransitAlert[] {
    return this.alerts.filter((alert) => {
      if (alert.scope !== scope) return false;
      if (scope === 'line') return alert.lineId === id;
      if (scope === 'stop') return alert.stopId === id;
      return true;
    });
  }

  getDepartures(stopId?: string): Departure[] {
    if (!stopId) return this.departures;
    return this.departures.filter((departure) => departure.stopId === stopId);
  }

  getRouteOptions(optimization?: RouteOption['optimization']): RouteOption[] {
    if (!optimization) return this.routes;
    const filtered = this.routes.filter((route) => route.optimization === optimization);
    return filtered.length ? filtered : this.routes;
  }

  getVehicles(): VehiclePosition[] {
    this.jitterVehicles();
    return this.vehicles.map(({ lastJitter, ...vehicle }) => ({ ...vehicle }));
  }

  getWilayas(): string[] {
    return this.wilayas;
  }

  upsertDeparture(departure: Departure): Departure {
    const existing = this.departures.findIndex(
      (item) => item.stopId === departure.stopId && item.lineId === departure.lineId,
    );
    if (existing >= 0) {
      this.departures[existing] = departure;
    } else {
      this.departures.push(departure);
    }
    return departure;
  }

  createAlert(alert: Omit<TransitAlert, 'id'>): TransitAlert {
    const newAlert: TransitAlert = { ...alert, id: randomUUID() };
    this.alerts.push(newAlert);
    return newAlert;
  }

  simulateVehicleUpdate(): VehiclePosition[] {
    this.jitterVehicles();
    return this.getVehicles();
  }

  private jitterVehicles() {
    const now = Date.now();
    this.vehicles = this.vehicles.map((vehicle) => {
      if (now - vehicle.lastJitter < 3_000) {
        return vehicle;
      }
      const deltaLat = (Math.random() - 0.5) * 0.002;
      const deltaLng = (Math.random() - 0.5) * 0.002;
      return {
        ...vehicle,
        latitude: vehicle.latitude + deltaLat,
        longitude: vehicle.longitude + deltaLng,
        lastJitter: now,
        updatedAt: new Date().toISOString(),
      };
    });
  }

  getModes(): TransitMode[] {
    return ['bus', 'tram', 'metro', 'rail', 'intercity', 'sharedTaxi'];
  }
}

export const transitDataService = new TransitDataService();
