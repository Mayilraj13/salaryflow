import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/formatters.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(settingsProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(settingsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // ─── GENERAL ─────────────────────────────────
                _sectionHeader('General', theme),
                Card(
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text('Dark Mode'),
                        subtitle: Text(
                          state.isDarkMode ? 'Dark theme active' : 'Light theme active',
                        ),
                        secondary: Icon(
                          state.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                          color: state.isDarkMode ? Colors.amber : Colors.orange,
                        ),
                        value: state.isDarkMode,
                        onChanged: (_) {
                          ref.read(settingsProvider.notifier).toggleDarkMode();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ─── SALARY & RENT ──────────────────────────
                _sectionHeader('Salary & Rent', theme),
                Card(
                  child: Column(
                    children: [
                      _settingTile(
                        icon: Icons.attach_money,
                        title: 'Salary Amount',
                        subtitle: NumberFormatter.formatCurrency(state.salaryAmount),
                        onTap: () => _editSalaryAmount(state),
                      ),
                      const Divider(height: 1, indent: 56),
                      _settingTile(
                        icon: Icons.calendar_today,
                        title: 'Salary Date',
                        subtitle: 'Day ${state.salaryDate} of each month',
                        onTap: () => _editSalaryDate(state),
                      ),
                      const Divider(height: 1, indent: 56),
                      _settingTile(
                        icon: Icons.home,
                        title: 'Rent Amount',
                        subtitle: NumberFormatter.formatCurrency(state.rentAmount),
                        onTap: () => _editRentAmount(state),
                      ),
                      const Divider(height: 1, indent: 56),
                      _settingTile(
                        icon: Icons.event,
                        title: 'Rent Due Day',
                        subtitle: 'Day ${state.rentDueDay} of each month',
                        onTap: () => _editRentDueDay(state),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ─── CURRENCY ───────────────────────────────
                _sectionHeader('Currency', theme),
                Card(
                  child: Column(
                    children: [
                      _settingTile(
                        icon: Icons.monetization_on,
                        title: 'Currency',
                        subtitle: '${state.currency} (${state.currencySymbol})',
                        onTap: () => _changeCurrency(state),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ─── SECURITY ───────────────────────────────
                _sectionHeader('Security', theme),
                Card(
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text('Enable PIN'),
                        subtitle: Text(
                          state.isPinEnabled ? 'PIN protection is on' : 'No PIN set',
                        ),
                        secondary: Icon(
                          state.isPinEnabled ? Icons.lock : Icons.lock_open,
                          color: state.isPinEnabled ? Colors.green : Colors.grey,
                        ),
                        value: state.isPinEnabled,
                        onChanged: (value) async {
                          if (value) {
                            _setPin();
                          } else {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Disable PIN?'),
                                content: const Text(
                                  'Are you sure you want to disable PIN protection?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  FilledButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const Text('Disable'),
                                  ),
                                ],
                              ),
                            );
                            if (confirmed == true) {
                              await ref
                                  .read(settingsProvider.notifier)
                                  .disablePin();
                            }
                          }
                        },
                      ),
                      if (state.isPinEnabled) ...[
                        const Divider(height: 1, indent: 56),
                        _settingTile(
                          icon: Icons.lock_reset,
                          title: 'Change PIN',
                          subtitle: 'Update your PIN',
                          onTap: () => _changePin(),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ─── NOTIFICATIONS ──────────────────────────
                _sectionHeader('Notifications', theme),
                Card(
                  child: SwitchListTile(
                    title: const Text('Push Notifications'),
                    subtitle: Text(
                      state.areNotificationsEnabled
                          ? 'Notifications are enabled'
                          : 'Notifications are disabled',
                    ),
                    secondary: Icon(
                      state.areNotificationsEnabled
                          ? Icons.notifications_active
                          : Icons.notifications_off,
                      color: state.areNotificationsEnabled
                          ? theme.colorScheme.primary
                          : Colors.grey,
                    ),
                    value: state.areNotificationsEnabled,
                    onChanged: (_) {
                      ref.read(settingsProvider.notifier).toggleNotifications();
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // ─── DATA ───────────────────────────────────
                _sectionHeader('Data', theme),
                Card(
                  child: Column(
                    children: [
                      _settingTile(
                        icon: Icons.file_download,
                        title: 'Export Data',
                        subtitle: 'Export your data as CSV',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Export coming soon...'),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1, indent: 56),
                      _settingTile(
                        icon: Icons.file_upload,
                        title: 'Import Data',
                        subtitle: 'Import data from a file',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Import coming soon...'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ─── ABOUT ──────────────────────────────────
                _sectionHeader('About', theme),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.info_outline),
                        title: const Text(AppConstants.appName),
                        subtitle: Text('Version ${AppConstants.appVersion}'),
                      ),
                      const Divider(height: 1, indent: 56),
                      const ListTile(
                        leading: Icon(Icons.description_outlined),
                        title: Text('Description'),
                        subtitle: Text(AppConstants.appDescription),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
    );
  }

  Widget _sectionHeader(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _settingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }

  // ─── DIALOGS ──────────────────────────────────────────────

  void _editSalaryAmount(SettingsState state) {
    final controller = TextEditingController(
      text: state.salaryAmount.toStringAsFixed(0),
    );
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Salary Amount'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Amount',
            prefixText: '₹ ',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final amount = double.tryParse(controller.text);
              if (amount != null && amount > 0) {
                ref.read(settingsProvider.notifier).setSalaryAmount(amount);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _editSalaryDate(SettingsState state) {
    showDialog(
      context: context,
      builder: (ctx) => _DayPickerDialog(
        title: 'Edit Salary Date',
        currentDay: state.salaryDate,
        onSelected: (day) {
          ref.read(settingsProvider.notifier).setSalaryDate(day);
        },
      ),
    );
  }

  void _editRentAmount(SettingsState state) {
    final controller = TextEditingController(
      text: state.rentAmount.toStringAsFixed(0),
    );
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Rent Amount'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Amount',
            prefixText: '₹ ',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final amount = double.tryParse(controller.text);
              if (amount != null && amount > 0) {
                ref.read(settingsProvider.notifier).setRentAmount(amount);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _editRentDueDay(SettingsState state) {
    showDialog(
      context: context,
      builder: (ctx) => _DayPickerDialog(
        title: 'Edit Rent Due Day',
        currentDay: state.rentDueDay,
        onSelected: (day) {
          ref.read(settingsProvider.notifier).setRentDueDay(day);
        },
      ),
    );
  }

  void _changeCurrency(SettingsState state) {
    final currencies = ['INR', 'USD', 'EUR', 'GBP', 'JPY'];
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Select Currency'),
        children: currencies.map((code) {
          String symbol;
          switch (code) {
            case 'USD': symbol = '\$'; break;
            case 'EUR': symbol = '€'; break;
            case 'GBP': symbol = '£'; break;
            case 'JPY': symbol = '¥'; break;
            default: symbol = '₹';
          }
          return RadioListTile<String>(
            title: Text('$code ($symbol)'),
            value: code,
            groupValue: state.currency,
            onChanged: (value) {
              if (value != null) {
                ref.read(settingsProvider.notifier).setCurrency(value);
                Navigator.pop(ctx);
              }
            },
          );
        }).toList(),
      ),
    );
  }

  void _setPin() {
    final pinController = TextEditingController();
    final confirmController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Set PIN'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: pinController,
              obscureText: true,
              maxLength: 6,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter PIN (4-6 digits)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: confirmController,
              obscureText: true,
              maxLength: 6,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Confirm PIN',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              if (pinController.text.length < 4) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('PIN must be at least 4 digits')),
                );
                return;
              }
              if (pinController.text != confirmController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('PINs do not match')),
                );
                return;
              }
              await ref
                  .read(settingsProvider.notifier)
                  .enablePin(pinController.text);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Set PIN'),
          ),
        ],
      ),
    );
  }

  void _changePin() {
    final oldPinController = TextEditingController();
    final newPinController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Change PIN'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPinController,
              obscureText: true,
              maxLength: 6,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Current PIN',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newPinController,
              obscureText: true,
              maxLength: 6,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'New PIN',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              if (newPinController.text.length < 4) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('PIN must be at least 4 digits')),
                );
                return;
              }
              await ref
                  .read(settingsProvider.notifier)
                  .changePin(newPinController.text);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }
}

/// A dialog that shows a list of day numbers 1-31 for selection.
class _DayPickerDialog extends StatefulWidget {
  final String title;
  final int currentDay;
  final ValueChanged<int> onSelected;

  const _DayPickerDialog({
    required this.title,
    required this.currentDay,
    required this.onSelected,
  });

  @override
  State<_DayPickerDialog> createState() => _DayPickerDialogState();
}

class _DayPickerDialogState extends State<_DayPickerDialog> {
  late int _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.currentDay;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: double.maxFinite,
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
          ),
          itemCount: 31,
          itemBuilder: (context, index) {
            final day = index + 1;
            final isSelected = day == _selectedDay;
            return GestureDetector(
              onTap: () => setState(() => _selectedDay = day),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : null,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.shade300,
                  ),
                ),
                child: Center(
                  child: Text(
                    '$day',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.white : null,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            widget.onSelected(_selectedDay);
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
