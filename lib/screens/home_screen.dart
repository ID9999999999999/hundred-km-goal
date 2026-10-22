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
  double get _remainingKm => (AppConstants.goalDistanceKm - _totalKm).clamp(
    0,
    AppConstants.goalDistanceKm,
  );
  double get _progress => (_totalKm / AppConstants.goalDistanceKm).clamp(0, 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Цель — 100 км'), centerTitle: false),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Моя цель — 100 км',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Записывайте тренировки на телефоне. В архиве — отдельный пример на стадионе ИРНИТУ: 30 тренировок за июль и август 2026 года.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            if (_loading)
              const Center(child: CircularProgressIndicator())
            else ...[
              MetricCard(
                label: 'Мои километры',
                value: '${_totalKm.toStringAsFixed(2)} / 100 км',
                helper: '${(_progress * 100).toStringAsFixed(1)}% выполнено',
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
                      label: 'Осталось',
                      value: '${_remainingKm.toStringAsFixed(2)} км',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: MetricCard(
                      label: 'Тренировок',
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
                  MaterialPageRoute<void>(
                    builder: (_) => const TrackingScreen(),
                  ),
                );
                await _load();
              },
              icon: const Icon(Icons.directions_run_rounded),
              label: const Text('Начать тренировку'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const HistoryScreen(),
                  ),
                );
                await _load();
              },
              icon: const Icon(Icons.badge_rounded),
              label: const Text('Открыть архив'),
            ),
            const SizedBox(height: 28),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Как пользоваться',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '1. Откройте архив для просмотра примеров.\n2. Для своей записи нажмите «Начать тренировку».\n3. Разрешите доступ к геолокации.\n4. После пробежки нажмите «Завершить и сохранить».\nПримеры не входят в ваши личные километры.',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
