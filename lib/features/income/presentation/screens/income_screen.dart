import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/income_provider.dart';
import '../widgets/income_card.dart';
import '../widgets/add_income_dialog.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/database/app_database.dart';

class IncomeScreen extends ConsumerStatefulWidget {
  const IncomeScreen({super.key});

  @override
  ConsumerState<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends ConsumerState<IncomeScreen> {
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final now = DateTime.now();
      ref.read(incomeProvider.notifier).loadByMonth(now.month, now.year);
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
      await ref.read(incomeProvider.notifier).search(_searchController.text);
    } else {
      await ref.read(incomeProvider.notifier).loadByMonth(now.month, now.year);
    }
  }

  void _onSearchChanged(String query) {
    _isSearching = query.isNotEmpty;
    ref.read(incomeProvider.notifier).search(query);
  }

  void _openAddDialog() {
    showDialog(
      context: context,
      builder: (_) => const AddIncomeDialog(),
    );
  }

  void _openEditDialog(IncomeRecord income) {
    showDialog(
      context: context,
      builder: (_) => AddIncomeDialog(income: income),
    );
  }

  Future<void> _deleteIncome(IncomeRecord income) async {
    if (income.id == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Income'),
        content: Text('Delete this income of ${NumberFormatter.formatCurrency(income.amount)}?'),
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
      await ref.read(incomeProvider.notifier).deleteIncome(income.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(incomeProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.navIncome),
        actions: [
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
                  hintText: 'Search income...',
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

          // Total income header
          if (state.incomes.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text(
                    'Total Income',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    NumberFormatter.formatCurrency(state.totalByMonth),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.successColor,
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

  Widget _buildBody(IncomeState state, ThemeData theme) {
    if (state.isLoading && state.incomes.isEmpty) {
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

    if (state.incomes.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.account_balance_wallet_outlined, size: 72,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
              const SizedBox(height: 16),
              Text(
                AppStrings.noIncome,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tap + to add your first income record',
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
        itemCount: state.incomes.length,
        itemBuilder: (context, index) {
          final income = state.incomes[index];
          return IncomeCard(
            income: income,
            onEdit: () => _openEditDialog(income),
            onDelete: () => _deleteIncome(income),
          );
        },
      ),
    );
  }
}
