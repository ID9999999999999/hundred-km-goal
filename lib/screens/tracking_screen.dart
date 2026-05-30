import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../core/app_constants.dart';
import '../models/geo_point.dart';
import '../models/run_record.dart';
import '../services/distance_service.dart';
import '../services/location_permission_service.dart';
import '../services/run_storage_service.dart';
import '../widgets/metric_card.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  final RunStorageService _storage = RunStorageService();
  final Stopwatch _stopwatch = Stopwatch();
  final List<GeoPoint> _points = [];

  StreamSubscription<Position>? _subscription;
  Timer? _timer;
  bool _isTracking = false;
  bool _isPaused = false;
  DateTime? _startedAt;
  String? _message;

  @override
  void dispose() {
    _subscription?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  double get _distanceKm => DistanceService.totalDistanceKm(_points);
  int get _durationSeconds => _stopwatch.elapsed.inSeconds;
  double get _averageSpeedKmh => DistanceService.averageSpeedKmh(
        distanceKm: _distanceKm,
        durationSeconds: _durationSeconds,
      );

  Future<void> _start() async {
    final error = await LocationPermissionService.ensureReady();
    if (error != null) {
      setState(() => _message = error);
      return;
    }

    _startedAt = DateTime.now();
    _stopwatch.start();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });

    const settings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 5,
    );

    _subscription = Geolocator.getPositionStream(locationSettings: settings).listen(
      _handlePosition,
      onError: (Object error) {
        setState(() => _message = 'GPS error: $error');
      },
    );

    setState(() {
      _isTracking = true;
      _isPaused = false;
      _message = 'Tracking started.';
    });
  }

  void _handlePosition(Position position) {
    if (_isPaused) {
      return;
    }

    final point = GeoPoint(
      latitude: position.latitude,
      longitude: position.longitude,
      recordedAt: DateTime.now(),
      accuracyMeters: position.accuracy,
      speedMetersPerSecond: position.speed,
    );

    if (position.accuracy > AppConstants.maxAcceptedAccuracyMeters) {
      setState(() => _message = 'Weak GPS point ignored: ${position.accuracy.toStringAsFixed(0)} m accuracy.');
      return;
    }

    if (_points.isNotEmpty) {
      final previous = _points.last;
      final segmentMeters = DistanceService.haversineMeters(previous, point);
      final segmentSpeed = DistanceService.segmentSpeedKmh(previous, point);

      if (segmentMeters < AppConstants.minAcceptedSegmentMeters) {
        return;
      }

      if (segmentSpeed > AppConstants.maxAcceptedSegmentSpeedKmh) {
        setState(() => _message = 'Suspicious GPS jump ignored: ${segmentSpeed.toStringAsFixed(1)} km/h.');
        return;
      }
    }

    setState(() {
      _points.add(point);
      _message = 'GPS points: ${_points.length}';
    });
  }

  void _pauseOrResume() {
    setState(() {
      _isPaused = !_isPaused;
      if (_isPaused) {
        _stopwatch.stop();
        _message = 'Session paused.';
      } else {
        _stopwatch.start();
        _message = 'Session resumed.';
      }
    });
  }

  Future<void> _finish() async {
    _stopwatch.stop();
    await _subscription?.cancel();
    _timer?.cancel();

    final startedAt = _startedAt ?? DateTime.now();
    final finishedAt = DateTime.now();
    final record = RunRecord(
      id: finishedAt.microsecondsSinceEpoch.toString(),
      startedAt: startedAt,
      finishedAt: finishedAt,
      distanceKm: _distanceKm,
      durationSeconds: _durationSeconds,
      averageSpeedKmh: _averageSpeedKmh,
      routePoints: List.unmodifiable(_points),
    );

    if (record.distanceKm <= 0 || record.durationSeconds <= 0) {
      setState(() {
        _isTracking = false;
        _message = 'Nothing saved: no valid distance was recorded.';
      });
      return;
    }

    await _storage.saveRun(record);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Saved ${record.distanceKm.toStringAsFixed(2)} km.')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final duration = Duration(seconds: _durationSeconds);
    final formattedDuration = duration.toString().split('.').first.padLeft(8, '0');

    return Scaffold(
      appBar: AppBar(title: const Text('Track session')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          MetricCard(
            label: 'Current distance',
            value: '${_distanceKm.toStringAsFixed(3)} km',
            helper: _message,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: MetricCard(
                  label: 'Duration',
                  value: formattedDuration,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MetricCard(
                  label: 'Average speed',
                  value: '${_averageSpeedKmh.toStringAsFixed(2)} km/h',
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          if (!_isTracking)
            FilledButton.icon(
              onPressed: _start,
              icon: const Icon(Icons.gps_fixed_rounded),
              label: const Text('Start GPS'),
            )
          else ...[
            OutlinedButton.icon(
              onPressed: _pauseOrResume,
              icon: Icon(_isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded),
              label: Text(_isPaused ? 'Resume' : 'Pause'),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _finish,
              icon: const Icon(Icons.flag_rounded),
              label: const Text('Finish and save'),
            ),
          ],
          const SizedBox(height: 20),
          const Text(
            'Keep the phone with you during the session. Early prototype mode is most reliable when the app remains open.',
          ),
        ],
      ),
    );
  }
}
