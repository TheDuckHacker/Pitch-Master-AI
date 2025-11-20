import 'audio_analysis.dart';

enum Level {
  beginner, // Nivel 1: Pitch básico
  clear, // Nivel 2: Explicación clara
  storytelling, // Nivel 3: Storytelling
  professional, // Nivel 4: Pitch profesional
  expert, // Nivel 5: Speaker de alto impacto
}

class UserProgress {
  final Level currentLevel;
  final int totalAnalyses;
  final double averageScore;
  final int streakDays;
  final List<Achievement> achievements;
  final List<String> audioHistory; // IDs de análisis previos

  UserProgress({
    this.currentLevel = Level.beginner,
    this.totalAnalyses = 0,
    this.averageScore = 0.0,
    this.streakDays = 0,
    List<Achievement>? achievements,
    List<String>? audioHistory,
  }) : achievements = achievements ?? [],
       audioHistory = audioHistory ?? [];

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      currentLevel: Level.values.firstWhere(
        (l) => l.index == (json['current_level'] ?? 0),
        orElse: () => Level.beginner,
      ),
      totalAnalyses: json['total_analyses'] ?? 0,
      averageScore: (json['average_score'] ?? 0.0).toDouble(),
      streakDays: json['streak_days'] ?? 0,
      achievements:
          (json['achievements'] as List<dynamic>?)
              ?.map((a) => Achievement.fromJson(a))
              .toList() ??
          [],
      audioHistory:
          (json['audio_history'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_level': currentLevel.index,
      'total_analyses': totalAnalyses,
      'average_score': averageScore,
      'streak_days': streakDays,
      'achievements': achievements.map((a) => a.toJson()).toList(),
      'audio_history': audioHistory,
    };
  }

  String get levelName {
    switch (currentLevel) {
      case Level.beginner:
        return 'Pitch básico';
      case Level.clear:
        return 'Explicación clara';
      case Level.storytelling:
        return 'Storytelling';
      case Level.professional:
        return 'Pitch profesional';
      case Level.expert:
        return 'Speaker de alto impacto';
    }
  }

  double get progressToNextLevel {
    // Progreso basado en el score promedio
    final levelThresholds = [0, 40, 60, 75, 85, 100];
    final currentThreshold = levelThresholds[currentLevel.index];
    final nextThreshold = levelThresholds[currentLevel.index + 1];
    if (currentLevel == Level.expert) return 1.0;

    final progress =
        (averageScore - currentThreshold) / (nextThreshold - currentThreshold);
    return progress.clamp(0.0, 1.0);
  }

  UserProgress updateWithNewAnalysis(AudioAnalysis analysis) {
    final newTotal = totalAnalyses + 1;
    final newAverage =
        ((averageScore * totalAnalyses) + analysis.overallScore) / newTotal;

    Level newLevel = currentLevel;
    if (newAverage >= 85 && currentLevel != Level.expert) {
      newLevel = Level.expert;
    } else if (newAverage >= 75 &&
        currentLevel.index < Level.professional.index) {
      newLevel = Level.professional;
    } else if (newAverage >= 60 &&
        currentLevel.index < Level.storytelling.index) {
      newLevel = Level.storytelling;
    } else if (newAverage >= 40 && currentLevel.index < Level.clear.index) {
      newLevel = Level.clear;
    }

    final newHistory = [...audioHistory, analysis.id];
    if (newHistory.length > 50) {
      newHistory.removeAt(0); // Mantener solo los últimos 50
    }

    return UserProgress(
      currentLevel: newLevel,
      totalAnalyses: newTotal,
      averageScore: newAverage,
      streakDays: streakDays, // TODO: Implementar lógica de racha
      achievements: achievements,
      audioHistory: newHistory,
    );
  }
}

class Achievement {
  final String id;
  final String name;
  final String description;
  final String icon;
  final DateTime unlockedAt;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.unlockedAt,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '',
      unlockedAt: json['unlocked_at'] != null
          ? DateTime.parse(json['unlocked_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'unlocked_at': unlockedAt.toIso8601String(),
    };
  }
}
