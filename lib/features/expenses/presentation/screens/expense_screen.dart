import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/expense_provider.dart';
import '../widgets/expense_card.dart';
import '../widgets/add_expense_dialog.dart';
import '../widgets/expense_filter_bar.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/database/app_database.dart';

class ExpenseScreen extends ConsumerStatefulWidget {
  const ExpenseScreen({super.key});

  @override
  ConsumerState<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends ConsumerState<ExpenseScreen> {
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final now = DateTime.now();
      ref.read(expenseProvider.notifier).loadByMonth(now.month, now.year);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    final now = DateTime.now();
    if (_isSearching && _searchController.text.isNotEmpty) {
      await ref.read(expenseProvider.notifier).search(_searchController.text);
    } else {
      await ref.read(expenseProvider.notifier).loadByMonth(now.month, now.year);
    }
  }

  void _onSearchChanged(String query) {
    _isSearching = query.isNotEmpty;
    ref.read(expenseProvider.notifier).search(query);
  }

  void _onCategoryFilter(String? category) {
    ref.read(expenseProvider.notifier).filterByCategory(category);
  }

  void _openAddDialog() {
    showDialog(
      context: context,
      builder: (_) => const AddExpenseDialog(),
    );
  }

  void _openEditDialog(ExpenseRecord expense) {
    showDialog(
      context: context,
      builder: (_) => AddExpenseDialog(expense: expense),
    );
  }

  Future<void> _deleteExpense(ExpenseRecord expense) async {
    if (expense.id == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Expense'),
        content: Text('Delete this expense of ${NumberFormatter.formatCurrency(expense.amount)}?'),
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
      await ref.read(expenseProvider.notifier).deleteExpense(expense.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(expenseProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.navExpenses),
        actions: [
          // Today's total badge
          if (state.todayTotal > 0)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.errorColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Today: ',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.errorColor.withValues(alpha: 0.7),
                        ),
                      ),
                      Text(
                        NumberFormatter.formatCurrency(state.todayTotal),
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.errorColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _refresh();
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          if (_isSearching)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: AppStrings.searchExpense,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _onSearchChanged('');
                          },
                        )
                      : null,
                ),
                onChanged: _onSearchChanged,
              ),
            ),

          // Filter chips
          ExpenseFilterBar(
            selectedCategory: state.filter.category,
            onCategorySelected: _onCategoryFilter,
          ),
          const SizedBox(height: 4),

          // Total header
          if (state.expenses.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  if (state.filter.isActive)
                    Chip(
                      label: Text(
                        'Filtered',
                        style: theme.textTheme.labelSmall,
                      ),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () => ref.read(expenseProvider.notifier).clearFilters(),
                    ),
                  const Spacer(),
                  Text(
                    NumberFormatter.formatCurrency(state.totalByMonth),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.errorColor,
                    ),
                  ),
                ],
              ),
            ),

          // List
          Expanded(
            child: _buildBody(state, theme),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(ExpenseState state, ThemeData theme) {
    if (state.isLoading && state.expenses.isEmpty) {
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

    if (state.expenses.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.receipt_long_outlined, size: 72,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
              const SizedBox(height: 16),
              Text(
                AppStrings.noExpenses,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tap + to add your first expense',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 4, bottom: 80),
        itemCount: state.expenses.length,
        itemBuilder: (context, index) {
          final expense = state.expenses[index];
          return ExpenseCard(
            expense: expense,
            onEdit: () => _openEditDialog(expense),
            onDelete: () => _deleteExpense(expense),
          );
        },
      ),
    );
  }
}
