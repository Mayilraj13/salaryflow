import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/expense_provider.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/constants/app_constants.dart';

class AddExpenseDialog extends ConsumerStatefulWidget {
  final ExpenseRecord? expense; // null = add mode, non-null = edit mode
  final bool quickMode; // If true, only amount + category shown initially

  const AddExpenseDialog({
    super.key,
    this.expense,
    this.quickMode = false,
  });

  @override
  ConsumerState<AddExpenseDialog> createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends ConsumerState<AddExpenseDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  late TextEditingController _notesController;
  late String _selectedCategory;
  late String _selectedPaymentMethod;
  late DateTime _selectedDate;
  bool _isSubmitting = false;
  bool _showFullForm = false;

  static const _paymentMethods = ['Cash', 'UPI', 'Card', 'NetBanking'];

  static const _expenseCategories = [
    'Room Rent', 'Food', 'Travel', 'Shopping', 'Electricity',
    'Internet', 'Mobile Recharge', 'Training Materials',
    'Project Components', 'Medical', 'Entertainment',
    'Tea', 'Emergency', 'Others',
  ];

  @override
  void initState() {
    super.initState();
    final expense = widget.expense;
    _amountController = TextEditingController(
      text: expense != null ? expense.amount.toStringAsFixed(0) : '',
    );
    _descriptionController = TextEditingController(text: expense?.description ?? '');
    _notesController = TextEditingController(text: expense?.notes ?? '');
    _selectedCategory = expense?.category ?? _expenseCategories.first;
    _selectedPaymentMethod = expense?.paymentMethod ?? _paymentMethods.first;
    _selectedDate = expense?.date ?? DateTime.now();
    _showFullForm = !widget.quickMode || widget.expense != null;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final model = ExpenseRecord(
      id: widget.expense?.id ?? 0,
      amount: double.parse(_amountController.text.trim()),
      category: _selectedCategory,
      date: _selectedDate,
      description: _descriptionController.text.trim().isEmpty
          ? null : _descriptionController.text.trim(),
      paymentMethod: _selectedPaymentMethod,
      notes: _notesController.text.trim().isEmpty
          ? null : _notesController.text.trim(),
      receiptImagePath: null,
      createdAt: widget.expense?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    bool success;
    if (widget.expense != null) {
      success = await ref.read(expenseProvider.notifier).editExpense(model);
    } else {
      success = await ref.read(expenseProvider.notifier).addExpense(model);
    }

    setState(() => _isSubmitting = false);

    if (success && mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEdit = widget.expense != null;

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
                isEdit ? AppStrings.editExpense : AppStrings.addExpense,
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Amount
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixText: '₹ ',
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Please enter an amount';
                  final amount = double.tryParse(v);
                  if (amount == null || amount <= 0) return 'Enter a valid amount > 0';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Category dropdown
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Category'),
                items: _expenseCategories.map((c) => DropdownMenuItem(
                  value: c,
                  child: Text(c),
                )).toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _selectedCategory = v);
                },
              ),

              if (_showFullForm || isEdit) ...[
                const SizedBox(height: 16),
                // Date picker
                InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(12),
                  child: InputDecorator(
                    decoration: const InputDecoration(labelText: 'Date'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(DateFormatter.formatDate(_selectedDate)),
                        const Icon(Icons.calendar_today, size: 18),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Description
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description (optional)'),
                ),
                const SizedBox(height: 16),
                // Payment method
                DropdownButtonFormField<String>(
                  value: _selectedPaymentMethod,
                  decoration: const InputDecoration(labelText: 'Payment Method'),
                  items: _paymentMethods.map((m) => DropdownMenuItem(
                    value: m,
                    child: Text(m),
                  )).toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => _selectedPaymentMethod = v);
                  },
                ),
                const SizedBox(height: 16),
                // Notes
                TextFormField(
                  controller: _notesController,
                  maxLines: 2,
                  decoration: const InputDecoration(labelText: 'Notes (optional)'),
                ),
              ] else ...[
                const SizedBox(height: 12),
                Center(
                  child: TextButton.icon(
                    onPressed: () => setState(() => _showFullForm = true),
                    icon: const Icon(Icons.expand_more),
                    label: const Text('More details'),
                  ),
                ),
              ],

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
