import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/analytics_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/constants/app_constants.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  int _selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(analyticsProvider.notifier).load();
    });
  }

  Future<void> _onRefresh() async {
    await ref.read(analyticsProvider.notifier).load(year: _selectedYear);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(analyticsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        actions: [
          _buildYearSelector(theme),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : state.error != null
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.error_outline,
                            size: 48, color: theme.colorScheme.error),
                        const SizedBox(height: 16),
                        Text('Error: ${state.error}'),
                      ],
                    ),
                  )
                : _buildContent(context, state, theme),
      ),
    );
  }

  Widget _buildYearSelector(ThemeData theme) {
    return PopupMenuButton<int>(
      icon: Text(
        '$_selectedYear',
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      onSelected: (year) {
        setState(() => _selectedYear = year);
        ref.read(analyticsProvider.notifier).changeYear(year);
      },
      itemBuilder: (_) {
        final currentYear = DateTime.now().year;
        return List.generate(5, (i) => currentYear - i).map((y) {
          return PopupMenuItem(
            value: y,
            child: Text(
              '$y',
              style: TextStyle(
                fontWeight: y == _selectedYear ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        }).toList();
      },
    );
  }

  Widget _buildContent(
      BuildContext context, AnalyticsState state, ThemeData theme) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary cards
          _buildSummaryCards(context, state, theme),
          const SizedBox(height: 24),

          // This Month section: Expense Breakdown Pie Chart
          if (state.categoryTotals.isNotEmpty) ...[
            Text(
              'Expense Breakdown',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildPieChart(context, state, theme),
            const SizedBox(height: 8),
            _buildCategoryLegend(state, theme),
            const SizedBox(height: 24),
          ],

          // Monthly Spending Trend bar chart
          if (state.monthlySpendingTrend.isNotEmpty) ...[
            Text(
              'Monthly Spending Trend',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 220,
              child: _buildSpendingBarChart(state, theme),
            ),
            const SizedBox(height: 24),
          ],

          // Income vs Expenses bar chart
          if (state.incomeVsExpenses.isNotEmpty) ...[
            Text(
              'Income vs Expenses',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 220,
              child: _buildIncomeVsExpensesChart(state, theme),
            ),
            const SizedBox(height: 24),
          ],

          // Savings Growth line chart
          if (state.savingsTrend.isNotEmpty) ...[
            Text(
              'Savings Growth',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 220,
              child: _buildSavingsLineChart(state, theme),
            ),
            const SizedBox(height: 24),
          ],

          // Category breakdown list
          if (state.categoryTotals.isNotEmpty) ...[
            Text(
              'Category Breakdown',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...state.categoryTotals.map((cat) => _buildCategoryRow(cat, state, theme)),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryCards(
      BuildContext context, AnalyticsState state, ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: _summaryCard(
            'Total Income',
            NumberFormatter.formatCurrency(state.totalIncome),
            Colors.green,
            Icons.trending_down,
            theme,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _summaryCard(
            'Total Expenses',
            NumberFormatter.formatCurrency(state.totalExpenses),
            Colors.red,
            Icons.trending_up,
            theme,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _summaryCard(
            'Net Savings',
            NumberFormatter.formatCurrency(state.netSavings),
            state.netSavings >= 0 ? Colors.blue : Colors.orange,
            Icons.savings,
            theme,
          ),
        ),
      ],
    );
  }

  Widget _summaryCard(
      String label, String value, Color color, IconData icon, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── PIE CHART ──────────────────────────────────────────────

  Widget _buildPieChart(
      BuildContext context, AnalyticsState state, ThemeData theme) {
    final total = state.categoryTotals.fold<double>(0, (s, c) => s + c.value);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 200,
          child: Row(
            children: [
              Expanded(
                child: PieChart(
                  PieChartData(
                    sections: state.categoryTotals.map((cat) {
                      final percentage =
                          total > 0 ? (cat.value / total) * 100 : 0;
                      final color = AppTheme.categoryColors[cat.label] ??
                          Colors.grey;
                      return PieChartSectionData(
                        value: percentage.toDouble(),
                        title: '${percentage.toStringAsFixed(0)}%',
                        color: color,
                        radius: 50,
                        titleStyle: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    }).toList(),
                    sectionsSpace: 2,
                    centerSpaceRadius: 30,
                    startDegreeOffset: -90,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryLegend(AnalyticsState state, ThemeData theme) {
    return Wrap(
      spacing: 12,
      runSpacing: 4,
      children: state.categoryTotals.map((cat) {
        final color =
            AppTheme.categoryColors[cat.label] ?? Colors.grey;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(cat.label, style: const TextStyle(fontSize: 12)),
          ],
        );
      }).toList(),
    );
  }

  // ─── SPENDING BAR CHART ─────────────────────────────────────

  Widget _buildSpendingBarChart(AnalyticsState state, ThemeData theme) {
    final maxValue = state.monthlySpendingTrend
        .fold<double>(0, (max, d) => d.value > max ? d.value : max);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: maxValue * 1.2,
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    '${state.monthlySpendingTrend[groupIndex].label}\n₹${rod.toY.toStringAsFixed(0)}',
                    const TextStyle(color: Colors.white, fontSize: 12),
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index >= 0 && index < state.monthlySpendingTrend.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          state.monthlySpendingTrend[index].label,
                          style: const TextStyle(fontSize: 9),
                        ),
                      );
                    }
                    return const Text('');
                  },
                  reservedSize: 22,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      '₹${value.toInt()}',
                      style: const TextStyle(fontSize: 9),
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
            borderData: FlBorderData(show: false),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: maxValue > 0 ? maxValue / 4 : 1,
            ),
            barGroups: state.monthlySpendingTrend.asMap().entries.map((entry) {
              return BarChartGroupData(
                x: entry.key,
                barRods: [
                  BarChartRodData(
                    toY: entry.value.value,
                    color: theme.colorScheme.primary,
                    width: 14,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  // ─── INCOME VS EXPENSES CHART ──────────────────────────────

  Widget _buildIncomeVsExpensesChart(AnalyticsState state, ThemeData theme) {
    final incomeData = <ChartDataPoint>[];
    final expenseData = <ChartDataPoint>[];
    final monthLabels = <String>[];

    for (int i = 0; i < state.incomeVsExpenses.length; i += 2) {
      if (i + 1 < state.incomeVsExpenses.length) {
        incomeData.add(state.incomeVsExpenses[i]);
        expenseData.add(state.incomeVsExpenses[i + 1]);
        final label = state.incomeVsExpenses[i].label.replaceAll(' Income', '');
        monthLabels.add(label);
      }
    }

    final allValues = [
      ...incomeData.map((d) => d.value),
      ...expenseData.map((d) => d.value),
    ];
    final maxValue = allValues.fold<double>(0, (max, v) => v > max ? v : max);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: maxValue * 1.2,
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  final label = monthLabels.length > groupIndex
                      ? monthLabels[groupIndex]
                      : '';
                  final type = rodIndex == 0 ? 'Income' : 'Expense';
                  return BarTooltipItem(
                    '$label $type\n₹${rod.toY.toStringAsFixed(0)}',
                    const TextStyle(color: Colors.white, fontSize: 12),
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index >= 0 && index < monthLabels.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          monthLabels[index],
                          style: const TextStyle(fontSize: 9),
                        ),
                      );
                    }
                    return const Text('');
                  },
                  reservedSize: 22,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      '₹${value.toInt()}',
                      style: const TextStyle(fontSize: 9),
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
            borderData: FlBorderData(show: false),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
            ),
            barGroups:
                List.generate(monthLabels.length, (index) {
              final income = index < incomeData.length ? incomeData[index].value : 0.0;
              final expense = index < expenseData.length ? expenseData[index].value : 0.0;
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: income,
                    color: Colors.green,
                    width: 8,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(3),
                      topRight: Radius.circular(3),
                    ),
                  ),
                  BarChartRodData(
                    toY: expense,
                    color: Colors.red,
                    width: 8,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(3),
                      topRight: Radius.circular(3),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  // ─── SAVINGS LINE CHART ────────────────────────────────────

  Widget _buildSavingsLineChart(AnalyticsState state, ThemeData theme) {
    final savings = state.savingsTrend;
    final maxValue =
        savings.fold<double>(0, (max, d) => d.value > max ? d.value : max);
    final minValue =
        savings.fold<double>(0, (min, d) => d.value < min ? d.value : min);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
        child: LineChart(
          LineChartData(
            minY: minValue < 0 ? minValue * 1.2 : 0,
            maxY: maxValue > 0 ? maxValue * 1.2 : 100,
            lineTouchData: LineTouchData(
              enabled: true,
              touchTooltipData: LineTouchTooltipData(
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((spot) {
                    final index = spot.x.toInt();
                    final label =
                        index >= 0 && index < savings.length
                            ? savings[index].label
                            : '';
                    return LineTooltipItem(
                      '$label\n₹${spot.y.toStringAsFixed(0)}',
                      const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }).toList();
                },
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index >= 0 && index < savings.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          savings[index].label,
                          style: const TextStyle(fontSize: 9),
                        ),
                      );
                    }
                    return const Text('');
                  },
                  reservedSize: 22,
                  interval: 1,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      '₹${value.toInt()}',
                      style: const TextStyle(fontSize: 9),
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
            borderData: FlBorderData(show: false),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
            ),
            lineBarsData: [
              LineChartBarData(
                spots: savings.asMap().entries.map((entry) {
                  return FlSpot(entry.key.toDouble(), entry.value.value);
                }).toList(),
                isCurved: true,
                color: theme.colorScheme.secondary,
                barWidth: 3,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 3,
                      color: theme.colorScheme.secondary,
                      strokeWidth: 2,
                      strokeColor: Colors.white,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  color: theme.colorScheme.secondary.withOpacity(0.1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── CATEGORY ROW ──────────────────────────────────────────

  Widget _buildCategoryRow(
      ChartDataPoint cat, AnalyticsState state, ThemeData theme) {
    final total = state.categoryTotals.fold<double>(0, (s, c) => s + c.value);
    final percentage = total > 0 ? (cat.value / total) * 100 : 0.0;
    final color = AppTheme.categoryColors[cat.label] ?? Colors.grey;
    final icon = AppTheme.categoryIcons[cat.label] ?? Icons.help_outline;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color, size: 20),
          ),
          title: Text(cat.label),
          subtitle: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: color.withOpacity(0.1),
              color: color,
              minHeight: 6,
            ),
          ),
          trailing: Text(
            '${NumberFormatter.formatCurrency(cat.value)} (${percentage.toStringAsFixed(1)}%)',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
