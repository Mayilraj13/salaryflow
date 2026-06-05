import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/rent_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../data/models/all_models.dart';

class RentStatusCard extends ConsumerWidget {
  const RentStatusCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(rentProvider);
    final theme = Theme.of(context);

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final rent = state.currentMonth;
    if (rent == null) {
      return Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Text(AppStrings.noRent, style: theme.textTheme.bodyMedium),
          ),
        ),
      );
    }

    final isPaid = state.isCurrentPaid;
    final statusColor = isPaid ? AppTheme.successColor : AppTheme.warningColor;
    final statusIcon = isPaid ? Icons.check_circle : Icons.pending;
    final statusLabel = isPaid ? AppStrings.rentPaid : AppStrings.rentPending;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Status icon
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                statusIcon,
                size: 48,
                color: statusColor,
              ),
            ),
            const SizedBox(height: 16),

            // Rent amount
            Text(
              NumberFormatter.formatCurrency(rent.amount),
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Due date
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today, size: 16, color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                const SizedBox(width: 6),
                Text(
                  '${AppStrings.rentDueDate}: ${DateFormatter.formatDate(rent.dueDate)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Month/Year
            Text(
              DateFormatter.formatMonthYear(DateTime(rent.year, rent.month)),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 16),

            // Status label
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                statusLabel,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Action button
            SizedBox(
              width: double.infinity,
              child: isPaid
                  ? OutlinedButton.icon(
                      onPressed: null,
                      icon: const Icon(Icons.check),
                      label: const Text('Paid ✓'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.successColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    )
                  : FilledButton.icon(
                      onPressed: () => _markAsPaid(context, ref),
                      icon: const Icon(Icons.check_circle),
                      label: const Text(AppStrings.markAsPaid),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _markAsPaid(BuildContext context, WidgetRef ref) async {
    final success = await ref.read(rentProvider.notifier).markAsPaid();
    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rent marked as paid!')),
      );
    }
  }
}
