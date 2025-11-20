import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/audio_analysis.dart';

class ScoreChart extends StatelessWidget {
  final AnalysisScores scores;

  const ScoreChart({
    super.key,
    required this.scores,
  });

  @override
  Widget build(BuildContext context) {
    final scoreData = [
      _ScoreData('Claridad', scores.clarity),
      _ScoreData('Flujo', scores.flow),
      _ScoreData('Contexto', scores.context),
      _ScoreData('Tecnicismos', scores.technicality),
      _ScoreData('Longitud', scores.sentenceLength),
      _ScoreData('Muletillas', scores.fillers),
      _ScoreData('Tono', scores.emotionalTone),
      _ScoreData('Pausas', scores.pauses),
    ];

    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 100,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (group) => Theme.of(context).colorScheme.surface,
              tooltipRoundedRadius: 8,
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() < scoreData.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        scoreData[value.toInt()].label,
                        style: const TextStyle(
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return const Text('');
                },
                reservedSize: 40,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}%',
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.2),
                strokeWidth: 1,
              );
            },
          ),
          borderData: FlBorderData(show: false),
          barGroups: scoreData.asMap().entries.map((entry) {
            final index = entry.key;
            final data = entry.value;
            final color = _getScoreColor(data.score);

            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: data.score,
                  color: color,
                  width: 20,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }
}

class _ScoreData {
  final String label;
  final double score;

  _ScoreData(this.label, this.score);
}

