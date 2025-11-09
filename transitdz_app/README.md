# TransitDZ Mobile App

TransitDZ is a modern Flutter application delivering real-time multimodal public transport information for Algeria's 58 wilayas.

## Features

- Onboarding flow with theme toggle
- Home dashboard with search, live alerts, and suggested itineraries
- Mapbox-powered map with stop markers and simulated vehicle tracking
- Route planner with itinerary details and timeline visualization
- Stop and line detail pages with schedules, amenities, and alerts
- Favorites management for frequently used stops and lines
- Settings page for language (Arabic/French/English) and theme preferences

## Requirements

- Flutter SDK 3.16+
- Dart SDK 3.2+
- Android Studio or Xcode for building mobile targets
- Mapbox access token embedded in `AppConstants`

## Getting Started

```bash
flutter pub get
flutter run
```

The included mock data and WebSocket simulation provide offline demos of real-time behaviour. Update the repository layer to consume the TransitDZ backend once deployed.

## Project Structure

```
lib/
  main.dart
  src/
    app.dart
    app_router.dart
    bootstrap.dart
    core/
      constants/
      localization/
      models/
      repository/
      services/
      theme/
      utils/
    features/
      onboarding/
      home/
      map/
      planner/
      realtime/
      stops/
      lines/
      favorites/
      settings/
      common/
assets/
  data/
  translations/
  icons/
  lottie/
```

## Testing

Add widget and integration tests under `test/` and `integration_test/` as features evolve. Automated golden tests are recommended for the design system tokens.
