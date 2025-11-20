import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_provider.dart';
import '../widgets/transcription_viewer.dart';
import '../widgets/feedback_list.dart';
import '../widgets/score_chart.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        final analysis = appProvider.currentAnalysis;
        if (analysis == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Análisis')),
            body: const Center(child: Text('No hay análisis disponible')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Análisis de Pitch'),
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  // TODO: Implementar compartir
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Score general
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Text(
                          'Pitch Score',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '${analysis.overallScore.toStringAsFixed(1)}%',
                          style: Theme.of(context).textTheme.displayLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: _getScoreColor(analysis.overallScore),
                              ),
                        ),
                        const SizedBox(height: 16),
                        LinearProgressIndicator(
                          value: analysis.overallScore / 100,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getScoreColor(analysis.overallScore),
                          ),
                          minHeight: 8,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Emoción predominante
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(
                          _getEmotionIcon(analysis.predominantEmotion),
                          size: 48,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Emoción predominante',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Text(
                                analysis.predominantEmotion.name,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Gráfico de scores por dimensión
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Análisis detallado',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        ScoreChart(scores: analysis.scores),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Transcripción con etiquetas
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Transcripción',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        TranscriptionViewer(
                          transcription: analysis.transcription,
                          segments: analysis.segments,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Feedback
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Feedback y sugerencias',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        FeedbackList(feedbacks: analysis.feedbacks),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Botón para grabar nuevamente
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.mic),
                  label: const Text('Grabar nuevo pitch'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  IconData _getEmotionIcon(emotion) {
    switch (emotion.toString().split('.').last) {
      case 'happy':
        return Icons.sentiment_very_satisfied;
      case 'calm':
        return Icons.spa;
      case 'confident':
        return Icons.self_improvement;
      case 'anxious':
        return Icons.sentiment_very_dissatisfied;
      case 'energetic':
        return Icons.bolt;
      case 'insecure':
        return Icons.sentiment_dissatisfied;
      case 'robotic':
        return Icons.smart_toy;
      default:
        return Icons.sentiment_neutral;
    }
  }
}
