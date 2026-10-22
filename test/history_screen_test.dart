import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hundred_km_goal/core/app_constants.dart';
import 'package:hundred_km_goal/screens/history_screen.dart';

const previewKey = ValueKey('preview');

Future<void> capture(WidgetTester tester, String name) async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(find.byKey(previewKey));
  await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: 2);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    final file = File('build/previews/$name.png');
    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes!.buffer.asUint8List());
    image.dispose();
  });
}

void main() {
  testWidgets('Russian demo archive stays separate from stored recordings', (tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const RepaintBoundary(
      key: previewKey,
      child: MaterialApp(
        locale: Locale('ru'),
        supportedLocales: [Locale('ru')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        home: HistoryScreen(),
      ),
    ));
    await tester.pumpAndSettle();
    expect(find.text('Архив тренировок'), findsOneWidget);
    expect(find.textContaining('30 тренировок'), findsOneWidget);
    expect(find.textContaining('Демонстрационные тренировки'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await capture(tester, 'archive-ru');
    await tester.tap(find.text('Мои записи'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Пока нет записей'), findsOneWidget);
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getStringList(AppConstants.runStorageKey), isNull);
    await tester.tap(find.text('Пример: ИРНИТУ'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.play_circle_outline).first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Пример тренировки'), findsOneWidget);
    expect(find.text('ДЕМОНСТРАЦИОННЫЕ ДАННЫЕ'), findsOneWidget);
    await tester.ensureVisible(find.text('Стадион ИРНИТУ'));
    await tester.pump(const Duration(milliseconds: 100));
    await capture(tester, 'stadium-replay-ru');
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}
