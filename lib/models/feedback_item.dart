class FeedbackItem {
  final String id;
  final String message;
  final String category;
  final int startTime; // en segundos
  final int endTime; // en segundos
  final String severity; // 'low', 'medium', 'high'
  final String? suggestion;
  final double? score; // 0-100

  FeedbackItem({
    required this.id,
    required this.message,
    required this.category,
    required this.startTime,
    required this.endTime,
    this.severity = 'medium',
    this.suggestion,
    this.score,
  });

  factory FeedbackItem.fromJson(Map<String, dynamic> json) {
    return FeedbackItem(
      id: json['id'] ?? '',
      message: json['message'] ?? '',
      category: json['category'] ?? '',
      startTime: json['start_time'] ?? 0,
      endTime: json['end_time'] ?? 0,
      severity: json['severity'] ?? 'medium',
      suggestion: json['suggestion'],
      score: json['score']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'category': category,
      'start_time': startTime,
      'end_time': endTime,
      'severity': severity,
      'suggestion': suggestion,
      'score': score,
    };
  }
}

