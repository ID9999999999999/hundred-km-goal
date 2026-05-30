import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/run_record.dart';
import '../services/run_storage_service.dart';
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

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');

    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _runs.isEmpty
              ? const Center(child: Text('No saved sessions yet.'))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _runs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final run = _runs[index];
                    final duration = Duration(seconds: run.durationSeconds).toString().split('.').first;
                    return Dismissible(
                      key: ValueKey(run.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: Colors.red.shade700,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.delete_rounded, color: Colors.white),
                      ),
                      onDismissed: (_) => _delete(run),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.black12),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        title: Text('${run.distanceKm.toStringAsFixed(2)} km'),
                        subtitle: Text('${dateFormat.format(run.startedAt)} • $duration • ${run.averageSpeedKmh.toStringAsFixed(2)} km/h'),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(builder: (_) => RunDetailScreen(run: run)),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
