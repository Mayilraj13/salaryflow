import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/balance_card.dart';
import '../widgets/stats_row.dart';
import '../widgets/quick_stats.dart';
import '../widgets/quick_expense_grid.dart';
import '../../../expenses/presentation/widgets/quick_expense_dialog.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../../../../core/constants/app_constants.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dashboardProvider.notifier).refresh();
    });
  }

  Future<void> _onRefresh() async {
    await ref.read(dashboardProvider.notifier).refresh();
  }

  void _openQuickExpense(String category, String label) {
    showDialog(
      context: context,
      builder: (_) => QuickExpenseDialog(
        category: category,
        label: label,
      ),
    );
  }

  void _editSalaryDate() {
    // Make sure settings are loaded, or load them
    final settingsState = ref.read(settingsProvider);
    showDialog(
      context: context,
      builder: (ctx) => _DayPickerDialog(
        title: 'Edit Salary Date',
        currentDay: settingsState.salaryDate,
        onSelected: (day) {
          ref.read(settingsProvider.notifier).setSalaryDate(day);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _onRefresh,
          ),
        ],
      ),
      body: _buildBody(state, theme),
    );
  }

  Widget _buildBody(DashboardState state, ThemeData theme) {
    if (state.isLoading) {
      return const _DashboardShimmer();
    }

    if (state.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
              const SizedBox(height: 16),
              Text(
                'Something went wrong',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                state.error!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _onRefresh,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 80),
        children: [
          const SizedBox(height: 8),
          // Balance Card
          BalanceCard(
            balance: state.currentBalance,
          ),
          const SizedBox(height: 8),
          // Stats Row
          StatsRow(
            salary: state.currentBalance + state.totalExpensesThisMonth,
            expenses: state.totalExpensesThisMonth,
            savings: state.totalSavings,
          ),
          const SizedBox(height: 8),
          QuickStats(
            daysUntilSalary: state.daysUntilSalary,
            todaySafeSpend: state.todaySafeSpend,
            onDaysUntilSalaryTap: _editSalaryDate,
          ),
          const SizedBox(height: 8),
          // Quick Expense Grid
          QuickExpenseGrid(onQuickAdd: _openQuickExpense),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

/// Shimmer loading placeholder for the dashboard.
class _DashboardShimmer extends StatelessWidget {
  const _DashboardShimmer();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = theme.brightness == Brightness.light
        ? Colors.grey.withValues(alpha: 0.1)
        : Colors.grey.withValues(alpha: 0.2);
    final shimmerGradient = LinearGradient(
      colors: [
        baseColor,
        baseColor.withValues(alpha: 0.5),
        baseColor,
      ],
      stops: const [0.0, 0.5, 1.0],
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: List.generate(6, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Container(
            height: index == 0 ? 160 : 80,
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      }),
    );
  }
}

/// A dialog that shows a list of day numbers 1-31 for selection.
class _DayPickerDialog extends StatefulWidget {
  final String title;
  final int currentDay;
  final ValueChanged<int> onSelected;

  const _DayPickerDialog({
    required this.title,
    required this.currentDay,
    required this.onSelected,
  });

  @override
  State<_DayPickerDialog> createState() => _DayPickerDialogState();
}

class _DayPickerDialogState extends State<_DayPickerDialog> {
  late int _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.currentDay;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: double.maxFinite,
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
          ),
          itemCount: 31,
          itemBuilder: (context, index) {
            final day = index + 1;
            final isSelected = day == _selectedDay;
            return GestureDetector(
              onTap: () => setState(() => _selectedDay = day),
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
                    '$day',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.white : null,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            widget.onSelected(_selectedDay);
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
