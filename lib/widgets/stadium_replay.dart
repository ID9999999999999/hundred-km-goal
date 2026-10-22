import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/irkutsk_time.dart';
import '../models/run_record.dart';

/// Offline, schematic replay. It deliberately does not manufacture GPS points.
class StadiumReplay extends StatefulWidget {
  const StadiumReplay({super.key, required this.run});

  final RunRecord run;

  @override
  State<StadiumReplay> createState() => _StadiumReplayState();
}

class _StadiumReplayState extends State<StadiumReplay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  int _speed = 10;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _duration)
      ..forward();
  }

  Duration get _duration => Duration(
    milliseconds: math.max(
      1,
      (widget.run.durationSeconds * 1000 / _speed).round(),
    ),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _controller,
    builder: (context, _) {
      final progress = _controller.value;
      final laps = widget.run.stadiumLaps ?? 0;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Стадион ИРНИТУ', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 6),
          const Text(
            'Схема дорожки • пример круга 400 м\nАнимация по заданному темпу, не GPS-запись.',
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Semantics(
              label:
                  'Схема стадиона. Завершено ${(progress * laps).floor()} из $laps кругов.',
              child: AspectRatio(
                aspectRatio: 1.2,
                child: CustomPaint(
                  painter: _StadiumPainter(lapProgress: (progress * laps) % 1),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              Text(
                '${(widget.run.distanceKm * progress).toStringAsFixed(2)} / ${widget.run.distanceKm.toStringAsFixed(2)} км',
              ),
              Text('Круги: ${(progress * laps).floor()} / $laps'),
              Text(
                IrkutskTime.duration(
                  (widget.run.durationSeconds * progress).round(),
                ),
              ),
            ],
          ),
          Slider(
            label: IrkutskTime.duration(
              (widget.run.durationSeconds * progress).round(),
            ),
            value: progress,
            onChangeStart: (_) => _controller.stop(),
            onChanged: (value) => _controller.value = value,
          ),
          Wrap(
            spacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              FilledButton.icon(
                onPressed: () => setState(() {
                  if (_controller.isAnimating) {
                    _controller.stop();
                  } else {
                    if (_controller.isCompleted) _controller.reset();
                    _controller.forward();
                  }
                }),
                icon: Icon(
                  _controller.isAnimating ? Icons.pause : Icons.play_arrow,
                ),
                label: Text(_controller.isAnimating ? 'Пауза' : 'Смотреть'),
              ),
              IconButton(
                tooltip: 'Сначала',
                onPressed: () => setState(() => _controller.forward(from: 0)),
                icon: const Icon(Icons.replay),
              ),
              DropdownButton<int>(
                value: _speed,
                items: [1, 10, 30]
                    .map(
                      (speed) => DropdownMenuItem(
                        value: speed,
                        child: Text('×$speed'),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  final playing = _controller.isAnimating;
                  setState(() {
                    _speed = value;
                    _controller.duration = _duration;
                    if (playing) _controller.forward();
                  });
                },
              ),
            ],
          ),
          const Text('×1 — исходный темп. ×10 и ×30 — ускоренный просмотр.'),
        ],
      );
    },
  );
}

class _StadiumPainter extends CustomPainter {
  const _StadiumPainter({required this.lapProgress});

  final double lapProgress;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(const Color(0xFFEAF1E9), BlendMode.srcOver);
    final center = Offset(size.width / 2, size.height / 2);
    // A rounded stadium shape, not a surveyed geographical outline.
    final rect = Rect.fromCenter(
      center: center,
      width: size.width * .66,
      height: size.height * .79,
    );
    final radius = rect.width / 2;
    final track = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    canvas.drawRRect(
      track.inflate(12),
      Paint()..color = const Color(0xFFAC5944),
    );
    canvas.drawRRect(
      track.deflate(12),
      Paint()..color = const Color(0xFF3F8B60),
    );
    for (final offset in [-8.0, 0.0, 8.0]) {
      canvas.drawRRect(
        offset >= 0 ? track.inflate(offset) : track.deflate(-offset),
        Paint()
          ..color = const Color(0xFFEAC7B9)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
    }
    final field = Rect.fromCenter(
      center: center,
      width: rect.width * .63,
      height: rect.height * .47,
    );
    final line = Paint()
      ..color = const Color(0xFFDFEEDC)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawRect(field, line);
    canvas.drawLine(
      Offset(field.left, center.dy),
      Offset(field.right, center.dy),
      line,
    );
    canvas.drawCircle(center, field.width * .17, line);
    final path = Path()..addRRect(track);
    final metric = path.computeMetrics().first;
    final tangent = metric.getTangentForOffset(metric.length * lapProgress)!;
    final start = metric.getTangentForOffset(0)!;
    canvas.drawCircle(start.position, 4, Paint()..color = Colors.white);
    canvas.drawCircle(
      tangent.position,
      14,
      Paint()..color = const Color(0x553070FF),
    );
    canvas.drawCircle(
      tangent.position,
      8,
      Paint()..color = const Color(0xFF2459D3),
    );
    canvas.drawCircle(
      tangent.position,
      8,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(_StadiumPainter oldDelegate) =>
      oldDelegate.lapProgress != lapProgress;
}
