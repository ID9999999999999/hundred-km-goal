import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../core/irkutsk_time.dart';
import '../models/run_record.dart';
import '../services/speed_category_service.dart';
import '../widgets/metric_card.dart';
import '../widgets/stadium_replay.dart';

class RunDetailScreen extends StatelessWidget {
  const RunDetailScreen({super.key, required this.run});

  final RunRecord run;

  @override
  Widget build(BuildContext context) {
    final route = run.routePoints
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList(growable: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(run.isDemo ? 'Пример тренировки' : 'Тренировка'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (run.isDemo) ...[
            const Text(
              'ДЕМОНСТРАЦИОННЫЕ ДАННЫЕ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
          ],
          Text(
            IrkutskTime.format(run.startedAt),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Text('Иркутск (UTC+8)'),
          const SizedBox(height: 16),
          MetricCard(
            label: 'Расстояние',
            value: '${run.distanceKm.toStringAsFixed(2)} км',
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              MetricCard(
                label: 'Время',
                value: IrkutskTime.duration(run.durationSeconds),
              ),
              MetricCard(
                label: 'Средняя скорость',
                value: '${run.averageSpeedKmh.toStringAsFixed(1)} км/ч',
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(SpeedCategoryService.label(run.averageSpeedKmh)),
          const SizedBox(height: 24),
          if (run.isDemo)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StadiumReplay(run: run),
                const SizedBox(height: 20),
                const _StadiumLocation(),
              ],
            )
          else if (route.length < 2)
            const Text('Для этой тренировки нет карты маршрута.')
          else ...[
            SizedBox(
              height: 360,
              child: FlutterMap(
                options: MapOptions(
                  initialCameraFit: CameraFit.bounds(
                    bounds: LatLngBounds.fromPoints(route),
                    padding: const EdgeInsets.all(32),
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.yasser.hundred_km_goal',
                  ),
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: route,
                        strokeWidth: 5,
                        color: const Color(0xFF145D46),
                      ),
                    ],
                  ),
                  const SimpleAttributionWidget(
                    source: Text('© OpenStreetMap contributors'),
                  ),
                ],
              ),
            ),
            const Text('Для загрузки карты нужен интернет.'),
            Text('Точек GPS: ${route.length}'),
          ],
          const SizedBox(height: 20),
          Text('Окончание: ${IrkutskTime.format(run.finishedAt)}'),
        ],
      ),
    );
  }
}

class _StadiumLocation extends StatelessWidget {
  const _StadiumLocation();

  @override
  Widget build(BuildContext context) => ExpansionTile(
    title: const Text('Расположение стадиона на карте'),
    subtitle: const Text('ИРНИТУ • Иркутск'),
    children: [
      SizedBox(
        height: 300,
        child: FlutterMap(
          options: const MapOptions(
            initialCenter: LatLng(52.262993, 104.265678),
            initialZoom: 17,
            minZoom: 16,
            maxZoom: 19,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.yasser.hundred_km_goal',
            ),
            const MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(52.262993, 104.265678),
                  width: 40,
                  height: 40,
                  child: Icon(
                    Icons.location_on,
                    size: 40,
                    color: Color(0xFF145D46),
                  ),
                ),
              ],
            ),
            const SimpleAttributionWidget(
              source: Text('© OpenStreetMap contributors'),
            ),
          ],
        ),
      ),
      const Padding(
        padding: EdgeInsets.all(12),
        child: Text(
          'Для карты нужен интернет. Метка показывает место стадиона; схема анимации выше условная.',
        ),
      ),
    ],
  );
}
