import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/balance_card.dart';
import '../widgets/stats_row.dart';
import '../widgets/quick_stats.dart';
import '../widgets/quick_expense_grid.dart';
import '../../../expenses/presentation/providers/expense_provider.dart';
import '../../../expenses/presentation/widgets/quick_expense_dialog.dart';
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

    final health = state.financialHealth;
    final healthScore = health?.score ?? 0;

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 80),
        children: [
          const SizedBox(height: 8),
          // Balance Card
          BalanceCard(
            balance: state.currentBalance,
            healthScore: healthScore,
          ),
          const SizedBox(height: 8),
          // Stats Row
          StatsRow(
            salary: state.currentBalance + state.totalExpensesThisMonth,
            expenses: state.totalExpensesThisMonth,
            savings: state.totalSavings,
          ),
          const SizedBox(height: 8),
          // Quick Stats
          QuickStats(
            daysUntilSalary: state.daysUntilSalary,
            todaySafeSpend: state.todaySafeSpend,
            rentStatus: state.rentStatus,
            healthScore: healthScore,
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
