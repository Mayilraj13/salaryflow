import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/reflection_provider.dart';
import '../widgets/add_reflection_dialog.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/database/app_database.dart';

class ReflectionScreen extends ConsumerStatefulWidget {
  const ReflectionScreen({super.key});

  @override
  ConsumerState<ReflectionScreen> createState() => _ReflectionScreenState();
}

class _ReflectionScreenState extends ConsumerState<ReflectionScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(reflectionProvider.notifier).load();
    });
  }

  Future<void> _onRefresh() async {
    await ref.read(reflectionProvider.notifier).load();
  }

  Future<void> _addReflection() async {
    final notifier = ref.read(reflectionProvider.notifier);
    final totals = await notifier.getCurrentMonthTotals();
    final now = DateTime.now();

    if (!mounted) return;

    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AddReflectionDialog(
        month: now.month,
        year: now.year,
        totalIncome: totals['totalIncome'] ?? 0,
        totalExpenses: totals['totalExpenses'] ?? 0,
      ),
    );

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reflection saved!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reflectionProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reflections'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addReflection,
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : state.error != null
                ? Center(child: Text('Error: ${state.error}'))
                : _buildContent(context, state, theme),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, ReflectionState state, ThemeData theme) {
    if (state.reflections.isEmpty) {
      return ListView(
        children: [
          const SizedBox(height: 80),
          Center(
            child: Column(
              children: [
                Icon(Icons.auto_stories,
                    size: 64, color: theme.colorScheme.outline),
                const SizedBox(height: 16),
                Text(
                  AppStrings.noReflections,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap + to reflect on your month',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Current month highlight
        if (state.currentMonthReflection != null)
          _buildReflectionCard(
            context, state.currentMonthReflection!, theme, true,
          ),
        if (state.currentMonthReflection != null && state.reflections.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Text(
              'Previous Reflections',
              style: theme.textTheme.titleMedium,
            ),
          ),
        // Past reflections
        ...state.reflections
            .where((r) =>
                r.month != DateTime.now().month ||
                r.year != DateTime.now().year)
            .map((r) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _buildReflectionCard(context, r, theme, false),
                )),
      ],
    );
  }

  Widget _buildReflectionCard(
    BuildContext context,
    MonthlyReflection reflection,
    ThemeData theme,
    bool isCurrent,
  ) {
    final date = DateTime(reflection.year, reflection.month);
    final monthYear = DateFormatter.formatMonthYear(date);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isCurrent ? Icons.star : Icons.auto_stories,
                  size: 20,
                  color: isCurrent ? Colors.amber : theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  monthYear,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (isCurrent) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Current',
                      style: TextStyle(fontSize: 11, color: Colors.amber),
                    ),
                  ),
                ],
                const Spacer(),
                if (isCurrent)
                  IconButton(
                    icon: const Icon(Icons.edit, size: 18),
                    onPressed: () => _editReflection(reflection),
                    tooltip: 'Edit',
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (reflection.totalIncome != null ||
                reflection.totalExpenses != null)
              Row(
                children: [
                  if (reflection.totalIncome != null)
                    _chip(
                      'Income: ${NumberFormatter.formatCurrency(reflection.totalIncome!)}',
                      Colors.green,
                    ),
                  if (reflection.totalIncome != null &&
                      reflection.totalExpenses != null)
                    const SizedBox(width: 8),
                  if (reflection.totalExpenses != null)
                    _chip(
                      'Expenses: ${NumberFormatter.formatCurrency(reflection.totalExpenses!)}',
                      Colors.red,
                    ),
                ],
              ),
            if (reflection.totalIncome != null ||
                reflection.totalExpenses != null)
              const SizedBox(height: 12),
            if (reflection.wentWell != null && reflection.wentWell!.isNotEmpty)
              _section('What went well?', reflection.wentWell!, Icons.thumb_up,
                  Colors.green),
            if (reflection.canImprove != null &&
                reflection.canImprove!.isNotEmpty)
              _section('What can improve?', reflection.canImprove!,
                  Icons.trending_up, Colors.orange),
            if (reflection.biggestExpense != null &&
                reflection.biggestExpense!.isNotEmpty)
              _section('Biggest expense', reflection.biggestExpense!,
                  Icons.money_off, Colors.red),
            if (reflection.bestDecision != null &&
                reflection.bestDecision!.isNotEmpty)
              _section('Best decision', reflection.bestDecision!,
                  Icons.emoji_events, Colors.amber),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }

  Widget _section(String title, String content, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(content, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _editReflection(MonthlyReflection reflection) async {
    final notifier = ref.read(reflectionProvider.notifier);
    final totals = await notifier.getCurrentMonthTotals();

    if (!mounted) return;

    // For edit, we reuse AddReflectionDialog but could pre-fill.
    // Since the dialog doesn't support pre-fill, we simply open a fresh one.
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AddReflectionDialog(
        month: reflection.month,
        year: reflection.year,
        totalIncome: reflection.totalIncome ?? totals['totalIncome'] ?? 0,
        totalExpenses:
            reflection.totalExpenses ?? totals['totalExpenses'] ?? 0,
      ),
    );

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reflection updated!')),
      );
    }
  }
}
