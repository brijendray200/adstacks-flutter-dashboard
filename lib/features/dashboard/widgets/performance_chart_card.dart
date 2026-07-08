import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_colors.dart';
import '../providers/dashboard_providers.dart';
import 'common.dart';
import 'edit_dialogs.dart';

class PerformanceChartCard extends ConsumerWidget {
  const PerformanceChartCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(dashboardProvider.select((s) => s.performance));

    final double minX = data.isNotEmpty
        ? data.first.year.toDouble()
        : 2015;
    final double maxX = data.isNotEmpty
        ? data.last.year.toDouble()
        : 2020;
    final double maxY = data.fold<double>(
      80,
      (prev, d) {
        final localMax = d.pending > d.done ? d.pending : d.done;
        return localMax > prev ? localMax + 10 : prev;
      },
    );

    return DashboardCard(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Over All Performance',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'The Years',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () async {
                  final result = await showAddPerformanceDialog(
                    context: context,
                  );
                  if (result != null) {
                    ref
                        .read(dashboardProvider.notifier)
                        .addPerformanceData(result);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.indigoSoft.withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.add_rounded,
                    color: AppColors.indigoSoft,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Legend(color: Color(0xFFE98C99), label: 'Pending\nDone'),
                  SizedBox(width: 16),
                  _Legend(color: AppColors.indigo, label: 'Project Done'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 270,
            child: data.isEmpty
                ? const Center(
                    child: Text(
                      'No data yet. Tap + to add.',
                      style: TextStyle(color: AppColors.muted),
                    ),
                  )
                : LineChart(
                    LineChartData(
                      minX: minX,
                      maxX: maxX,
                      minY: 0,
                      maxY: maxY,
                      gridData: FlGridData(
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (value) =>
                            FlLine(color: AppColors.line, strokeWidth: 1),
                      ),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 34,
                            interval: 20,
                            getTitlesWidget: (value, meta) => Text(
                              value.toInt().toString(),
                              style: const TextStyle(
                                color: AppColors.muted,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            reservedSize: 30,
                            getTitlesWidget: (value, meta) => Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                value.toInt().toString(),
                                style: const TextStyle(
                                  color: AppColors.muted,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      lineTouchData: LineTouchData(
                        enabled: true,
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipColor: (_) => AppColors.night,
                          getTooltipItems: (spots) => spots.map((spot) {
                            final label =
                                spot.barIndex == 0 ? 'Pending' : 'Project';
                            return LineTooltipItem(
                              '${spot.x.toInt()}\n$label: ${spot.y.toStringAsFixed(0)}',
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: data
                              .map(
                                (point) => FlSpot(
                                  point.year.toDouble(),
                                  point.pending,
                                ),
                              )
                              .toList(),
                          color: const Color(0xFFE98C99),
                          barWidth: 4,
                          isCurved: true,
                          dotData: const FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            color: const Color(0xFFE98C99)
                                .withValues(alpha: .08),
                          ),
                        ),
                        LineChartBarData(
                          spots: data
                              .map(
                                (point) => FlSpot(
                                  point.year.toDouble(),
                                  point.done,
                                ),
                              )
                              .toList(),
                          color: AppColors.indigo,
                          barWidth: 4,
                          isCurved: true,
                          dotData: const FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            color: AppColors.indigo.withValues(alpha: .08),
                          ),
                        ),
                      ],
                    ),
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  ),
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 7),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.muted,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
