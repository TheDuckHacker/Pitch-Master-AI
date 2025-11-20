import 'package:flutter/material.dart';
import '../models/transcription_segment.dart';

class TranscriptionViewer extends StatelessWidget {
  final String transcription;
  final List<TranscriptionSegment> segments;

  const TranscriptionViewer({
    super.key,
    required this.transcription,
    required this.segments,
  });

  @override
  Widget build(BuildContext context) {
    if (segments.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: SelectableText(
          transcription,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: segments.map((segment) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tiempo
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _formatTime(segment.startTime),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                          fontFamily: 'monospace',
                        ),
                  ),
                ),
                const SizedBox(width: 8),
                // Texto con etiquetas
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectableText(
                        segment.text,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      // Etiquetas
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          if (segment.speed != null)
                            _Tag(
                              icon: Icons.speed,
                              label: '${segment.speed!.toStringAsFixed(0)} wpm',
                              color: Colors.blue,
                            ),
                          if (segment.volume != null)
                            _Tag(
                              icon: Icons.volume_up,
                              label: '${(segment.volume! * 100).toStringAsFixed(0)}%',
                              color: Colors.orange,
                            ),
                          if (segment.hasPause)
                            _Tag(
                              icon: Icons.pause,
                              label: 'Pausa',
                              color: Colors.green,
                            ),
                          if (segment.emphasis != null)
                            _Tag(
                              icon: Icons.record_voice_over,
                              label: 'Énfasis: ${segment.emphasis}',
                              color: Colors.purple,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  String _formatTime(int milliseconds) {
    final duration = Duration(milliseconds: milliseconds);
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

class _Tag extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _Tag({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

