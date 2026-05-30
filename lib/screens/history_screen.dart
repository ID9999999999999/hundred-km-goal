import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../core/app_constants.dart';
import '../models/run_record.dart';
import '../services/run_storage_service.dart';
import '../services/speed_category_service.dart';
import 'run_detail_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
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

  Future<void> _delete(RunRecord run) async {
    await _storage.deleteRun(run.id);
    await _load();
  }

  double get _totalKm => _runs.fold(0, (sum, run) => sum + run.distanceKm);
  double get _remainingKm => (AppConstants.goalDistanceKm - _totalKm).clamp(0, AppConstants.goalDistanceKm);
  double get _progress => (_totalKm / AppConstants.goalDistanceKm).clamp(0, 1);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');

    return Scaffold(
      appBar: AppBar(title: const Text('100KM Passport')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _PassportCard(
                    totalKm: _totalKm,
                    remainingKm: _remainingKm,
                    progress: _progress,
                    sessions: _runs.length,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Session stamps',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  if (_runs.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(18),
                        child: Text('No stamps yet. Start a real outdoor session, finish it, and it will appear here.'),
                      ),
                    )
                  else
                    for (var index = 0; index < _runs.length; index++) ...[
                      _PassportStamp(
                        run: _runs[index],
                        number: _runs.length - index,
                        dateText: dateFormat.format(_runs[index].startedAt),
                        onDelete: () => _delete(_runs[index]),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(builder: (_) => RunDetailScreen(run: _runs[index])),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                ],
              ),
            ),
    );
  }
}

class _PassportCard extends StatelessWidget {
  const _PassportCard({
    required this.totalKm,
    required this.remainingKm,
    required this.progress,
    required this.sessions,
  });

  final double totalKm;
  final double remainingKm;
  final double progress;
  final int sessions;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.black26),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.badge_rounded, size: 34),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('جواز 100 كيلومتر', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 2),
                      const Text('100KM Passport'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text('${totalKm.toStringAsFixed(2)} / 100.00 km', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              borderRadius: BorderRadius.circular(99),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _ChipLine(label: 'Remaining', value: '${remainingKm.toStringAsFixed(2)} km'),
                _ChipLine(label: 'Stamps', value: sessions.toString()),
                const _ChipLine(label: 'Reference', value: '6.0–8.5 km/h slow run'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PassportStamp extends StatelessWidget {
  const _PassportStamp({
    required this.run,
    required this.number,
    required this.dateText,
    required this.onDelete,
    required this.onTap,
  });

  final RunRecord run;
  final int number;
  final String dateText;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final duration = Duration(seconds: run.durationSeconds).toString().split('.').first;
    final speedLabel = SpeedCategoryService.label(run.averageSpeedKmh);
    final speedNote = SpeedCategoryService.passportNote(run.averageSpeedKmh);

    return Dismissible(
      key: ValueKey(run.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.shade700,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(Icons.delete_rounded, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    child: Text(number.toString()),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${run.distanceKm.toStringAsFixed(2)} km', style: Theme.of(context).textTheme.titleLarge),
                        Text(dateText),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _ChipLine(label: 'Time', value: duration),
                  _ChipLine(label: 'Speed', value: '${run.averageSpeedKmh.toStringAsFixed(2)} km/h'),
                  _ChipLine(label: 'Type', value: speedLabel),
                ],
              ),
              const SizedBox(height: 10),
              Text(speedNote),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChipLine extends StatelessWidget {
  const _ChipLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text('$label: $value'),
    );
  }
}
