# TransitDZ Design System

## Color Tokens

| Token             | Light Mode | Dark Mode | Usage                                |
|-------------------|------------|-----------|--------------------------------------|
| `primary`         | #6B3EE6    | #6B3EE6   | Buttons, accents, focused controls   |
| `background`      | #FFF6EA    | #0B1A3A   | Scaffold backgrounds                 |
| `surface`         | #FFFFFF    | #15254F   | Cards, sheets                        |
| `surfaceVariant`  | #F1E8FF    | #1E2D5F   | Secondary surfaces, chips            |
| `error`           | #E53935    | #FF6B6B   | Error states                         |
| `info`            | #2EC8FF    | #4AD9FF   | Info banners                         |

## Typography (Material 3 base)

- Display / Headlines: `Manrope` (system fallback) 28–32 px, bold
- Title: 20–24 px, medium weight
- Body: 14–16 px, regular
- Label: 12–14 px uppercase for chips and badges

## Components

- **Cards:** 24 px radius, subtle elevation (light: 4, dark: 2).
- **Buttons:** Rounded (32 px) with filled primary and tonal variants.
- **Chips:** Choice/Filter chips for language selection, 18 px radius.
- **Inputs:** Filled text fields with 20 px radius and icon prefixes.
- **Navigation:** Top AppBar, contextual floating actions (map card), GoRouter for transitions.

## Iconography

- Material Symbols with rounded weight; map markers use Mapbox glyphs.
- Transport mode icons: `directions_transit`, `tram`, `train`, `directions_bus`, `airport_shuttle`.

## Motion

- Default animation curve: `Curves.easeOut` with 250–400 ms durations.
- Page transitions handled by GoRouter (Material transitions).
- Map card uses fade/scale animate on load.

## Accessibility

- Minimum contrast 4.5:1 verified for text vs background colours.
- Language toggles accessible via ChoiceChips for screen readers.
- Dynamic type supported via Material text styles.

## Assets

- Mapbox style toggles: `dark-v11` and `light-v11`.
- Placeholder Lottie files for future onboarding animations.

## Layout

- Base grid: 8 px spacing increments.
- Onboarding uses centered column with 240 px hero illustration zone.
- Home screen layout: search card, map preview, stacked content sections.

## Future Enhancements

- Create shared `DesignTokens` file for colors/spacing to sync with backend admin portal.
- Build Figma component library mirroring Flutter widgets for collaborative design.
