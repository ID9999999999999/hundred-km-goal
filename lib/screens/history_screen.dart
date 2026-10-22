import 'package:flutter/material.dart';

import '../core/irkutsk_time.dart';
import '../models/run_record.dart';
import '../services/run_storage_service.dart';
import '../services/speed_category_service.dart';
import '../services/stadium_demo_service.dart';
import 'run_detail_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _storage = RunStorageService();
  final _examples = StadiumDemoService.sessions();
  List<RunRecord> _recorded = [];
  bool _demo = true;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final runs = await _storage.loadRuns();
      if (!mounted) return;
      setState(() {
        _recorded = runs;
        _loading = false;
        _error = null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Не удалось прочитать записи. Потяните вниз, чтобы повторить.';
      });
    }
  }

  Future<void> _delete(RunRecord run) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить тренировку?'),
        content: const Text('Эту запись нельзя будет восстановить.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await _storage.deleteRun(run.id);
      await _load();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось удалить запись.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final runs = _demo ? _examples : _recorded;
    final total = runs.fold<double>(0, (sum, run) => sum + run.distanceKm);
    return Scaffold(
      appBar: AppBar(title: const Text('Архив тренировок')),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          children: [
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('Пример: ИРНИТУ')),
                ButtonSegment(value: false, label: Text('Мои записи')),
              ],
              selected: {_demo},
              onSelectionChanged: (value) =>
                  setState(() => _demo = value.first),
            ),
            const SizedBox(height: 24),
            Text(
              _demo ? 'Стадион ИРНИТУ' : 'Мои тренировки',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              _demo
                  ? 'Июль — август 2026 • через день\nДемонстрационные тренировки и анимация, не записи GPS.'
                  : 'Настоящие тренировки, сохранённые на этом телефоне.',
            ),
            const SizedBox(height: 20),
            Text(
              '${total.toStringAsFixed(2)} км • ${runs.length} тренировок',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: (total / 100).clamp(0, 1),
              minHeight: 8,
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(height: 8),
            Text(_demo ? 'Пример прогресса к цели 100 км' : 'Цель: 100 км'),
            const Text('Время: Иркутск (UTC+8)'),
            const SizedBox(height: 24),
            if (!_demo && _loading)
              const Center(child: CircularProgressIndicator()),
            if (!_demo && _error != null) Text(_error!),
            if (!_demo && !_loading && runs.isEmpty && _error == null)
              const Text('Пока нет записей. Завершите и сохраните тренировку.'),
            for (var i = 0; i < runs.length; i++) ...[
              if (i == 0 ||
                  IrkutskTime.local(runs[i].startedAt).month !=
                      IrkutskTime.local(runs[i - 1].startedAt).month)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    '${_month(IrkutskTime.local(runs[i].startedAt).month)} ${IrkutskTime.local(runs[i].startedAt).year}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(child: Text('${runs.length - i}')),
                title: Text(
                  '${runs[i].distanceKm.toStringAsFixed(2)} км  ·  ${IrkutskTime.duration(runs[i].durationSeconds)}',
                ),
                subtitle: Text(
                  '${IrkutskTime.format(runs[i].startedAt)}\n${runs[i].averageSpeedKmh.toStringAsFixed(1)} км/ч · ${SpeedCategoryService.label(runs[i].averageSpeedKmh)}${_demo ? '\nПример · Стадион ИРНИТУ' : ''}',
                ),
                isThreeLine: true,
                trailing: _demo
                    ? const Icon(Icons.play_circle_outline)
                    : IconButton(
                        tooltip: 'Удалить',
                        onPressed: () => _delete(runs[i]),
                        icon: const Icon(Icons.delete_outline),
                      ),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => RunDetailScreen(run: runs[i]),
                  ),
                ),
              ),
              const Divider(),
            ],
          ],
        ),
      ),
    );
  }

  String _month(int month) => const [
    'Январь',
    'Февраль',
    'Март',
    'Апрель',
    'Май',
    'Июнь',
    'Июль',
    'Август',
    'Сентябрь',
    'Октябрь',
    'Ноябрь',
    'Декабрь',
  ][month - 1];
}
