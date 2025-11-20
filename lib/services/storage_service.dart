import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_progress.dart';
import '../models/audio_analysis.dart';

class StorageService {
  static const String _progressKey = 'user_progress';
  static const String _analysesKey = 'audio_analyses';
  static const String _themeKey = 'is_dark_theme';
  static const String _showHistoryKey = 'show_history';
  static const String _showComparisonsKey = 'show_comparisons';

  Future<void> saveUserProgress(UserProgress progress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_progressKey, jsonEncode(progress.toJson()));
  }

  Future<UserProgress> getUserProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_progressKey);
    if (jsonString != null) {
      return UserProgress.fromJson(jsonDecode(jsonString));
    }
    return UserProgress();
  }

  Future<void> saveAnalysis(AudioAnalysis analysis) async {
    final prefs = await SharedPreferences.getInstance();
    final analyses = await getAnalyses();
    analyses.add(analysis);
    // Mantener solo los últimos 50 análisis
    if (analyses.length > 50) {
      analyses.removeAt(0);
    }
    final jsonList = analyses.map((a) => a.toJson()).toList();
    await prefs.setString(_analysesKey, jsonEncode(jsonList));
  }

  Future<List<AudioAnalysis>> getAnalyses() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_analysesKey);
    if (jsonString != null) {
      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList.map((json) => AudioAnalysis.fromJson(json)).toList();
    }
    return [];
  }

  Future<void> deleteAnalysis(String analysisId) async {
    final prefs = await SharedPreferences.getInstance();
    final analyses = await getAnalyses();
    analyses.removeWhere((a) => a.id == analysisId);
    final jsonList = analyses.map((a) => a.toJson()).toList();
    await prefs.setString(_analysesKey, jsonEncode(jsonList));
  }

  Future<void> clearAllAnalyses() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_analysesKey);
  }

  Future<bool> getIsDarkTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? false;
  }

  Future<void> setIsDarkTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDark);
  }

  Future<bool> getShowHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_showHistoryKey) ?? true;
  }

  Future<void> setShowHistory(bool show) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_showHistoryKey, show);
  }

  Future<bool> getShowComparisons() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_showComparisonsKey) ?? true;
  }

  Future<void> setShowComparisons(bool show) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_showComparisonsKey, show);
  }

  Future<void> resetAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

