import 'package:flutter/material.dart';

import '../core/app_constants.dart';
import '../models/run_record.dart';
import '../services/run_storage_service.dart';
import '../widgets/metric_card.dart';
import 'history_screen.dart';
import 'tracking_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RunStorageService _storage = RunStorageService();
  List<RunRecord> _runs = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final runs = await _storage.loadRuns();
    if (!mounted) {
      return;
    }
    setState(() {
      _runs = runs;
      _loading = false;
    });
  }

  double get _totalKm => _runs.fold(0, (sum, run) => sum + run.distanceKm);
  double get _remainingKm => (AppConstants.goalDistanceKm - _totalKm).clamp(0, AppConstants.goalDistanceKm);
  double get _progress => (_totalKm / AppConstants.goalDistanceKm).clamp(0, 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('100KM Goal'),
        centerTitle: false,
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Personal distance campaign',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Record real walking or running sessions and build a clean internal history toward 100 km.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            if (_loading)
              const Center(child: CircularProgressIndicator())
            else ...[
              MetricCard(
                label: 'Total distance',
                value: '${_totalKm.toStringAsFixed(2)} / 100 km',
                helper: '${(_progress * 100).toStringAsFixed(1)}% completed',
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: _progress,
                minHeight: 12,
                borderRadius: BorderRadius.circular(99),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: MetricCard(
                      label: 'Remaining',
                      value: '${_remainingKm.toStringAsFixed(2)} km',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: MetricCard(
                      label: 'Sessions',
                      value: _runs.length.toString(),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => const TrackingScreen()),
                );
                await _load();
              },
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Start session'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => const HistoryScreen()),
                );
                await _load();
              },
              icon: const Icon(Icons.history_rounded),
              label: const Text('Open history'),
            ),
            const SizedBox(height: 32),
            const Text(
              'Integrity rule: this app is built for personal truth. It filters obvious GPS noise, but it is not an official race-certification system.',
            ),
          ],
        ),
      ),
    );
  }
}
