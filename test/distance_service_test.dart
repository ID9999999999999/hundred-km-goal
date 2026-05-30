import 'package:flutter_test/flutter_test.dart';
import 'package:hundred_km_goal/models/geo_point.dart';
import 'package:hundred_km_goal/services/distance_service.dart';

void main() {
  test('haversine distance is zero for identical points', () {
    final point = GeoPoint(
      latitude: 52.52,
      longitude: 13.405,
      recordedAt: DateTime.utc(2026),
    );

    expect(DistanceService.haversineMeters(point, point), closeTo(0, 0.001));
  });

  test('average speed returns zero for invalid duration', () {
    expect(DistanceService.averageSpeedKmh(distanceKm: 10, durationSeconds: 0), 0);
  });

  test('average speed computes km per hour', () {
    final speed = DistanceService.averageSpeedKmh(distanceKm: 10, durationSeconds: 7200);
    expect(speed, closeTo(5, 0.001));
  });
}
