import 'package:flutter/material.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';

class GoalCard extends StatelessWidget {
  final SavingsGoal goal;
  final VoidCallback? onTap;
  final VoidCallback? onDeposit;
  final VoidCallback? onDelete;

  const GoalCard({
    super.key,
    required this.goal,
    this.onTap,
    this.onDeposit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final goalColor = _resolveColor(goal.colorHex);
    final progress = goal.targetAmount > 0 ? (goal.currentAmount / goal.targetAmount) * 100 : 0;
    final isCompleted = goal.isCompleted;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  // Color indicator
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: goalColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Name
                  Expanded(
                    child: Text(
                      goal.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Completed badge
                  if (isCompleted)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.successColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.emoji_events, size: 14, color: AppTheme.successColor),
                          const SizedBox(width: 4),
                          Text(
                            'Done!',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppTheme.successColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Amount row
              Row(
                children: [
                  Text(
                    NumberFormatter.formatCurrency(goal.currentAmount),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: goalColor,
                    ),
                  ),
                  Text(
                    ' / ${NumberFormatter.formatCurrency(goal.targetAmount)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${progress.toStringAsFixed(1)}%',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: goalColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: (progress / 100).clamp(0.0, 1.0),
                  backgroundColor: goalColor.withValues(alpha: 0.15),
                  valueColor: AlwaysStoppedAnimation<Color>(goalColor),
                  minHeight: 10,
                ),
              ),
              const SizedBox(height: 8),

              // Footer: target date and actions
              Row(
                children: [
                  if (goal.targetDate != null) ...[
                    Icon(Icons.date_range, size: 14,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
                    const SizedBox(width: 4),
                    Text(
                      DateFormatter.formatDate(goal.targetDate!),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                  const Spacer(),
                  if (!isCompleted && onDeposit != null)
                    IconButton(
                      onPressed: onDeposit,
                      icon: const Icon(Icons.add_circle_outline),
                      iconSize: 20,
                      tooltip: 'Add Deposit',
                      style: IconButton.styleFrom(
                        foregroundColor: AppTheme.successColor,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  if (onDelete != null)
                    IconButton(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete_outline),
                      iconSize: 18,
                      tooltip: 'Delete Goal',
                      style: IconButton.styleFrom(
                        foregroundColor: theme.colorScheme.error.withValues(alpha: 0.7),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _resolveColor(String? colorHex) {
    if (colorHex == null || colorHex.isEmpty) return AppTheme.primaryColor;
    try {
      final hex = colorHex.replaceFirst('#', '');
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      } else if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
    } catch (_) {}
    return AppTheme.primaryColor;
  }
}
