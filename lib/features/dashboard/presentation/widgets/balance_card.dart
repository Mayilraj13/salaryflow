import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/constants/app_constants.dart';

class BalanceCard extends ConsumerWidget {
  final double balance;
  final double healthScore;

  const BalanceCard({
    super.key,
    required this.balance,
    required this.healthScore,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healthColor = AppTheme.getHealthScoreColor(healthScore);
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            healthColor.withValues(alpha: 0.8),
            healthColor.withValues(alpha: 0.4),
            theme.colorScheme.surface.withValues(alpha: 0.9),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: healthColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: (theme.brightness == Brightness.light)
              ? ColorFilter.mode(Colors.white.withValues(alpha: 0.2), BlendMode.overlay)
              : ColorFilter.mode(Colors.black.withValues(alpha: 0.2), BlendMode.overlay),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.currentBalance,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: healthColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            AppTheme.getHealthScoreEmoji(healthScore),
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${healthScore.toStringAsFixed(0)}%',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: healthColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                AnimatedSlide(
                  duration: AppConstants.defaultAnimationDuration,
                  offset: const Offset(0, 0),
                  child: AnimatedOpacity(
                    duration: AppConstants.defaultAnimationDuration,
                    opacity: 1,
                    child: Text(
                      NumberFormatter.formatCurrency(balance),
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                        fontSize: 36,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppTheme.getHealthScoreLabel(healthScore),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: healthColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
