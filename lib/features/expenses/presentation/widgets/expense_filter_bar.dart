import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Horizontal scrollable filter chips for expense categories.
class ExpenseFilterBar extends StatelessWidget {
  final String? selectedCategory;
  final void Function(String?) onCategorySelected;

  static const _categories = [
    'Room Rent', 'Food', 'Travel', 'Shopping', 'Electricity',
    'Internet', 'Mobile Recharge', 'Training Materials',
    'Project Components', 'Medical', 'Entertainment',
    'Tea', 'Emergency', 'Others',
  ];

  const ExpenseFilterBar({
    super.key,
    this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _FilterChip(
            label: 'All',
            icon: Icons.all_inclusive,
            isSelected: selectedCategory == null,
            color: AppTheme.primaryColor,
            onTap: () => onCategorySelected(null),
          ),
          const SizedBox(width: 8),
          ..._categories.map((cat) {
            final color = AppTheme.categoryColors[cat] ?? AppTheme.categoryColors['Others']!;
            final icon = AppTheme.categoryIcons[cat] ?? Icons.more_horiz;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _FilterChip(
                label: cat,
                icon: icon,
                isSelected: selectedCategory == cat,
                color: color,
                onTap: () => onCategorySelected(selectedCategory == cat ? null : cat),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? color : color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? color : color.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : color,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? Colors.white : color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
