import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/models/transit_stop.dart';
import '../../../core/models/vehicle_position.dart';
import '../../../core/repository/transit_repository.dart';
import '../../realtime/controllers/vehicle_stream_controller.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  MapboxMapController? _mapController;
  StreamSubscription<List<VehiclePosition>>? _vehicleSub;

  @override
  void dispose() {
    _vehicleSub?.cancel();
    super.dispose();
  }

  Future<void> _loadStops(MapboxMapController controller) async {
    final stops = await ref.read(transitRepositoryProvider).getStops();
    for (final stop in stops) {
      await controller.addSymbol(
        SymbolOptions(
          geometry: LatLng(stop.latitude, stop.longitude),
          iconImage: 'marker-15',
          iconColor: _colorForModes(stop.modes),
          textField: stop.name,
          textAnchor: 'top',
          textOffset: const Offset(0, 1.4),
        ),
      );
    }
  }

  void _subscribeVehicles(MapboxMapController controller) {
    _vehicleSub = ref
        .read(vehicleStreamProvider.stream)
        .listen((vehicles) {
      controller.clearSymbols().then((_) => _loadStops(controller));
      for (final vehicle in vehicles) {
        controller.addSymbol(
          SymbolOptions(
            geometry: LatLng(vehicle.latitude, vehicle.longitude),
            iconImage: 'bus-15',
            iconRotate: vehicle.bearing,
            textField: vehicle.lineId,
            textAnchor: 'top',
            textOffset: const Offset(0, 1.0),
          ),
        );
      }
    });
  }

  String _colorForModes(List<TransitMode> modes) {
    if (modes.contains(TransitMode.metro)) return '#6B3EE6';
    if (modes.contains(TransitMode.tram)) return '#9C6DFF';
    if (modes.contains(TransitMode.rail)) return '#2E86DE';
    if (modes.contains(TransitMode.intercity)) return '#FF8A80';
    if (modes.contains(TransitMode.sharedTaxi)) return '#F4D03F';
    return '#2EC8FF';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TransitDZ Map'),
      ),
      body: MapboxMap(
        accessToken: AppConstants.mapboxAccessToken,
        styleString: Theme.of(context).brightness == Brightness.dark
            ? AppConstants.mapboxStyleDark
            : AppConstants.mapboxStyleLight,
        initialCameraPosition: const CameraPosition(
          target: LatLng(36.7538, 3.0588),
          zoom: 11.5,
        ),
        myLocationEnabled: true,
        onMapCreated: (controller) async {
          _mapController = controller;
          await _loadStops(controller);
          _subscribeVehicles(controller);
        },
      ),
    );
  }
}
