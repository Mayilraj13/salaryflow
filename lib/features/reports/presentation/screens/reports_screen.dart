import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../analytics/presentation/providers/analytics_provider.dart';
import '../../../dashboard/presentation/providers/dashboard_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/constants/app_constants.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(analyticsProvider.notifier).load(year: _selectedYear);
    });
  }

  @override
  Widget build(BuildContext context) {
    final analyticsState = ref.watch(analyticsProvider);
    final dashboardState = ref.watch(dashboardProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        actions: [
          // Month/Year selector
          _buildMonthYearButton(theme),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Period heading
            Text(
              '${_monthName(_selectedMonth)} $_selectedYear',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Monthly Financial Summary',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
            const SizedBox(height: 20),

            // Summary cards
            _buildSummaryGrid(context, analyticsState, dashboardState, theme),
            const SizedBox(height: 24),

            // Generate buttons
            Text(
              'Generate Reports',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildReportButton(
                    icon: Icons.picture_as_pdf,
                    label: AppStrings.generatePDF,
                    color: Colors.red,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('PDF generation coming soon...'),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildReportButton(
                    icon: Icons.table_chart,
                    label: AppStrings.generateExcel,
                    color: Colors.green,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Excel generation coming soon...'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Additional details
            if (analyticsState.categoryTotals.isNotEmpty) ...[
              Text(
                'Expense Categories',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...analyticsState.categoryTotals.map((cat) {
                final color =
                    AppTheme.categoryColors[cat.label] ?? Colors.grey;
                final total = analyticsState.categoryTotals
                    .fold<double>(0, (s, c) => s + c.value);
                final percentage =
                    total > 0 ? (cat.value / total) * 100 : 0.0;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(cat.label),
                      ),
                      Text(
                        '${NumberFormatter.formatCurrency(cat.value)} (${percentage.toStringAsFixed(1)}%)',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMonthYearButton(ThemeData theme) {
    return TextButton(
      onPressed: () => _showMonthYearPicker(),
      child: Text(
        '${_monthName(_selectedMonth)} $_selectedYear',
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSummaryGrid(
    BuildContext context,
    dynamic analyticsState,
    dynamic dashboardState,
    ThemeData theme,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _summaryCard(
                title: 'Total Income',
                value: NumberFormatter.formatCurrency(
                    analyticsState.totalIncome),
                color: Colors.green,
                icon: Icons.arrow_downward,
                theme: theme,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _summaryCard(
                title: 'Total Expenses',
                value: NumberFormatter.formatCurrency(
                    analyticsState.totalExpenses),
                color: Colors.red,
                icon: Icons.arrow_upward,
                theme: theme,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _summaryCard(
                title: 'Net Savings',
                value: NumberFormatter.formatCurrency(
                    analyticsState.netSavings),
                color: analyticsState.netSavings >= 0
                    ? Colors.blue
                    : Colors.orange,
                icon: Icons.savings,
                theme: theme,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _summaryCard(
                title: 'Rent Paid',
                value: dashboardState.rentStatus == RentStatus.paid
                    ? 'Yes'
                    : dashboardState.rentStatus == RentStatus.overdue
                        ? 'Overdue'
                        : 'Pending',
                color: dashboardState.rentStatus == RentStatus.paid
                    ? Colors.green
                    : dashboardState.rentStatus == RentStatus.overdue
                        ? Colors.red
                        : Colors.orange,
                icon: Icons.home,
                theme: theme,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _summaryCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
    required ThemeData theme,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    color: theme.colorScheme.outline,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Icon(icon, size: 36, color: color),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _monthName(int month) {
    const names = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return names[month - 1];
  }

  void _showMonthYearPicker() {
    int tempMonth = _selectedMonth;
    int tempYear = _selectedYear;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          return AlertDialog(
            title: const Text('Select Month & Year'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Year row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () {
                        setDialogState(() => tempYear--);
                      },
                    ),
                    Text(
                      '$tempYear',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () {
                        setDialogState(() => tempYear++);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Month grid
                SizedBox(
                  width: 280,
                  child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 2.5,
                    ),
                    itemCount: 12,
                    itemBuilder: (_, i) {
                      final month = i + 1;
                      final isSelected =
                          month == tempMonth && tempYear == _selectedYear;
                      return GestureDetector(
                        onTap: () {
                          setDialogState(() => tempMonth = month);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : null,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey.shade300,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              _monthName(month).substring(0, 3),
                              style: TextStyle(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected ? Colors.white : null,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  setState(() {
                    _selectedMonth = tempMonth;
                    _selectedYear = tempYear;
                  });
                  ref
                      .read(analyticsProvider.notifier)
                      .changeYear(tempYear);
                  Navigator.pop(ctx);
                },
                child: const Text('Apply'),
              ),
            ],
          );
        },
      ),
    );
  }
}
