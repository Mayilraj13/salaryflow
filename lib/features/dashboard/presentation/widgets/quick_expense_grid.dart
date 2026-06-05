import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Quick-add expense categories shown on the dashboard.
class QuickExpenseGrid extends StatelessWidget {
  final void Function(String category, String label) onQuickAdd;

  const QuickExpenseGrid({
    super.key,
    required this.onQuickAdd,
  });

  static const _quickCategories = [
    ('Food', Icons.restaurant, 'Food'),
    ('Travel', Icons.directions_bus, 'Travel'),
    ('Tea', Icons.local_cafe, 'Tea'),
    ('Shopping', Icons.shopping_bag, 'Shopping'),
    ('Entertainment', Icons.movie, 'Entertain'),
    ('Medical', Icons.medical_services, 'Medical'),
    ('Internet', Icons.wifi, 'Internet'),
    ('Others', Icons.more_horiz, 'Others'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              'Quick Add Expense',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.05,
            children: _quickCategories.map((item) {
              final category = item.$1;
              final icon = item.$2;
              final label = item.$3;
              final color = AppTheme.categoryColors[category] ?? AppTheme.categoryColors['Others']!;
              return _QuickAddButton(
                icon: icon,
                label: label,
                color: color,
                onTap: () => onQuickAdd(category, label),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _QuickAddButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAddButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: color.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 24, color: color),
              const SizedBox(height: 4),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
