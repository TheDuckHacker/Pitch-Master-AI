import 'emotion.dart';
import 'transcription_segment.dart';
import 'feedback_item.dart';

class AudioAnalysis {
  final String id;
  final String audioUrl;
  final String transcription;
  final List<TranscriptionSegment> segments;
  final Emotion predominantEmotion;
  final Map<String, double> emotionDistribution;
  final List<FeedbackItem> feedbacks;
  final AnalysisScores scores;
  final DateTime createdAt;

  AudioAnalysis({
    required this.id,
    required this.audioUrl,
    required this.transcription,
    required this.segments,
    required this.predominantEmotion,
    required this.emotionDistribution,
    required this.feedbacks,
    required this.scores,
    required this.createdAt,
  });

  factory AudioAnalysis.fromJson(Map<String, dynamic> json) {
    return AudioAnalysis(
      id: json['id'] ?? '',
      audioUrl: json['audio_url'] ?? '',
      transcription: json['transcription'] ?? '',
      segments: (json['segments'] as List<dynamic>?)
              ?.map((s) => TranscriptionSegment.fromJson(s))
              .toList() ??
          [],
      predominantEmotion: Emotion.fromString(
        json['predominant_emotion'] ?? 'neutral',
      ),
      emotionDistribution: Map<String, double>.from(
        json['emotion_distribution'] ?? {},
      ),
      feedbacks: (json['feedbacks'] as List<dynamic>?)
              ?.map((f) => FeedbackItem.fromJson(f))
              .toList() ??
          [],
      scores: AnalysisScores.fromJson(
        json['scores'] ?? {},
      ),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'audio_url': audioUrl,
      'transcription': transcription,
      'segments': segments.map((s) => s.toJson()).toList(),
      'predominant_emotion': predominantEmotion.name,
      'emotion_distribution': emotionDistribution,
      'feedbacks': feedbacks.map((f) => f.toJson()).toList(),
      'scores': scores.toJson(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  double get overallScore => scores.overall;
}

class AnalysisScores {
  final double clarity; // Claridad del mensaje
  final double flow; // Flujo y estructura
  final double context; // Contexto suficiente
  final double technicality; // Uso adecuado de tecnicismos
  final double sentenceLength; // Extensión de frases
  final double fillers; // Muletillas
  final double emotionalTone; // Tono emocional
  final double pauses; // Pausas

  AnalysisScores({
    this.clarity = 0.0,
    this.flow = 0.0,
    this.context = 0.0,
    this.technicality = 0.0,
    this.sentenceLength = 0.0,
    this.fillers = 0.0,
    this.emotionalTone = 0.0,
    this.pauses = 0.0,
  });

  double get overall {
    return (clarity +
            flow +
            context +
            technicality +
            sentenceLength +
            fillers +
            emotionalTone +
            pauses) /
        8.0;
  }

  factory AnalysisScores.fromJson(Map<String, dynamic> json) {
    return AnalysisScores(
      clarity: (json['clarity'] ?? 0.0).toDouble(),
      flow: (json['flow'] ?? 0.0).toDouble(),
      context: (json['context'] ?? 0.0).toDouble(),
      technicality: (json['technicality'] ?? 0.0).toDouble(),
      sentenceLength: (json['sentence_length'] ?? 0.0).toDouble(),
      fillers: (json['fillers'] ?? 0.0).toDouble(),
      emotionalTone: (json['emotional_tone'] ?? 0.0).toDouble(),
      pauses: (json['pauses'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clarity': clarity,
      'flow': flow,
      'context': context,
      'technicality': technicality,
      'sentence_length': sentenceLength,
      'fillers': fillers,
      'emotional_tone': emotionalTone,
      'pauses': pauses,
    };
  }
}

