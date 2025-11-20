import 'package:flutter/material.dart';
import '../models/feedback_item.dart';
import 'package:intl/intl.dart';

class FeedbackList extends StatelessWidget {
  final List<FeedbackItem> feedbacks;

  const FeedbackList({
    super.key,
    required this.feedbacks,
  });

  @override
  Widget build(BuildContext context) {
    if (feedbacks.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 64,
                color: Colors.green[400],
              ),
              const SizedBox(height: 16),
              Text(
                '¡Excelente! No hay feedback específico',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: feedbacks.map((feedback) {
        return _FeedbackCard(feedback: feedback);
      }).toList(),
    );
  }
}

class _FeedbackCard extends StatelessWidget {
  final FeedbackItem feedback;

  const _FeedbackCard({
    required this.feedback,
  });

  @override
  Widget build(BuildContext context) {
    final severityColor = _getSeverityColor(feedback.severity);
    final severityIcon = _getSeverityIcon(feedback.severity);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: severityColor.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(severityIcon, color: severityColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  feedback.category,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: severityColor,
                      ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: severityColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${_formatTime(feedback.startTime)} - ${_formatTime(feedback.endTime)}',
                    style: TextStyle(
                      fontSize: 10,
                      color: severityColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              feedback.message,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (feedback.suggestion != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      size: 20,
                      color: Colors.amber[700],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        feedback.suggestion!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (feedback.score != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'Score: ',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '${feedback.score!.toStringAsFixed(1)}%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _getScoreColor(feedback.score!),
                        ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getSeverityIcon(String severity) {
    switch (severity.toLowerCase()) {
      case 'high':
        return Icons.warning;
      case 'medium':
        return Icons.info_outline;
      case 'low':
        return Icons.check_circle_outline;
      default:
        return Icons.help_outline;
    }
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  String _formatTime(int seconds) {
    final duration = Duration(seconds: seconds);
    final minutes = duration.inMinutes;
    final secs = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}

