import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../core/app_constants.dart';
import '../models/run_record.dart';

class RunStorageService {
  Future<List<RunRecord>> loadRuns() async {
    final preferences = await SharedPreferences.getInstance();
    final rawItems = preferences.getStringList(AppConstants.runStorageKey) ?? [];
    final runs = rawItems
        .map((raw) => RunRecord.fromJson(jsonDecode(raw) as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => b.startedAt.compareTo(a.startedAt));
    return runs;
  }

  Future<void> saveRun(RunRecord run) async {
    final preferences = await SharedPreferences.getInstance();
    final runs = await loadRuns();
    final nextRuns = [run, ...runs.where((item) => item.id != run.id)];
    final encoded = nextRuns.map((item) => jsonEncode(item.toJson())).toList();
    await preferences.setStringList(AppConstants.runStorageKey, encoded);
  }

  Future<void> deleteRun(String id) async {
    final preferences = await SharedPreferences.getInstance();
    final runs = await loadRuns();
    final encoded = runs
        .where((item) => item.id != id)
        .map((item) => jsonEncode(item.toJson()))
        .toList();
    await preferences.setStringList(AppConstants.runStorageKey, encoded);
  }

  Future<double> totalDistanceKm() async {
    final runs = await loadRuns();
    return runs.fold<double>(0, (sum, run) => sum + run.distanceKm);
  }
}
