import 'dart:convert';
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
}
