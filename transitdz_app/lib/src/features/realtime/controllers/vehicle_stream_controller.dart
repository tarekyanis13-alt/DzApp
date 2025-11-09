import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/vehicle_position.dart';
import '../../../core/repository/transit_repository.dart';

final vehicleStreamProvider = StreamProvider<List<VehiclePosition>>((ref) {
  final repository = ref.watch(transitRepositoryProvider);
  final controller = StreamController<List<VehiclePosition>>();
  Timer? timer;
  final random = Random();

  Future<void> pushUpdate() async {
    final positions = await repository.getVehiclePositions();
    final jittered = positions
        .map((vehicle) => vehicle.copyWith(
              latitude: vehicle.latitude + (random.nextDouble() - 0.5) * 0.001,
              longitude: vehicle.longitude + (random.nextDouble() - 0.5) * 0.001,
              lastUpdated: DateTime.now(),
            ))
        .toList();
    if (!controller.isClosed) {
      controller.add(jittered);
    }
  }

  pushUpdate();
  timer = Timer.periodic(const Duration(seconds: 8), (_) => pushUpdate());

  ref.onDispose(() {
    timer?.cancel();
    controller.close();
  });

  return controller.stream;
});
