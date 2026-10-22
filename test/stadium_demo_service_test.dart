import 'package:flutter_test/flutter_test.dart';
import 'package:hundred_km_goal/core/irkutsk_time.dart';
import 'package:hundred_km_goal/models/run_record.dart';
import 'package:hundred_km_goal/services/stadium_demo_service.dart';

void main() {
  test(
    '30 distinct alternate-day sessions stay within July and August 2026',
    () {
      final runs = StadiumDemoService.sessions().reversed.toList();
      expect(runs.length, 30);
      expect(runs.map((r) => r.id).toSet().length, 30);
      expect(IrkutskTime.format(runs.first.startedAt), '01.07.2026 07:00');
      expect(IrkutskTime.local(runs.last.startedAt).day, 28);
      for (var i = 0; i < runs.length; i++) {
        final day = IrkutskTime.local(runs[i].startedAt);
        expect(day.year, 2026);
        expect(day.month, anyOf(7, 8));
        if (i > 0) {
          final previous = IrkutskTime.local(runs[i - 1].startedAt);
          expect(
            DateTime.utc(day.year, day.month, day.day)
                .difference(
                  DateTime.utc(previous.year, previous.month, previous.day),
                )
                .inDays,
            2,
          );
        }
      }
    },
  );

  test('start and finish fit morning or evening windows with consistent running pace', () {
    final runs = StadiumDemoService.sessions();
    var morning = 0;
    var evening = 0;
    for (final run in runs) {
      final start = IrkutskTime.local(run.startedAt);
      final end = IrkutskTime.local(run.finishedAt);
      final startMinute = start.hour * 60 + start.minute;
      final endMinute = end.hour * 60 + end.minute + end.second / 60;
      if (start.hour < 12) {
        morning++;
        expect(startMinute, greaterThanOrEqualTo(7 * 60));
        expect(endMinute, lessThanOrEqualTo(9 * 60));
      } else {
        evening++;
        expect(startMinute, greaterThanOrEqualTo(17 * 60));
        expect(endMinute, lessThanOrEqualTo(18 * 60));
      }
      expect(run.averageSpeedKmh, inInclusiveRange(7.99, 11.01));
      expect(run.distanceKm, closeTo(run.stadiumLaps! * .4, 1e-9));
      expect(
        run.averageSpeedKmh,
        closeTo(run.distanceKm * 3600 / run.durationSeconds, 1e-9),
      );
      expect(
        run.finishedAt.difference(run.startedAt).inSeconds,
        run.durationSeconds,
      );
      expect(run.isDemo, isTrue);
      expect(run.routePoints, isEmpty);
    }
    expect(morning, greaterThan(0));
    expect(evening, greaterThan(0));
    expect(runs.map((r) => r.startedAt.minute).toSet().length, greaterThan(5));
  });

  test(
    'demo metadata round trips and old recordings still default to real',
    () {
      final run = StadiumDemoService.sessions().first;
      final json = run.toJson();
      expect(RunRecord.fromJson(json).isDemo, isTrue);
      expect(RunRecord.fromJson(json).stadiumLaps, run.stadiumLaps);
      json.remove('isDemo');
      json.remove('stadiumLaps');
      expect(RunRecord.fromJson(json).isDemo, isFalse);
    },
  );
}
