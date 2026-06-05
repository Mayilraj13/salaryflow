import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/expense_provider.dart';
import '../../../../core/theme/app_theme.dart';

/// Minimal 3-click quick expense dialog:
/// Step 1: Pick category
/// Step 2: Enter amount
/// Step 3: Confirm
class QuickExpenseDialog extends ConsumerStatefulWidget {
  /// Optional pre-selected category
  final String? category;
  /// Optional label override
  final String? label;

  const QuickExpenseDialog({
    super.key,
    this.category,
    this.label,
  });

  @override
  ConsumerState<QuickExpenseDialog> createState() => _QuickExpenseDialogState();
}

class _QuickExpenseDialogState extends ConsumerState<QuickExpenseDialog> {
  int _step = 0; // 0 = category, 1 = amount, 2 = confirm
  String _selectedCategory = '';
  final _amountController = TextEditingController();

  static const _expenseCategories = [
    'Room Rent', 'Food', 'Travel', 'Shopping', 'Electricity',
    'Internet', 'Mobile Recharge', 'Training Materials',
    'Project Components', 'Medical', 'Entertainment',
    'Tea', 'Emergency', 'Others',
  ];
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      _selectedCategory = widget.category!;
      _step = 1; // Skip to amount entry
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) return;

    setState(() => _isSubmitting = true);

    final success = await ref.read(expenseProvider.notifier).quickAddExpense(
      amount: amount,
      category: _selectedCategory,
      description: widget.label ?? _selectedCategory,
    );

    setState(() => _isSubmitting = false);

    if (success && mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Step indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: i == _step ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: i == _step
                        ? theme.colorScheme.primary
                        : i < _step
                            ? theme.colorScheme.primary.withValues(alpha: 0.4)
                            : theme.colorScheme.onSurface.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),

            // Step content
            if (_step == 0) _buildCategoryStep(theme),
            if (_step == 1) _buildAmountStep(theme),
            if (_step == 2) _buildConfirmStep(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryStep(ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Select Category',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ..._expenseCategories.map((cat) {
          final color = AppTheme.categoryColors[cat] ?? AppTheme.categoryColors['Others']!;
          final icon = AppTheme.categoryIcons[cat] ?? Icons.more_horiz;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedCategory = cat;
                    _step = 1;
                  });
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(icon, color: color, size: 22),
                      const SizedBox(width: 12),
                      Text(cat, style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: color,
                      )),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildAmountStep(ThemeData theme) {
    final color = AppTheme.categoryColors[_selectedCategory] ?? theme.colorScheme.primary;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(
              AppTheme.categoryIcons[_selectedCategory] ?? Icons.attach_money,
              color: color,
              size: 28,
            ),
            const SizedBox(width: 8),
            Text(
              _selectedCategory,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: InputDecoration(
            labelText: 'Amount',
            prefixText: '₹ ',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() => _step = 0),
                child: const Text('Back'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                onPressed: () {
                  final amount = double.tryParse(_amountController.text.trim());
                  if (amount != null && amount > 0) {
                    setState(() => _step = 2);
                  }
                },
                child: const Text('Next'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildConfirmStep(ThemeData theme) {
    final color = AppTheme.categoryColors[_selectedCategory] ?? theme.colorScheme.primary;
    final amount = double.tryParse(_amountController.text.trim()) ?? 0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(AppTheme.categoryIcons[_selectedCategory] ?? Icons.attach_money,
            size: 48, color: color),
        const SizedBox(height: 8),
        Text(_selectedCategory, style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        )),
        const SizedBox(height: 4),
        Text(
          '₹ ${amount.toStringAsFixed(0)}',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.errorColor,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() => _step = 1),
                child: const Text('Edit'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20, height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Confirm'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
