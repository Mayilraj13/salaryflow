import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/savings_provider.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/database/app_database.dart';

class AddGoalDialog extends ConsumerStatefulWidget {
  final SavingsGoal? goal; // null = add, non-null = edit

  const AddGoalDialog({super.key, this.goal});

  @override
  ConsumerState<AddGoalDialog> createState() => _AddGoalDialogState();
}

class _AddGoalDialogState extends ConsumerState<AddGoalDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _targetController;
  late TextEditingController _currentController;
  late TextEditingController _notesController;
  late DateTime? _targetDate;
  late String _selectedColorHex;
  bool _isSubmitting = false;

  static const _presetColors = [
    '#1A73E8', // Blue
    '#00C853', // Green
    '#FF6B6B', // Red
    '#FF8A80', // Pink
    '#FFD93D', // Yellow
    '#6C5CE7', // Purple
    '#4ECDC4', // Teal
    '#FFA000', // Orange
    '#74B9FF', // Light Blue
    '#55EFC4', // Mint
  ];

  @override
  void initState() {
    super.initState();
    final goal = widget.goal;
    _nameController = TextEditingController(text: goal?.name ?? '');
    _targetController = TextEditingController(
      text: goal != null ? goal.targetAmount.toStringAsFixed(0) : '',
    );
    _currentController = TextEditingController(
      text: goal != null ? goal.currentAmount.toStringAsFixed(0) : '',
    );
    _notesController = TextEditingController(text: goal?.notes ?? '');
    _targetDate = goal?.targetDate;
    _selectedColorHex = goal?.colorHex ?? _presetColors.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _targetController.dispose();
    _currentController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _targetDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
    );
    if (picked != null) setState(() => _targetDate = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final name = _nameController.text.trim();
    final targetAmount = double.parse(_targetController.text.trim());
    final currentAmount = double.tryParse(_currentController.text.trim()) ?? 0;
    final notes = _notesController.text.trim().isEmpty ? null : _notesController.text.trim();

    bool success;
    if (widget.goal != null) {
      success = await ref.read(savingsProvider.notifier).editGoal(
        widget.goal!.id,
        name,
        targetAmount,
        currentAmount: currentAmount,
        targetDate: _targetDate,
        notes: notes,
        colorHex: _selectedColorHex,
      );
    } else {
      success = await ref.read(savingsProvider.notifier).addGoal(
        name,
        targetAmount,
        currentAmount: currentAmount,
        targetDate: _targetDate,
        notes: notes,
        colorHex: _selectedColorHex,
      );
    }

    setState(() => _isSubmitting = false);

    if (success && mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEdit = widget.goal != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEdit ? AppStrings.editGoal : AppStrings.addGoal,
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Goal Name'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter a goal name' : null,
              ),
              const SizedBox(height: 16),

              // Target amount
              TextFormField(
                controller: _targetController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: AppStrings.targetAmount,
                  prefixText: '₹ ',
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Enter target amount';
                  final amt = double.tryParse(v);
                  if (amt == null || amt <= 0) return 'Enter a valid amount > 0';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Current amount (optional for new goals)
              TextFormField(
                controller: _currentController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Current Amount (optional)',
                  prefixText: '₹ ',
                ),
              ),
              const SizedBox(height: 16),

              // Target date
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Target Date (optional)'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_targetDate != null
                          ? DateFormatter.formatDate(_targetDate!)
                          : 'Not set'),
                      const Icon(Icons.calendar_today, size: 18),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Color picker
              Text('Goal Color', style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              )),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _presetColors.map((hex) {
                  final color = Color(int.parse('FF${hex.replaceFirst('#', '')}', radix: 16));
                  final isSelected = _selectedColorHex == hex;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColorHex = hex),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: theme.colorScheme.onSurface, width: 3)
                            : null,
                        boxShadow: isSelected
                            ? [BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 8)]
                            : null,
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, color: Colors.white, size: 18)
                          : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Notes
              TextFormField(
                controller: _notesController,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Notes (optional)'),
              ),
              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: _isSubmitting ? null : _submit,
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(isEdit ? 'Save' : 'Add'),
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
}
