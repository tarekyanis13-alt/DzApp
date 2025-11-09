# TransitDZ Architecture Overview

## System Topology

```
+-------------------+        HTTPS         +--------------------+
|   TransitDZ App   | <------------------> |  TransitDZ Backend |
|  (Flutter, iOS/Android)                  |  (Express + WS)    |
+-------------------+                      +--------------------+
          |                                              |
          | Mapbox SDK & APIs (Tiles, Geocoding, Routing) |
          +----------------------------------------------->
```

- **Mobile app** built with Flutter (Riverpod + GoRouter) consuming REST/WebSocket services.
- **Backend** exposes `/api` endpoints and a Socket.IO channel for live vehicle updates.
- **Mapbox** handles basemap, routing, and geocoding; token stored in `AppConstants`.

## Mobile Architecture

- **State Management:** Riverpod `Provider` / `StateNotifierProvider` for global state (theme, locale, onboarding, favorites).
- **Navigation:** `GoRouter` with deep-link friendly routes (`/stops/:id`, `/lines/:id`, etc.).
- **Feature-first Structure:** Each domain feature has `controllers/` (state), `presentation/` (widgets), and leverages shared `core/` modules for models/services.
- **Data Layer:** `TransitRepository` backed by `MockTransitDataSource` (asset JSON). Replace with network client to productionise.
- **Localization:** JSON-driven loader (`assets/translations/*.json`) supporting Arabic, French, English.
- **Theming:** FlexColorScheme for cohesive light/dark palettes based on brief.
- **Real-Time:** `vehicleStreamProvider` simulates WebSocket updates until wired to backend.

## Backend Architecture

- **Framework:** Express 4 with TypeScript, structured into `controllers/`, `routes/`, `services/`, `types/`.
- **Data Service:** `TransitDataService` loads mock JSON into memory, exposes query helpers, and jitters vehicle positions.
- **WebSocket:** Socket.IO broadcasts `vehicles:init` and `vehicles:update` events every 5 seconds.
- **API Surface:** REST endpoints for stops, lines, departures, routes, alerts, vehicles, wilayas, plus `/health` probe.
- **Extensibility:** Swap mock data service with database or GTFS ingestion without touching controllers.

## Deployment Considerations

- **Mobile:** CI pipeline should run `flutter analyze`, `flutter test`, and produce signed bundles (AAB/IPA).
- **Backend:** Containerise with Node 20, expose port `8080`, configure CORS for app origins. Attach Redis or Postgres for persisted schedules.
- **Secrets:** Move Mapbox token to secure storage (`flutter_dotenv`, CI secrets, etc.) for production builds.

## Future Enhancements

- Connect backend to live GTFS-RT or Mapbox Transit Data Services.
- Persist favorites and user profiles via Supabase/Auth.
- Implement offline caching using Hive/SQLite on mobile.
- Add CI/CD pipelines and infrastructure-as-code for backend deployment.
