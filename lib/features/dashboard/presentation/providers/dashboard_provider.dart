import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/dao/all_daos.dart';
import '../../../../core/database/app_database.dart';
import '../../../../data/models/all_models.dart';

/// State class holding all dashboard metrics.
class DashboardState {
  final double currentBalance;
  final double totalExpensesThisMonth;
  final double totalSavings;
  final int daysUntilSalary;
  final double todaySafeSpend;
  final FinancialHealthScore? financialHealth;
  final RentStatus rentStatus;
  final bool isLoading;
  final String? error;

  const DashboardState({
    this.currentBalance = 0,
    this.totalExpensesThisMonth = 0,
    this.totalSavings = 0,
    this.daysUntilSalary = 0,
    this.todaySafeSpend = 0,
    this.financialHealth,
    this.rentStatus = RentStatus.pending,
    this.isLoading = false,
    this.error,
  });

  DashboardState copyWith({
    double? currentBalance,
    double? totalExpensesThisMonth,
    double? totalSavings,
    int? daysUntilSalary,
    double? todaySafeSpend,
    FinancialHealthScore? financialHealth,
    RentStatus? rentStatus,
    bool? isLoading,
    String? error,
  }) {
    return DashboardState(
      currentBalance: currentBalance ?? this.currentBalance,
      totalExpensesThisMonth: totalExpensesThisMonth ?? this.totalExpensesThisMonth,
      totalSavings: totalSavings ?? this.totalSavings,
      daysUntilSalary: daysUntilSalary ?? this.daysUntilSalary,
      todaySafeSpend: todaySafeSpend ?? this.todaySafeSpend,
      financialHealth: financialHealth ?? this.financialHealth,
      rentStatus: rentStatus ?? this.rentStatus,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

enum RentStatus { paid, pending, overdue }

/// Notifier that calculates all dashboard metrics.
class DashboardNotifier extends StateNotifier<DashboardState> {
  final AppDatabase _db;
  final IncomeDao _incomeDao;
  final ExpenseDao _expenseDao;
  final RentDao _rentDao;
  final SavingsGoalDao _savingsGoalDao;
  final SavingsTransactionDao _savingsTransactionDao;
  final SettingsDao _settingsDao;
  StreamSubscription? _updateSubscription;

  DashboardNotifier(this._db)
      : _incomeDao = IncomeDao(_db),
        _expenseDao = ExpenseDao(_db),
        _rentDao = RentDao(_db),
        _savingsGoalDao = SavingsGoalDao(_db),
        _savingsTransactionDao = SavingsTransactionDao(_db),
        _settingsDao = SettingsDao(_db),
        super(const DashboardState(isLoading: true)) {
    _refresh();
  }

  /// Public refresh — call after any data mutation.
  Future<void> refresh() => _refresh();

  Future<void> _refresh() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final now = DateTime.now();
      final month = now.month;
      final year = now.year;

      // Fetch all required data concurrently
      final results = await Future.wait([
        _incomeDao.getTotalByMonth(month, year),
        _expenseDao.getTotalByMonth(month, year),
        _savingsGoalDao.getTotalSaved(),
        _settingsDao.get('salary_amount').then((v) => double.tryParse(v ?? '0') ?? 0),
        _settingsDao.get('salary_date').then((v) => int.tryParse(v ?? '1') ?? 1),
        _settingsDao.get('rent_amount').then((v) => double.tryParse(v ?? '0') ?? 0),
        _settingsDao.get('rent_due_day').then((v) => int.tryParse(v ?? '1') ?? 1),
        _rentDao.getCurrentMonth(),
        _incomeDao.getTotalAll(),
        _savingsGoalDao.getTotalTarget(),
      ]);

      final totalIncomeMonth = results[0] as double;
      final totalExpensesMonth = results[1] as double;
      final totalSavings = results[2] as double;
      final salaryAmount = results[3] as double;
      final salaryDate = results[4] as int;
      final rentAmount = results[5] as double;
      final rentDueDay = results[6] as int;
      final currentRent = results[7] as RentRecord?;
      final totalAllIncome = results[8] as double;
      final totalSavingsTarget = results[9] as double;

      // Current balance = total income all time - total expenses all time
      // We compute current balance as this month's income minus this month's expenses
      // plus savings (which are already part of the balance).
      // More accurately: balance = totalIncomeAllTime - totalExpensesAllTime
      // But since we only fetch monthly, let's use a reasonable approximation:
      final totalExpensesAll = await _expenseDao.getTotalByYear(year);
      final currentBalance = totalAllIncome - totalExpensesAll;

      // Days until salary
      final salaryDateThisMonth = DateTime(year, month, salaryDate);
      DateTime nextSalaryDate;
      if (now.day <= salaryDate) {
        nextSalaryDate = salaryDateThisMonth;
      } else {
        nextSalaryDate = DateTime(year, month + 1, salaryDate);
      }
      final daysUntilSalary = nextSalaryDate.difference(now).inDays.clamp(0, 365);

      // Upcoming rent date
      final rentDueDateThisMonth = DateTime(year, month, rentDueDay);
      DateTime nextRentDate;
      if (now.day <= rentDueDay) {
        nextRentDate = rentDueDateThisMonth;
      } else {
        nextRentDate = DateTime(year, month + 1, rentDueDay);
      }

      // Rent status
      RentStatus rentStatus;
      if (currentRent == null) {
        rentStatus = RentStatus.pending;
      } else if (currentRent.isPaid) {
        rentStatus = RentStatus.paid;
      } else if (now.isAfter(currentRent.dueDate)) {
        rentStatus = RentStatus.overdue;
      } else {
        rentStatus = RentStatus.pending;
      }

      // Savings commitments from active goals
      final activeGoals = await _savingsGoalDao.getActive();
      final savingsCommitments =
          activeGoals.fold<double>(0, (sum, g) => sum + g.targetAmount);

      // Today's safe spend (Daily Budget Engine)
      final rentUpcoming = currentRent?.isPaid == true ? 0.0 : rentAmount;
      final daysUntilRent = nextRentDate.difference(now).inDays.clamp(0, 31);
      final effectiveDays = daysUntilSalary > 0 ? daysUntilSalary : 1;
      final todaySafeSpend =
          (currentBalance - rentUpcoming - savingsCommitments) / effectiveDays;
      final safeSpend = todaySafeSpend < 0 ? 0.0 : todaySafeSpend;

      // Financial health score
      final healthScore = _calculateHealthScore(
        totalIncomeMonth: totalIncomeMonth,
        totalExpensesMonth: totalExpensesMonth,
        totalSavings: totalSavings,
        totalSavingsTarget: totalSavingsTarget,
        rentAmount: rentAmount,
        rentIsPaid: currentRent?.isPaid ?? false,
      );

      state = DashboardState(
        currentBalance: currentBalance,
        totalExpensesThisMonth: totalExpensesMonth,
        totalSavings: totalSavings,
        daysUntilSalary: daysUntilSalary,
        todaySafeSpend: safeSpend,
        financialHealth: healthScore,
        rentStatus: rentStatus,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  FinancialHealthScore _calculateHealthScore({
    required double totalIncomeMonth,
    required double totalExpensesMonth,
    required double totalSavings,
    required double totalSavingsTarget,
    required double rentAmount,
    required bool rentIsPaid,
  }) {
    final income = totalIncomeMonth > 0 ? totalIncomeMonth : 1;
    final savingsRate = (totalSavings / income) * 100;
    final expenseRatio =
        totalExpensesMonth / income; // expense / income
    final rentRatio = rentAmount / income;

    // Has emergency fund = at least 3 months of expenses saved
    // Approximation: totalSavings >= 3 * totalExpensesMonth
    final monthlyExpenses = totalExpensesMonth > 0 ? totalExpensesMonth : 1;
    final hasEmergencyFund = totalSavings >= 3 * monthlyExpenses;

    final score = (savingsRate.clamp(0, 100) * 0.3) +
        ((1 - expenseRatio.clamp(0, 1)) * 30) +
        ((1 - rentRatio.clamp(0, 1)) * 20) +
        (hasEmergencyFund ? 20 : 0);

    final finalScore = score.clamp(0, 100).toDouble();

    String label;
    String emoji;
    if (finalScore >= 80) {
      label = 'Excellent';
      emoji = '🌟🌟🌟';
    } else if (finalScore >= 60) {
      label = 'Good';
      emoji = '🌟🌟';
    } else if (finalScore >= 40) {
      label = 'Average';
      emoji = '🌟';
    } else {
      label = 'Needs Improvement';
      emoji = '💪';
    }

    return FinancialHealthScore(
      score: finalScore,
      label: label,
      emoji: emoji,
      savingsRate: savingsRate,
      expenseRatio: expenseRatio,
      rentRatio: rentRatio,
      hasEmergencyFund: hasEmergencyFund,
    );
  }

  @override
  void dispose() {
    _updateSubscription?.cancel();
    super.dispose();
  }
}

/// Provider that supplies the AppDatabase instance.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

/// Provider that exposes the DashboardNotifier.
final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return DashboardNotifier(db);
});
