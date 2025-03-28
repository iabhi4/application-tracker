import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/application.dart';

class PreferencesService {
  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static Future<void> saveName(String name) async {
    final prefs = await _prefs;
    await prefs.setString('userName', name);
  }

  static Future<String?> getName() async {
    final prefs = await _prefs;
    return prefs.getString('userName');
  }

  static Future<void> saveCount(int count) async {
    final prefs = await _prefs;
    await prefs.setInt('appCount', count);
  }

  static Future<int> getCount() async {
    final prefs = await _prefs;
    return prefs.getInt('appCount') ?? 0;
  }

  static Future<void> saveApplications(List<Application> apps) async {
    final prefs = await _prefs;
    final list = apps.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList('applications', list);
  }

  static Future<List<Application>> getApplications() async {
    final prefs = await _prefs;
    final list = prefs.getStringList('applications') ?? [];
    return list.map((e) => Application.fromJson(jsonDecode(e))).toList();
  }

  static Future<void> clearAll() async {
    final prefs = await _prefs;
    await prefs.clear();
  }

  static Future<void> saveDailyTarget(int value) async {
    final prefs = await _prefs;
    await prefs.setInt('dailyTarget', value);
  }

  static Future<int> getDailyTarget() async {
    final prefs = await _prefs;
    return prefs.getInt('dailyTarget') ?? 0;
  }

  static Future<void> saveDailyRemaining(int value) async {
    final prefs = await _prefs;
    await prefs.setInt('dailyRemaining', value);
  }

  static Future<int> getDailyRemaining() async {
    final prefs = await _prefs;
    return prefs.getInt('dailyRemaining') ?? 0;
  }

  static Future<void> saveLastResetDate(String date) async {
    final prefs = await _prefs;
    await prefs.setString('lastResetDate', date);
  }

  static Future<String?> getLastResetDate() async {
    final prefs = await _prefs;
    return prefs.getString('lastResetDate');
  }

// Daily Stats: ["2025-03-27:4", "2025-03-26:2"]
  static Future<List<String>> getDailyStats() async {
    final prefs = await _prefs;
    return prefs.getStringList('dailyStats') ?? [];
  }

  static Future<void> addDailyStat(String date, int count) async {
    final prefs = await _prefs;
    final stats = prefs.getStringList('dailyStats') ?? [];
    stats.add("$date:$count");
    await prefs.setStringList('dailyStats', stats);
  }

  static Future<void> updateTodayStat() async {
    final prefs = await _prefs;
    final stats = prefs.getStringList('dailyStats') ?? [];

    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final existingIndex = stats.indexWhere((s) => s.startsWith(today));

    if (existingIndex >= 0) {
      final parts = stats[existingIndex].split(':');
      final count = int.tryParse(parts[1]) ?? 0;
      stats[existingIndex] = "$today:${count + 1}";
    } else {
      stats.add("$today:1");
    }

    await prefs.setStringList('dailyStats', stats);
  }

  static Future<int> getTodayCount() async {
    final stats = await getDailyStats();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final todayEntry = stats.firstWhere(
      (e) => e.startsWith(today),
      orElse: () => '$today:0',
    );
    return int.tryParse(todayEntry.split(':')[1]) ?? 0;
  }

  static Future<void> setTargetReachedToday(bool value) async {
    final prefs = await _prefs;
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    await prefs.setBool('targetReached_$today', value);
  }

  static Future<bool> getTargetReachedToday() async {
    final prefs = await _prefs;
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return prefs.getBool('targetReached_$today') ?? false;
  }
}
