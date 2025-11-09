export type TransitMode =
  | 'bus'
  | 'tram'
  | 'metro'
  | 'rail'
  | 'intercity'
  | 'sharedTaxi';

export interface TransitStop {
  id: string;
  name: string;
  wilaya: string;
  latitude: number;
  longitude: number;
  modes: TransitMode[];
  lines: string[];
  address?: string;
  crowdingLevel?: number;
  amenities?: string[];
}

export interface TransitLine {
  id: string;
  name: string;
  code: string;
  mode: TransitMode;
  color: string;
  textColor: string;
  operatingHours: string;
  frequencyMinutes: Record<string, number>;
  stops: string[];
  category?: string;
  farePolicy?: string;
  description?: string;
}

export interface Departure {
  stopId: string;
  lineId: string;
  destination: string;
  arrivalMinutes: number;
  status: 'onTime' | 'delayed' | 'cancelled';
  platform?: string;
}

export interface VehiclePosition {
  id: string;
  lineId: string;
  mode: TransitMode;
  latitude: number;
  longitude: number;
  bearing: number;
  status: 'onTime' | 'delayed' | 'ahead';
  updatedAt: string;
  speedKmh?: number;
}

export interface TransitAlert {
  id: string;
  title: string;
  message: string;
  severity: 'info' | 'warning' | 'severe';
  scope: 'network' | 'line' | 'stop';
  status: 'active' | 'resolved' | 'upcoming';
  lineId?: string;
  stopId?: string;
  validFrom?: string;
  validUntil?: string;
}

export interface RouteStep {
  type: 'walk' | 'ride' | 'transfer';
  description: string;
  durationMinutes: number;
  distanceMeters?: number;
  lineId?: string;
  fromStop?: string;
  toStop?: string;
  polyline?: number[][];
}

export interface RouteOption {
  id: string;
  departureTime: string;
  arrivalTime: string;
  totalDurationMinutes: number;
  totalWalkingMinutes: number;
  optimization: 'fastest' | 'leastWalking' | 'cheapest';
  emissionsKg: number;
  costDZD: number;
  steps: RouteStep[];
}
