import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import '../models/run_record.dart';
import '../services/speed_category_service.dart';
import '../widgets/metric_card.dart';

class RunDetailScreen extends StatelessWidget {
  const RunDetailScreen({super.key, required this.run});

  final RunRecord run;

  @override
  Widget build(BuildContext context) {
    final route = run.routePoints
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList(growable: false);
    final center = route.isNotEmpty ? route.first : const LatLng(0, 0);
    final duration = Duration(seconds: run.durationSeconds).toString().split('.').first;
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    final speedLabel = SpeedCategoryService.label(run.averageSpeedKmh);

    return Scaffold(
      appBar: AppBar(title: const Text('Passport stamp detail')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          MetricCard(
            label: 'Distance stamp',
            value: '${run.distanceKm.toStringAsFixed(3)} km',
            helper: dateFormat.format(run.startedAt),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: MetricCard(label: 'Duration', value: duration)),
              const SizedBox(width: 12),
              Expanded(child: MetricCard(label: 'Avg speed', value: '${run.averageSpeedKmh.toStringAsFixed(2)} km/h')),
            ],
          ),
          const SizedBox(height: 12),
          MetricCard(
            label: 'Speed type',
            value: speedLabel,
            helper: SpeedCategoryService.slowRunBandText,
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              height: 360,
              child: route.length < 2
                  ? const Center(child: Text('No route map available for this session.'))
                  : FlutterMap(
                      options: MapOptions(
                        initialCenter: center,
                        initialZoom: 15,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.yasser.hundredkmgoal',
                        ),
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: route,
                              strokeWidth: 5,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Route points: ${run.routePoints.length}'),
          Text('Finished: ${dateFormat.format(run.finishedAt)}'),
        ],
      ),
    );
  }
}
