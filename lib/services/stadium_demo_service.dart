import '../models/run_record.dart';

/// Deterministic examples, never saved as GPS recordings or counted as real runs.
class StadiumDemoService {
  const StadiumDemoService._();

  static List<RunRecord> sessions() => List.generate(30, (index) {
    final evening = index % 3 == 1;
    final hour = evening ? 17 : 7 + (index % 2);
    final minute = evening ? (index * 7) % 18 : (index * 11) % 16;
    // Store real instants; display them explicitly in Irkutsk time (UTC+8).
    final start = DateTime.utc(2026, 7, 1 + index * 2, hour - 8, minute);
    final laps = 7 + (index * 3) % 5;
    final distance = laps * 0.4;
    final requestedSpeed = 8.0 + (index * 7 % 31) / 10;
    final seconds = (distance / requestedSpeed * 3600).round();
    return RunRecord(
      id: 'irnitu-demo-2026-$index',
      startedAt: start,
      finishedAt: start.add(Duration(seconds: seconds)),
      distanceKm: distance,
      durationSeconds: seconds,
      averageSpeedKmh: distance * 3600 / seconds,
      routePoints: const [],
      isDemo: true,
      stadiumLaps: laps,
    );
  }).reversed.toList(growable: false);
}
