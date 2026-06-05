import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/income/presentation/screens/income_screen.dart';
import '../../features/expenses/presentation/screens/expense_screen.dart';
import '../../features/rent/presentation/screens/rent_screen.dart';
import '../../features/savings/presentation/screens/savings_screen.dart';
import '../constants/app_constants.dart';

/// Main navigation shell with BottomNavigationBar and IndexedStack.
/// Preserves state across tab switches.
class AppNavShell extends ConsumerStatefulWidget {
  const AppNavShell({super.key});

  @override
  ConsumerState<AppNavShell> createState() => _AppNavShellState();
}

class _AppNavShellState extends ConsumerState<AppNavShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    IncomeScreen(),
    ExpenseScreen(),
    RentScreen(),
    SavingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: AppStrings.navDashboard,
          ),
          NavigationDestination(
            icon: Icon(Icons.arrow_downward_outlined),
            selectedIcon: Icon(Icons.arrow_downward),
            label: AppStrings.navIncome,
          ),
          NavigationDestination(
            icon: Icon(Icons.arrow_upward_outlined),
            selectedIcon: Icon(Icons.arrow_upward),
            label: AppStrings.navExpenses,
          ),
          NavigationDestination(
            icon: Icon(Icons.home_repair_service_outlined),
            selectedIcon: Icon(Icons.home_repair_service),
            label: AppStrings.navRent,
          ),
          NavigationDestination(
            icon: Icon(Icons.savings_outlined),
            selectedIcon: Icon(Icons.savings),
            label: AppStrings.navSavings,
          ),
        ],
      ),
    );
  }
}
