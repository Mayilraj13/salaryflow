import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/savings_provider.dart';
import '../widgets/goal_card.dart';
import '../widgets/add_goal_dialog.dart';
import '../widgets/add_deposit_dialog.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/database/app_database.dart';

class SavingsScreen extends ConsumerStatefulWidget {
  const SavingsScreen({super.key});

  @override
  ConsumerState<SavingsScreen> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends ConsumerState<SavingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(savingsProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    await ref.read(savingsProvider.notifier).load();
  }

  void _openAddGoalDialog() {
    showDialog(
      context: context,
      builder: (_) => const AddGoalDialog(),
    );
  }

  void _openEditGoalDialog(SavingsGoal goal) {
    showDialog(
      context: context,
      builder: (_) => AddGoalDialog(goal: goal),
    );
  }

  void _openDepositDialog(SavingsGoal goal) {
    showDialog(
      context: context,
      builder: (_) => AddDepositDialog(
        goalId: goal.id,
        goalName: goal.name,
      ),
    );
  }

  Future<void> _deleteGoal(SavingsGoal goal) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Goal'),
        content: Text('Delete "${goal.name}"? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Delete', style: TextStyle(color: Theme.of(ctx).colorScheme.error)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(savingsProvider.notifier).deleteGoal(goal.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(savingsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.navSavings),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Active (${state.activeGoals.length})'),
            Tab(text: 'Completed (${state.completedGoals.length})'),
          ],
        ),
      ),
      body: _buildBody(state, theme),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddGoalDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(SavingsState state, ThemeData theme) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
              const SizedBox(height: 12),
              Text(state.error!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton.tonalIcon(
                onPressed: _refresh,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    // Total summary header
    return Column(
      children: [
        // Summary bar
        Container(
          margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryColor.withValues(alpha: 0.1),
                AppTheme.successColor.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Saved',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      NumberFormatter.formatCurrency(state.totalSaved),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.successColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Total Target',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      NumberFormatter.formatCurrency(state.totalTarget),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Tab content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildGoalList(state.activeGoals, theme, false),
              _buildGoalList(state.completedGoals, theme, true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGoalList(List<SavingsGoal> goals, ThemeData theme, bool isCompleted) {
    if (goals.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isCompleted ? Icons.emoji_events_outlined : Icons.track_changes_outlined,
                size: 72,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 16),
              Text(
                isCompleted ? 'No completed goals yet' : AppStrings.noGoals,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
              if (!isCompleted) ...[
                const SizedBox(height: 8),
                Text(
                  'Tap + to create your first savings goal',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 80),
        itemCount: goals.length,
        itemBuilder: (context, index) {
          final goal = goals[index];
          return GoalCard(
            goal: goal,
            onTap: () => _openEditGoalDialog(goal),
            onDeposit: isCompleted ? null : () => _openDepositDialog(goal),
            onDelete: () => _deleteGoal(goal),
          );
        },
      ),
    );
  }
}
