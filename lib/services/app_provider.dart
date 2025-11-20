import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../models/audio_analysis.dart';
import '../models/user_progress.dart';
import '../models/emotion.dart';
import 'audio_service.dart';
import 'api_service.dart';
import 'storage_service.dart';
import 'theme_service.dart';

class AppProvider extends ChangeNotifier {
  final AudioService _audioService = AudioService();
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  UserProgress _userProgress = UserProgress();
  List<AudioAnalysis> _analyses = [];
  AudioAnalysis? _currentAnalysis;
  Emotion _currentEmotion = Emotion.neutral;
  bool _isDarkTheme = false;
  bool _isAnalyzing = false;
  String? _errorMessage;

  // Getters
  UserProgress get userProgress => _userProgress;
  List<AudioAnalysis> get analyses => _analyses;
  AudioAnalysis? get currentAnalysis => _currentAnalysis;
  Emotion get currentEmotion => _currentEmotion;
  bool get isDarkTheme => _isDarkTheme;
  bool get isAnalyzing => _isAnalyzing;
  String? get errorMessage => _errorMessage;
  AudioService get audioService => _audioService;

  AppProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    await loadUserProgress();
    await loadAnalyses();
    await loadTheme();
  }

  Future<void> loadUserProgress() async {
    _userProgress = await _storageService.getUserProgress();
    notifyListeners();
  }

  Future<void> loadAnalyses() async {
    _analyses = await _storageService.getAnalyses();
    notifyListeners();
  }

  Future<void> loadTheme() async {
    _isDarkTheme = await _storageService.getIsDarkTheme();
    notifyListeners();
  }

  Future<void> analyzeAudio(String audioPath) async {
    _isAnalyzing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      dynamic file;
      if (kIsWeb) {
        // En Web, audioPath puede ser una blob URL o un path
        file = audioPath; // Se manejará en ApiService
      } else {
        file = File(audioPath);
      }
      final analysis = await _apiService.analyzeAudio(file);

      _currentAnalysis = analysis;
      _currentEmotion = analysis.predominantEmotion;

      // Guardar análisis
      await _storageService.saveAnalysis(analysis);
      _analyses = await _storageService.getAnalyses();

      // Actualizar progreso del usuario
      _userProgress = _userProgress.updateWithNewAnalysis(analysis);
      await _storageService.saveUserProgress(_userProgress);

      _isAnalyzing = false;
      notifyListeners();
    } catch (e) {
      _isAnalyzing = false;
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  void setCurrentAnalysis(AudioAnalysis? analysis) {
    _currentAnalysis = analysis;
    if (analysis != null) {
      _currentEmotion = analysis.predominantEmotion;
    }
    notifyListeners();
  }

  void setCurrentEmotion(Emotion emotion) {
    _currentEmotion = emotion;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkTheme = !_isDarkTheme;
    await _storageService.setIsDarkTheme(_isDarkTheme);
    notifyListeners();
  }

  Future<void> deleteAnalysis(String analysisId) async {
    await _storageService.deleteAnalysis(analysisId);
    _analyses = await _storageService.getAnalyses();
    if (_currentAnalysis?.id == analysisId) {
      _currentAnalysis = null;
    }
    notifyListeners();
  }

  Future<void> clearAllAnalyses() async {
    await _storageService.clearAllAnalyses();
    _analyses = [];
    _currentAnalysis = null;
    notifyListeners();
  }

  ThemeData getTheme() {
    return EmotionTheme.fromEmotion(_currentEmotion, _isDarkTheme)
        .toThemeData(_isDarkTheme);
  }

  Future<bool> getShowHistory() async {
    return await _storageService.getShowHistory();
  }

  Future<void> setShowHistory(bool show) async {
    await _storageService.setShowHistory(show);
    notifyListeners();
  }

  Future<bool> getShowComparisons() async {
    return await _storageService.getShowComparisons();
  }

  Future<void> setShowComparisons(bool show) async {
    await _storageService.setShowComparisons(show);
    notifyListeners();
  }

  Future<void> resetAll() async {
    await _storageService.resetAll();
    await _initialize();
    notifyListeners();
  }
}

