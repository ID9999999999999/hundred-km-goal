import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hundred_km_goal/services/stadium_demo_service.dart';
import 'package:hundred_km_goal/widgets/stadium_replay.dart';

void main() {
  testWidgets('replay advances, pauses, scrubs, changes speed and restarts', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(360, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: StadiumReplay(run: StadiumDemoService.sessions().first),
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(seconds: 2));
    expect(tester.widget<Slider>(find.byType(Slider)).value, greaterThan(0));
    await tester.tap(find.text('Пауза'));
    await tester.pump();
    final paused = tester.widget<Slider>(find.byType(Slider)).value;
    await tester.pump(const Duration(seconds: 2));
    expect(tester.widget<Slider>(find.byType(Slider)).value, paused);
    tester.widget<Slider>(find.byType(Slider)).onChanged!(.5);
    await tester.pump();
    expect(tester.widget<Slider>(find.byType(Slider)).value, .5);
    tester
        .widget<DropdownButton<int>>(find.byType(DropdownButton<int>))
        .onChanged!(30);
    await tester.pump();
    expect(
      tester
          .widget<DropdownButton<int>>(find.byType(DropdownButton<int>))
          .value,
      30,
    );
    await tester.tap(find.text('Смотреть'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(tester.widget<Slider>(find.byType(Slider)).value, greaterThan(.5));
    await tester.tap(find.byTooltip('Сначала'));
    await tester.pump();
    expect(tester.widget<Slider>(find.byType(Slider)).value, lessThan(.01));
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}
