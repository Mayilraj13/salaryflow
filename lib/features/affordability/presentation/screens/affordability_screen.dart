import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/affordability_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../data/models/all_models.dart';

class AffordabilityScreen extends ConsumerStatefulWidget {
  const AffordabilityScreen({super.key});

  @override
  ConsumerState<AffordabilityScreen> createState() => _AffordabilityScreenState();
}

class _AffordabilityScreenState extends ConsumerState<AffordabilityScreen> {
  final _productNameController = TextEditingController();
  final _productCostController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _hasChecked = false;

  @override
  void dispose() {
    _productNameController.dispose();
    _productCostController.dispose();
    super.dispose();
  }

  Future<void> _checkAffordability() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _productNameController.text.trim();
    final cost = double.parse(_productCostController.text.trim());

    await ref.read(affordabilityProvider.notifier).evaluate(
      productName: name,
      productCost: cost,
    );

    setState(() => _hasChecked = true);
  }

  void _clear() {
    _productNameController.clear();
    _productCostController.clear();
    setState(() => _hasChecked = false);
    ref.read(affordabilityProvider.notifier).clearResult();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(affordabilityProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.canIAfford),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header icon
              Icon(
                Icons.account_balance_wallet_outlined,
                size: 64,
                color: theme.colorScheme.primary.withValues(alpha: 0.6),
              ),
              const SizedBox(height: 8),
              Text(
                'Check if you can afford a purchase',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 32),

              // Product name
              TextFormField(
                controller: _productNameController,
                decoration: const InputDecoration(
                  labelText: AppStrings.productName,
                  prefixIcon: Icon(Icons.shopping_bag),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Enter a product name';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Product cost
              TextFormField(
                controller: _productCostController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: AppStrings.productCost,
                  prefixIcon: Icon(Icons.currency_rupee),
                  prefixText: '₹ ',
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Enter a cost';
                  final cost = double.tryParse(v);
                  if (cost == null || cost < 0) return 'Enter a valid cost';
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Check button
              FilledButton.icon(
                onPressed: state.isLoading ? null : _checkAffordability,
                icon: state.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.search),
                label: Text(state.isLoading ? 'Checking...' : 'Check'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),

              if (_hasChecked && state.lastResult != null) ...[
                const SizedBox(height: 24),
                _buildResultCard(state.lastResult!, state, theme),
              ],

              if (_hasChecked && state.lastResult == null && !state.isLoading) ...[
                const SizedBox(height: 24),
                _buildErrorCard(state, theme),
              ],

              // Financial context
              if (state.currentBalance > 0) ...[
                const SizedBox(height: 32),
                _buildContextCard(state, theme),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(
    AffordabilityResult result,
    AffordabilityState state,
    ThemeData theme,
  ) {
    final (statusColor, statusIcon, statusLabel) = switch (result.status) {
      AffordabilityStatus.safe => (
        AppTheme.successColor,
        Icons.check_circle,
        AppStrings.safeToBuy,
      ),
      AffordabilityStatus.caution => (
        AppTheme.warningColor,
        Icons.warning_amber,
        AppStrings.buyWithCaution,
      ),
      AffordabilityStatus.notRecommended => (
        AppTheme.errorColor,
        Icons.cancel,
        AppStrings.notRecommended,
      ),
    };

    return AnimatedSize(
      duration: AppConstants.defaultAnimationDuration,
      curve: Curves.easeInOut,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Status icon with pulse animation
              AnimatedSlide(
                duration: AppConstants.defaultAnimationDuration,
                offset: const Offset(0, 0),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(statusIcon, size: 48, color: statusColor),
                ),
              ),
              const SizedBox(height: 12),

              // Status label
              Text(
                statusLabel,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
              const SizedBox(height: 4),

              // Product details
              Text(
                '${result.productName} — ${NumberFormatter.formatCurrency(result.productCost)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 12),

              // Reason
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  result.reason,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Try again button
              OutlinedButton.icon(
                onPressed: _clear,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Check Another'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorCard(AffordabilityState state, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
            const SizedBox(height: 12),
            Text(
              state.error ?? 'Something went wrong',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _checkAffordability,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContextCard(AffordabilityState state, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, size: 18, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Your Financial Context',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _contextRow('Current Balance', NumberFormatter.formatCurrency(state.currentBalance), theme),
            const SizedBox(height: 6),
            _contextRow('Days Until Salary', '${state.daysUntilSalary} days', theme),
            const SizedBox(height: 6),
            _contextRow("Today's Safe Spend", NumberFormatter.formatCurrency(state.todaySafeSpend), theme),
          ],
        ),
      ),
    );
  }

  Widget _contextRow(String label, String value, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
