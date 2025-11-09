# TransitDZ Backend

Node.js (TypeScript) service providing APIs and live updates for the TransitDZ mobile application.

## Features

- REST APIs for stops, lines, routes, departures, alerts, vehicles, and wilayas
- WebSocket (Socket.IO) feed streaming simulated vehicle positions every 5 seconds
- In-memory mock data aligned with the Flutter client assets
- Structured for easy replacement with real GTFS/GTFS-RT ingestion pipelines

## Tech Stack

- Express 4
- Socket.IO 4
- TypeScript 5
- Helmet & CORS middleware

## Getting Started

```bash
npm install
npm run dev
```

Environment variables (`.env`):

- `PORT` (default `8080`)
- `HOST` (default `0.0.0.0`)
- `CORS_ORIGINS` comma-separated origins (default `*`)

### Production Build

```bash
npm run build
npm start
```

## API Endpoints

Base path: `/api`

- `GET /health` – service status
- `GET /stops?q=` – list/search stops
- `GET /stops/:stopId` – stop detail
- `GET /lines` – all lines
- `GET /lines/:lineId` – line detail with stops & alerts
- `GET /departures?stopId=` – departures board
- `GET /routes?optimization=` – planner options (`fastest|leastWalking|cheapest`)
- `GET /vehicles` – latest vehicle positions
- `GET /alerts?scope=&id=` – network/line/stop alerts
- `GET /wilayas` – list of 58 Algerian wilayas

### WebSocket Events

Namespace: default (`/`)

- `vehicles:init` – initial array of vehicle positions
- `vehicles:update` – subsequent updates (every 5s)

## Next Steps

- Replace mock data reads with PostGIS or Supabase backing services
- Plug Mapbox Transit / GTFS feeds for authoritative schedules
- Extend admin APIs for editing stops/lines and injecting alerts
