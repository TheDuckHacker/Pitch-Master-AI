class TranscriptionSegment {
  final String text;
  final int startTime; // en milisegundos
  final int endTime; // en milisegundos
  final double? speed; // palabras por minuto
  final double? volume; // 0-1
  final double? pitch; // frecuencia fundamental
  final bool hasPause;
  final String? emphasis; // 'low', 'normal', 'high'

  TranscriptionSegment({
    required this.text,
    required this.startTime,
    required this.endTime,
    this.speed,
    this.volume,
    this.pitch,
    this.hasPause = false,
    this.emphasis,
  });

  factory TranscriptionSegment.fromJson(Map<String, dynamic> json) {
    return TranscriptionSegment(
      text: json['text'] ?? '',
      startTime: json['start_time'] ?? 0,
      endTime: json['end_time'] ?? 0,
      speed: json['speed']?.toDouble(),
      volume: json['volume']?.toDouble(),
      pitch: json['pitch']?.toDouble(),
      hasPause: json['has_pause'] ?? false,
      emphasis: json['emphasis'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'start_time': startTime,
      'end_time': endTime,
      'speed': speed,
      'volume': volume,
      'pitch': pitch,
      'has_pause': hasPause,
      'emphasis': emphasis,
    };
  }
}
