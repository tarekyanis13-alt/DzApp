import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesState {
  const FavoritesState({
    this.lineIds = const [],
    this.stopIds = const [],
    this.tripIds = const [],
  });

  final List<String> lineIds;
  final List<String> stopIds;
  final List<String> tripIds;

  FavoritesState copyWith({
    List<String>? lineIds,
    List<String>? stopIds,
    List<String>? tripIds,
  }) {
    return FavoritesState(
      lineIds: lineIds ?? this.lineIds,
      stopIds: stopIds ?? this.stopIds,
      tripIds: tripIds ?? this.tripIds,
    );
  }
}

class FavoritesController extends StateNotifier<FavoritesState> {
  FavoritesController() : super(const FavoritesState());

  void toggleLine(String lineId) {
    final list = [...state.lineIds];
    if (list.contains(lineId)) {
      list.remove(lineId);
    } else {
      list.add(lineId);
    }
    state = state.copyWith(lineIds: list);
  }

  void toggleStop(String stopId) {
    final list = [...state.stopIds];
    if (list.contains(stopId)) {
      list.remove(stopId);
    } else {
      list.add(stopId);
    }
    state = state.copyWith(stopIds: list);
  }

  void toggleTrip(String tripId) {
    final list = [...state.tripIds];
    if (list.contains(tripId)) {
      list.remove(tripId);
    } else {
      list.add(tripId);
    }
    state = state.copyWith(tripIds: list);
  }
}

final favoritesProvider =
    StateNotifierProvider<FavoritesController, FavoritesState>((ref) {
  return FavoritesController();
});
