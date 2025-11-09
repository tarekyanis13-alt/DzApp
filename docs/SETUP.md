# Setup Instructions

## Prerequisites

- Flutter SDK 3.16 or newer
- Node.js 20+
- npm or yarn
- Mapbox account (token already embedded for demo)

## Mobile App

```bash
cd transitdz_app
flutter pub get
flutter run -d chrome # or android/ios target
```

For iOS: open `ios/Runner.xcworkspace` in Xcode, update signing.

## Backend

```bash
cd transitdz_backend
npm install
npm run dev
```

The server listens on `http://localhost:8080` by default. REST base path under `/api`. WebSocket endpoint shares the same origin.

## Linking App & Backend

Update `transitdz_app/lib/src/core/constants/app_constants.dart` to point `websocketUrl` and HTTP base when backend is running locally (e.g., `ws://localhost:8080`).

## Testing

- Backend: `npm test` (add tests) or `npm run lint`
- Flutter: `flutter analyze`, add widget/integration tests as features mature.
