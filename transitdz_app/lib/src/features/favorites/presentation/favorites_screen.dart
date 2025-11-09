import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/models/transit_line.dart';
import '../../../core/models/transit_stop.dart';
import '../../../core/repository/transit_repository.dart';
import '../controllers/favorites_controller.dart';

final favoritesDataProvider = FutureProvider<FavoritesData>((ref) async {
  final favorites = ref.watch(favoritesProvider);
  final repository = ref.watch(transitRepositoryProvider);
  final lines = await repository.getLines();
  final stops = await repository.getStops();
  final favoriteLines =
      lines.where((line) => favorites.lineIds.contains(line.id)).toList();
  final favoriteStops =
      stops.where((stop) => favorites.stopIds.contains(stop.id)).toList();
  return FavoritesData(lines: favoriteLines, stops: favoriteStops);
});

class FavoritesData {
  FavoritesData({required this.lines, required this.stops});

  final List<TransitLine> lines;
  final List<TransitStop> stops;
}

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final favoritesAsync = ref.watch(favoritesDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('favorites.title')),
      ),
      body: favoritesAsync.when(
        data: (data) {
          if (data.lines.isEmpty && data.stops.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  l10n.translate('favorites.empty'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Theme.of(context).hintColor),
                ),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              if (data.lines.isNotEmpty) ...[
                Text(
                  l10n.translate('favorites.lines'),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ...data.lines.map((line) => _FavoriteLineTile(line: line)),
                const SizedBox(height: 24),
              ],
              if (data.stops.isNotEmpty) ...[
                Text(
                  l10n.translate('favorites.stops'),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ...data.stops.map((stop) => _FavoriteStopTile(stop: stop)),
              ],
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
      ),
    );
  }
}

class _FavoriteLineTile extends ConsumerWidget {
  const _FavoriteLineTile({required this.line});

  final TransitLine line;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = Color(int.parse(line.color.substring(1), radix: 16) + 0xFF000000);
    final textColor =
        Color(int.parse(line.textColor.substring(1), radix: 16) + 0xFF000000);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Text(line.code, style: TextStyle(color: textColor)),
        ),
        title: Text(line.name),
        subtitle: Text(line.description ?? ''),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () =>
              ref.read(favoritesProvider.notifier).toggleLine(line.id),
        ),
      ),
    );
  }
}

class _FavoriteStopTile extends ConsumerWidget {
  const _FavoriteStopTile({required this.stop});

  final TransitStop stop;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        leading: const Icon(Icons.place_outlined),
        title: Text(stop.name),
        subtitle: Text(stop.wilaya),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () =>
              ref.read(favoritesProvider.notifier).toggleStop(stop.id),
        ),
      ),
    );
  }
}
