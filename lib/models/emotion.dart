enum Emotion {
  happy,
  calm,
  confident,
  anxious,
  neutral,
  energetic,
  insecure,
  robotic;

  String get name {
    switch (this) {
      case Emotion.happy:
        return 'Feliz';
      case Emotion.calm:
        return 'Tranquilo';
      case Emotion.confident:
        return 'Confiable';
      case Emotion.anxious:
        return 'Ansioso';
      case Emotion.neutral:
        return 'Neutro';
      case Emotion.energetic:
        return 'Enérgico';
      case Emotion.insecure:
        return 'Inseguro';
      case Emotion.robotic:
        return 'Robótico';
    }
  }

  static Emotion fromString(String value) {
    return Emotion.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => Emotion.neutral,
    );
  }
}

