import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../data/services/stats_service.dart';
import '../../data/services/storage_service.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/gradient_scaffold.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = StorageService();
    final stats = StatsService(storage).compute();

    if (stats.isEmpty) {
      return GradientScaffold(
        appBar: AppBar(title: const Text('Statistiques')),
        body: const Center(child: Text('Aucune partie terminée.')),
      );
    }

    // Séries
    final labels = stats.map((s) => s.player.name).toList();
    final bonusValues = stats
        .map((s) => s.bonusRate.clamp(0, 100).toDouble())
        .toList(); // << fix
    final yahtzeeValues = stats
        .map((s) => s.yahtzeeRate.clamp(0, 100).toDouble())
        .toList(); // << fix

    return GradientScaffold(
      appBar: AppBar(title: const Text('Statistiques')),
      overrideGradientTopColor: const Color(0xFFF8FAFE),
      overrideGradientBottomColor: const Color(0xFFE9F0FA),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // Tableau classement
          Card(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Joueur')),
                  DataColumn(label: Text('Parties')),
                  DataColumn(label: Text('Moyenne')),
                  DataColumn(label: Text('Max')),
                  DataColumn(label: Text('Min')),
                  DataColumn(label: Text('Total')),
                  DataColumn(label: Text('Bonus %')),
                  DataColumn(label: Text('Yams %')),
                ],
                rows: stats
                    .map(
                      (s) => DataRow(
                        cells: [
                          DataCell(Text(s.player.name)),
                          DataCell(Text('${s.games}')),
                          DataCell(Text(s.average.toStringAsFixed(1))),
                          DataCell(Text('${s.maxScore}')),
                          DataCell(Text('${s.minScore}')),
                          DataCell(Text('${s.total}')),
                          DataCell(Text('${s.bonusRate.toStringAsFixed(0)}%')),
                          DataCell(
                            Text('${s.yahtzeeRate.toStringAsFixed(0)}%'),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),

          _sectionTitle('Taux de bonus (≥ 63)'),
          _BarChartPercent(values: bonusValues, labels: labels, maxY: 100),
          const SizedBox(height: 16),

          _sectionTitle('Taux de Yams'),
          _BarChartPercent(values: yahtzeeValues, labels: labels, maxY: 100),
        ],
      ),
    );
  }

  Widget _sectionTitle(String t) => Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 8),
    child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold)),
  );
}

/// Bar chart 0–100% avec labels lisibles et sans doublons
class _BarChartPercent extends StatelessWidget {
  final List<double> values;
  final List<String> labels;
  final double maxY;

  const _BarChartPercent({
    required this.values,
    required this.labels,
    this.maxY = 100,
  });

  @override
  Widget build(BuildContext context) {
    final groups = <BarChartGroupData>[
      for (int i = 0; i < values.length; i++)
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: values[i],
              width: 18,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
          ],
        ),
    ];

    return SizedBox(
      height: 260,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 16, 8),
          child: BarChart(
            BarChartData(
              maxY: maxY,
              minY: 0,
              barGroups: groups,
              alignment: BarChartAlignment.spaceAround,
              gridData: FlGridData(
                show: true,
                drawHorizontalLine: true,
                drawVerticalLine: false,
                horizontalInterval: 20,
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 32,
                    interval: 20,
                    getTitlesWidget: (v, meta) => Text(
                      v.toInt().toString(),
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    reservedSize: 40,
                    getTitlesWidget: (v, meta) {
                      final i = v.toInt();
                      if (i < 0 || i >= labels.length)
                        return const SizedBox.shrink();
                      final text = _shorten(labels[i], 12);
                      return Transform.rotate(
                        angle: -35 * math.pi / 180,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            text,
                            style: const TextStyle(fontSize: 11),
                            overflow: TextOverflow.visible,
                            softWrap: false,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static String _shorten(String s, int max) {
    if (s.length <= max) return s;
    return s.substring(0, max - 1) + '…';
  }
}