import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = FlexThemeData.light(
    colors: const FlexSchemeColor(
      primary: Color(0xFF6B3EE6),
      primaryContainer: Color(0xFFE7DEFF),
      secondary: Color(0xFF3E64FF),
      secondaryContainer: Color(0xFFC4D0FF),
      tertiary: Color(0xFF2EC8FF),
      tertiaryContainer: Color(0xFFC8F4FF),
      appBarColor: Color(0xFF0B1A3A),
      error: Color(0xFFE53935),
    ),
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 14,
    appBarOpacity: 0.95,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 12,
      blendOnColors: true,
      elevatedButtonSchemeColor: SchemeColor.primary,
      cardRadius: 24,
      bottomSheetRadius: 24,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    useMaterial3: true,
  ).copyWith(
    scaffoldBackgroundColor: const Color(0xFFFFF6EA),
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.08),
    ),
  );

  static final darkTheme = FlexThemeData.dark(
    colors: const FlexSchemeColor(
      primary: Color(0xFF6B3EE6),
      primaryContainer: Color(0xFF1C2758),
      secondary: Color(0xFF9C6DFF),
      secondaryContainer: Color(0xFF2E335B),
      tertiary: Color(0xFF4AD9FF),
      tertiaryContainer: Color(0xFF123E52),
      appBarColor: Color(0xFF0B1A3A),
      error: Color(0xFFFF6B6B),
    ),
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 16,
    appBarStyle: FlexAppBarStyle.material,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 24,
      blendOnColors: true,
      cardRadius: 24,
      bottomSheetRadius: 24,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    useMaterial3: true,
  ).copyWith(
    scaffoldBackgroundColor: const Color(0xFF0B1A3A),
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: const Color(0xFF15254F),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.2),
    ),
  );
}
