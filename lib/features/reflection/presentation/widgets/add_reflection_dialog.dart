import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/reflection_provider.dart';
import '../../../../core/utils/formatters.dart';

/// Dialog to add or edit a monthly reflection.
class AddReflectionDialog extends ConsumerStatefulWidget {
  final int month;
  final int year;
  final double totalIncome;
  final double totalExpenses;

  const AddReflectionDialog({
    super.key,
    required this.month,
    required this.year,
    required this.totalIncome,
    required this.totalExpenses,
  });

  @override
  ConsumerState<AddReflectionDialog> createState() =>
      _AddReflectionDialogState();
}

class _AddReflectionDialogState extends ConsumerState<AddReflectionDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _wentWellController;
  late final TextEditingController _canImproveController;
  late final TextEditingController _biggestExpenseController;
  late final TextEditingController _bestDecisionController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _wentWellController = TextEditingController();
    _canImproveController = TextEditingController();
    _biggestExpenseController = TextEditingController();
    _bestDecisionController = TextEditingController();
  }

  @override
  void dispose() {
    _wentWellController.dispose();
    _canImproveController.dispose();
    _biggestExpenseController.dispose();
    _bestDecisionController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final success = await ref.read(reflectionProvider.notifier).saveReflection(
          month: widget.month,
          year: widget.year,
          wentWell: _wentWellController.text.trim(),
          canImprove: _canImproveController.text.trim(),
          biggestExpense: _biggestExpenseController.text.trim(),
          bestDecision: _bestDecisionController.text.trim(),
          totalIncome: widget.totalIncome,
          totalExpenses: widget.totalExpenses,
        );

    if (mounted) {
      setState(() => _isSaving = false);
      if (success) {
        Navigator.of(context).pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save reflection')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final monthName = DateFormatter.formatMonthYear(
      DateTime(widget.year, widget.month),
    );

    return AlertDialog(
      title: Text('Reflection — $monthName'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Monthly Summary',
                        style: theme.textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _summaryItem(
                              'Income',
                              NumberFormatter.formatCurrency(widget.totalIncome),
                              Colors.green,
                            ),
                          ),
                          Expanded(
                            child: _summaryItem(
                              'Expenses',
                              NumberFormatter.formatCurrency(widget.totalExpenses),
                              Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // What went well
              TextFormField(
                controller: _wentWellController,
                decoration: const InputDecoration(
                  labelText: 'What went well?',
                  hintText: 'e.g., Saved extra this month',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Please enter something' : null,
              ),
              const SizedBox(height: 12),
              // What can improve
              TextFormField(
                controller: _canImproveController,
                decoration: const InputDecoration(
                  labelText: 'What can improve?',
                  hintText: 'e.g., Reduce eating out',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Please enter something' : null,
              ),
              const SizedBox(height: 12),
              // Biggest expense
              TextFormField(
                controller: _biggestExpenseController,
                decoration: const InputDecoration(
                  labelText: 'Biggest expense this month?',
                  hintText: 'e.g., Shopping',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              // Best decision
              TextFormField(
                controller: _bestDecisionController,
                decoration: const InputDecoration(
                  labelText: 'Best financial decision?',
                  hintText: 'e.g., Started emergency fund',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isSaving ? null : _save,
          child: _isSaving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save Reflection'),
        ),
      ],
    );
  }

  Widget _summaryItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
