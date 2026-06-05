import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../analytics/presentation/providers/analytics_provider.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../../../expenses/presentation/widgets/expense_card.dart';
import '../../../expenses/presentation/widgets/add_expense_dialog.dart';
import '../../../expenses/presentation/providers/expense_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/constants/app_constants.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final now = DateTime.now();
      ref.read(cycleReportProvider.notifier).changePeriod(now.month, now.year);
    });
  }

  @override
  Widget build(BuildContext context) {
    final reportState = ref.watch(cycleReportProvider);
    final settingsState = ref.watch(settingsProvider);
    final theme = Theme.of(context);

    if (reportState.isLoading || settingsState.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final selectedMonth = reportState.month;
    final selectedYear = reportState.year;
    final salaryDate = settingsState.salaryDate;

    // Calculate the start and end date of the cycle
    DateTime start;
    DateTime end;
    if (salaryDate <= 1) {
      start = DateTime(selectedYear, selectedMonth, 1);
      end = DateTime(selectedYear, selectedMonth + 1, 1).subtract(const Duration(days: 1));
    } else {
      start = DateTime(selectedYear, selectedMonth - 1, salaryDate);
      end = DateTime(selectedYear, selectedMonth, salaryDate).subtract(const Duration(days: 1));
    }
    final dateRangeText = '${DateFormatter.formatDate(start)} - ${DateFormatter.formatDate(end)}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        actions: [
          // Month/Year selector
          _buildMonthYearButton(theme, selectedMonth, selectedYear),
        ],
      ),
      body: reportState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Period heading
                  Text(
                    '${_monthName(selectedMonth)} $selectedYear',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Cycle: $dateRangeText',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Summary cards
                  _buildSummaryGrid(context, reportState, theme),
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
                  if (reportState.categoryTotals.isNotEmpty) ...[
                    Text(
                      'Expense Categories',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...reportState.categoryTotals.map((cat) {
                      final color =
                          AppTheme.categoryColors[cat.label] ?? Colors.grey;
                      final total = reportState.categoryTotals
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
                  const SizedBox(height: 24),
                  _buildCycleExpensesList(context, ref, reportState, theme),
                  const SizedBox(height: 24),
                  _buildPastCyclesHistory(context, ref, theme),
                ],
              ),
            ),
    );
  }

  Widget _buildCycleExpensesList(
    BuildContext context,
    WidgetRef ref,
    CycleReportState reportState,
    ThemeData theme,
  ) {
    if (reportState.expenses.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Expenses in this Period',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...reportState.expenses.map((expense) {
          return ExpenseCard(
            expense: expense,
            margin: const EdgeInsets.symmetric(vertical: 4),
            onEdit: () {
              showDialog(
                context: context,
                builder: (_) => AddExpenseDialog(expense: expense),
              );
            },
            onDelete: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Delete Expense'),
                  content: Text(
                    'Delete this expense of ${NumberFormatter.formatCurrency(expense.amount)}?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: Text(
                        'Delete',
                        style: TextStyle(color: theme.colorScheme.error),
                      ),
                    ),
                  ],
                ),
              );
              if (confirmed == true) {
                await ref
                    .read(expenseProvider.notifier)
                    .deleteExpense(expense.id);
              }
            },
          );
        }),
      ],
    );
  }

  Widget _buildPastCyclesHistory(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
  ) {
    final pastState = ref.watch(pastCyclesProvider);

    if (pastState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (pastState.cycles.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cycle History',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: pastState.cycles.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (ctx, index) {
              final cycle = pastState.cycles[index];
              final dateRange =
                  '${DateFormatter.formatDate(cycle.startDate)} - ${DateFormatter.formatDate(cycle.endDate)}';
              final isCurrent = cycle.month == ref.watch(cycleReportProvider).month &&
                  cycle.year == ref.watch(cycleReportProvider).year;

              return ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_monthName(cycle.month)} ${cycle.year}',
                      style: TextStyle(
                        fontWeight: isCurrent ? FontWeight.bold : FontWeight.w600,
                        color: isCurrent ? theme.colorScheme.primary : null,
                      ),
                    ),
                    Text(
                      NumberFormatter.formatCurrency(cycle.totalExpenses),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ],
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      dateRange,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                    Text(
                      'Savings: ${NumberFormatter.formatCurrency(cycle.netSavings)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cycle.netSavings >= 0
                            ? AppTheme.successColor
                            : AppTheme.warningColor,
                      ),
                    ),
                  ],
                ),
                trailing: const Icon(Icons.chevron_right, size: 20),
                onTap: () {
                  ref.read(cycleReportProvider.notifier).changePeriod(cycle.month, cycle.year);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMonthYearButton(ThemeData theme, int month, int year) {
    return TextButton(
      onPressed: () => _showMonthYearPicker(month, year),
      child: Text(
        '${_monthName(month)} $year',
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSummaryGrid(
    BuildContext context,
    CycleReportState reportState,
    ThemeData theme,
  ) {
    final rentRecord = reportState.rentRecord;
    final isRentPaid = rentRecord?.isPaid ?? false;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _summaryCard(
                title: 'Total Income',
                value: NumberFormatter.formatCurrency(reportState.totalIncome),
                color: Colors.green,
                icon: Icons.arrow_downward,
                theme: theme,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _summaryCard(
                title: 'Total Expenses',
                value: NumberFormatter.formatCurrency(reportState.totalExpenses),
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
                value: NumberFormatter.formatCurrency(reportState.netSavings),
                color: reportState.netSavings >= 0 ? Colors.blue : Colors.orange,
                icon: Icons.savings,
                theme: theme,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _summaryCard(
                title: 'Rent Paid',
                value: rentRecord == null
                    ? 'Pending'
                    : isRentPaid
                        ? 'Yes'
                        : DateTime.now().isAfter(rentRecord.dueDate)
                            ? 'Overdue'
                            : 'Pending',
                color: rentRecord == null
                    ? Colors.orange
                    : isRentPaid
                        ? Colors.green
                        : DateTime.now().isAfter(rentRecord.dueDate)
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
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return names[month - 1];
  }

  void _showMonthYearPicker(int currentMonth, int currentYear) {
    int tempMonth = currentMonth;
    int tempYear = currentYear;

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
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 2.5,
                    ),
                    itemCount: 12,
                    itemBuilder: (_, i) {
                      final month = i + 1;
                      final isSelected = month == tempMonth;
                      return GestureDetector(
                        onTap: () {
                          setDialogState(() => tempMonth = month);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected ? Theme.of(context).colorScheme.primary : null,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade300,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              _monthName(month).substring(0, 3),
                              style: TextStyle(
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
                  ref.read(cycleReportProvider.notifier).changePeriod(tempMonth, tempYear);
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
