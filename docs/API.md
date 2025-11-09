# TransitDZ API Documentation

Base URL: `https://{HOST}:{PORT}/api`

## Authentication

- Current mock implementation does not require authentication.
- Production deployment should supply OAuth 2.0 / API key headers.

## Endpoints

### GET /health
Returns service health metadata.

**Response 200**
```json
{
  "status": "ok",
  "service": "transitdz-backend",
  "timestamp": "2025-11-09T09:20:17.333Z"
}
```

### GET /stops
List all stops or search.

**Query Params**
- `q` *(optional)* – case-insensitive search term.

**Response 200**
```json
[
  {
    "id": "alg_metro_khartoun",
    "name": "Kharouba Metro",
    "wilaya": "Algiers",
    "latitude": 36.7739,
    "longitude": 3.0589,
    "modes": ["metro"],
    "lines": ["metro_line_1"],
    "crowdingLevel": 0.7,
    "amenities": ["wifi", "elevator", "security"]
  }
]
```

### GET /stops/{stopId}
Fetch stop detail.

**Response 200** – `TransitStop`

### GET /lines
Returns all transit lines.

### GET /lines/{lineId}
Returns line metadata plus stops and active alerts.

**Response 200**
```json
{
  "id": "metro_line_1",
  "name": "Ligne 1 - Tafourah ↔ El Harrach",
  "code": "M1",
  "mode": "metro",
  "stops": [ ... TransitStop ... ],
  "alerts": [ ... TransitAlert ... ]
}
```

### GET /departures
Upcoming departures for a stop.

**Query Params**
- `stopId` *(optional)* – filter by stop.

**Response 200** – Array of `Departure`

### GET /routes
Route planner options.

**Query Params**
- `optimization` *(optional)* – `fastest|leastWalking|cheapest`

**Response 200** – Array of `RouteOption`

### GET /vehicles
Latest vehicle positions.

**Response 200** – Array of `VehiclePosition`

### GET /alerts
Service alerts.

**Query Params**
- `scope` – `network|line|stop`
- `id` – required when `scope=line|stop`

### GET /wilayas
Static list of Algerian wilayas.

## WebSocket Feed

- **URL:** `wss://{HOST}:{PORT}` (Socket.IO protocol)
- **Events:**
  - `vehicles:init` – emitted upon connection with array of `VehiclePosition`.
  - `vehicles:update` – emitted every 5 seconds with new positions.

## Error Handling

- 404 Not Found when resource missing
- 400 Bad Request for invalid query parameters
- Errors follow `{ "message": string }` structure

## Rate Limiting & Security (Recommended)

- Apply API keys per client
- Enforce rate limits (e.g., 60 rpm per IP)
- Enable HTTPS termination and JWT authentication once user accounts added
- Audit logging for admin endpoints
