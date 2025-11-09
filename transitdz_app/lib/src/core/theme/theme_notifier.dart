import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system);

  void setTheme(ThemeMode mode) {
    state = mode;
  }

  void toggle() {
    state = state == ThemeMode.light
        ? ThemeMode.dark
        : state == ThemeMode.dark
            ? ThemeMode.system
            : ThemeMode.light;
  }
}
