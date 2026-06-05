import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/constants/app_constants.dart';
import '../providers/dashboard_provider.dart' show RentStatus;

class QuickStats extends StatelessWidget {
  final int daysUntilSalary;
  final double todaySafeSpend;
  final RentStatus rentStatus;
  final double healthScore;

  const QuickStats({
    super.key,
    required this.daysUntilSalary,
    required this.todaySafeSpend,
    required this.rentStatus,
    required this.healthScore,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final healthColor = AppTheme.getHealthScoreColor(healthScore);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(child: _QuickStatTile(
                icon: Icons.calendar_today,
                label: 'Days Until Salary',
                value: '$daysUntilSalary days',
                color: AppTheme.primaryColor,
              )),
              const SizedBox(width: 8),
              Expanded(child: _QuickStatTile(
                icon: Icons.account_balance_wallet,
                label: "Today's Safe Spend",
                value: NumberFormatter.formatCurrency(todaySafeSpend),
                color: AppTheme.successColor,
              )),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _QuickStatTile(
                icon: Icons.home_repair_service,
                label: 'Rent Status',
                value: _rentStatusLabel(rentStatus),
                color: _rentStatusColor(rentStatus),
              )),
              const Expanded(child: SizedBox()),
              const SizedBox(width: 8),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: healthColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: healthColor.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Text(
                  AppTheme.getHealthScoreEmoji(healthScore),
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Financial Health',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        AppTheme.getHealthScoreLabel(healthScore),
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: healthColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${healthScore.toStringAsFixed(0)}%',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: healthColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _rentStatusLabel(RentStatus status) {
    switch (status) {
      case RentStatus.paid:
        return 'Paid ✓';
      case RentStatus.pending:
        return 'Pending';
      case RentStatus.overdue:
        return 'Overdue!';
    }
  }

  Color _rentStatusColor(RentStatus status) {
    switch (status) {
      case RentStatus.paid:
        return AppTheme.successColor;
      case RentStatus.pending:
        return AppTheme.warningColor;
      case RentStatus.overdue:
        return AppTheme.errorColor;
    }
  }
}

class _QuickStatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _QuickStatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
