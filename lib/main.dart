import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/di/service_locator.dart';
import 'core/services/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/app_nav_shell.dart';
import 'features/settings/presentation/providers/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notification service
  final notificationService = NotificationService();
  await notificationService.initialize();

  // Setup dependency injection
  await setupServiceLocator();

  runApp(
    const ProviderScope(
      child: SalaryFlowApp(),
    ),
  );
}

class SalaryFlowApp extends ConsumerWidget {
  const SalaryFlowApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return MaterialApp(
      title: 'SalaryFlow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const AppNavShell(),
    );
  }
}
