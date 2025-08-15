import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WaveformGraph extends StatelessWidget {
  final List<double> data;
  final double minY;
  final double maxY;
  final Color color;

  const WaveformGraph({
    super.key,
    required this.data,
    required this.minY,
    required this.maxY,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        minY: minY,
        maxY: maxY,
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        clipData: const FlClipData.all(), // Clamps the line to the chart area
        lineBarsData: [
          LineChartBarData(
            spots: data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
            isCurved: true,
            color: color,
            barWidth: 2, // Thinner line
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
      duration: const Duration(milliseconds: 0), // For smooth scrolling
    );
  }
}
