import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';

class StatsRow extends StatelessWidget {
  final double salary;
  final double expenses;
  final double savings;

  const StatsRow({
    super.key,
    required this.salary,
    required this.expenses,
    required this.savings,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Expanded(child: _StatCard(
            icon: Icons.trending_up,
            label: 'Salary',
            amount: salary,
            color: AppTheme.successColor,
          )),
          const SizedBox(width: 8),
          Expanded(child: _StatCard(
            icon: Icons.trending_down,
            label: 'Expenses',
            amount: expenses,
            color: AppTheme.errorColor,
          )),
          const SizedBox(width: 8),
          Expanded(child: _StatCard(
            icon: Icons.savings,
            label: 'Savings',
            amount: savings,
            color: AppTheme.infoColor,
          )),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final double amount;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              NumberFormatter.formatCompact(amount),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
