import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/localization/locale_notifier.dart';
import '../../../core/theme/theme_notifier.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final currentLocale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('settings.title')),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          Text(
            l10n.translate('settings.language'),
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            children: AppLocalizations.supportedLocales.map((locale) {
              final isSelected = locale.languageCode == currentLocale.languageCode;
              return ChoiceChip(
                label: Text(locale.languageCode.toUpperCase()),
                selected: isSelected,
                onSelected: (_) =>
                    ref.read(localeProvider.notifier).setLocale(locale),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.translate('settings.theme'),
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SegmentedButton<ThemeMode>(
            segments: [
              ButtonSegment(
                value: ThemeMode.light,
                label: Text(l10n.translate('common.light')),
                icon: const Icon(Icons.light_mode_outlined),
              ),
              ButtonSegment(
                value: ThemeMode.dark,
                label: Text(l10n.translate('common.dark')),
                icon: const Icon(Icons.dark_mode_outlined),
              ),
              ButtonSegment(
                value: ThemeMode.system,
                label: Text(l10n.translate('common.system')),
                icon: const Icon(Icons.auto_mode),
              ),
            ],
            selected: {themeMode},
            onSelectionChanged: (selection) =>
                ref.read(themeModeProvider.notifier).setTheme(selection.first),
          ),
        ],
      ),
    );
  }
}
