import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../dashboard/presentation/providers/dashboard_provider.dart';
import '../../../../core/database/dao/all_daos.dart';
import '../../../../core/database/app_database.dart';
import '../../../../data/models/all_models.dart';

/// State for the affordability check feature.
class AffordabilityState {
  final AffordabilityResult? lastResult;
  final bool isLoading;
  final String? error;
  final double currentBalance;
  final int daysUntilSalary;
  final double todaySafeSpend;

  const AffordabilityState({
    this.lastResult,
    this.isLoading = false,
    this.error,
    this.currentBalance = 0,
    this.daysUntilSalary = 0,
    this.todaySafeSpend = 0,
  });

  AffordabilityState copyWith({
    AffordabilityResult? lastResult,
    bool? isLoading,
    String? error,
    double? currentBalance,
    int? daysUntilSalary,
    double? todaySafeSpend,
  }) {
    return AffordabilityState(
      lastResult: lastResult ?? this.lastResult,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentBalance: currentBalance ?? this.currentBalance,
      daysUntilSalary: daysUntilSalary ?? this.daysUntilSalary,
      todaySafeSpend: todaySafeSpend ?? this.todaySafeSpend,
    );
  }
}

/// Notifier for the "Can I Afford This?" feature.
/// Evaluates a purchase against current finances and returns a recommendation.
class AffordabilityNotifier extends StateNotifier<AffordabilityState> {
  final IncomeDao _incomeDao;
  final ExpenseDao _expenseDao;
  final RentDao _rentDao;
  final SavingsGoalDao _savingsGoalDao;
  final SettingsDao _settingsDao;

  AffordabilityNotifier(
    this._incomeDao,
    this._expenseDao,
    this._rentDao,
    this._savingsGoalDao,
    this._settingsDao,
  ) : super(const AffordabilityState());

  /// Evaluate whether the user can afford a given product.
  /// Returns the result directly and updates the state.
  Future<AffordabilityResult> evaluate({
    required String productName,
    required double productCost,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // Gather financial data
      final now = DateTime.now();
      final month = now.month;
      final year = now.year;

      final monthIncome = await _incomeDao.getTotalByMonth(month, year);
      final monthExpenseList = await _expenseDao.getByMonth(month, year);
      final monthExpenses = monthExpenseList.fold<double>(0, (s, e) => s + e.amount);
      final salaryStr = await _settingsDao.get('salary_amount');
      final salaryAmount = double.tryParse(salaryStr ?? '') ?? 0;
      final salaryDateStr = await _settingsDao.get('salary_date');
      final salaryDate = int.tryParse(salaryDateStr ?? '') ?? 1;
      final rentAmountStr = await _settingsDao.get('rent_amount');
      final rentAmountSetting = double.tryParse(rentAmountStr ?? '') ?? 0;
      final rentDueDayStr = await _settingsDao.get('rent_due_day');
      final rentDueDay = int.tryParse(rentDueDayStr ?? '') ?? 5;
      final currentRent = await _rentDao.getByMonth(month, year);
      final activeGoals = await _savingsGoalDao.getActive();

      // Calculate current balance
      final totalExpensesAll = await _expenseDao.getTotalByYear(year);
      final currentBalance = (monthIncome - totalExpensesAll).toDouble();

      // Days until next salary
      final salaryDateThisMonth = DateTime(year, month, salaryDate);
      DateTime nextSalaryDate;
      if (now.day <= salaryDate) {
        nextSalaryDate = salaryDateThisMonth;
      } else {
        nextSalaryDate = DateTime(year, month + 1, salaryDate);
      }
      final daysUntilSalary = nextSalaryDate.difference(now).inDays.clamp(0, 365);

      // Upcoming rent
      final rentDueDateThisMonth = DateTime(year, month, rentDueDay);
      DateTime nextRentDate;
      if (now.day <= rentDueDay) {
        nextRentDate = rentDueDateThisMonth;
      } else {
        nextRentDate = DateTime(year, month + 1, rentDueDay);
      }
      final rentUpcoming = currentRent?.isPaid == true ? 0.0 : rentAmountSetting;
      final daysUntilRent = nextRentDate.difference(now).inDays.clamp(0, 31);

      // Savings commitments
      final savingsCommitments =
          activeGoals.fold<double>(0, (sum, g) => sum + g.targetAmount);

      // Calculate safe daily spend
      final effectiveDays = daysUntilSalary > 0 ? daysUntilSalary : 1;
      final todaySafeSpend =
          ((currentBalance - rentUpcoming - savingsCommitments) / effectiveDays)
              .clamp(0, double.infinity).toDouble();

      // Remaining balance after this month's known expenses
      final remainingAfterEssentials =
          currentBalance - monthExpenses - rentUpcoming - savingsCommitments;

      // Determine recommendation
      AffordabilityStatus status;
      String reason;

      if (productCost <= 0) {
        status = AffordabilityStatus.safe;
        reason = 'No cost involved.';
      } else if (productCost <= todaySafeSpend) {
        status = AffordabilityStatus.safe;
        reason =
            'This expense (₹${productCost.toStringAsFixed(0)}) fits within your daily safe spend of ₹${todaySafeSpend.toStringAsFixed(0)}. You can comfortably afford this today.';
      } else if (productCost <= todaySafeSpend * 3) {
        status = AffordabilityStatus.caution;
        reason =
            'This expense (₹${productCost.toStringAsFixed(0)}) is higher than your daily safe spend of ₹${todaySafeSpend.toStringAsFixed(0)}. Consider waiting a few days or reducing other expenses.';
      } else if (productCost <= currentBalance * 0.5 &&
          remainingAfterEssentials > 0) {
        status = AffordabilityStatus.caution;
        reason =
            'This expense (₹${productCost.toStringAsFixed(0)}) is significant compared to your balance of ₹${currentBalance.toStringAsFixed(0)}. You can afford it but it will impact your savings goals.';
      } else {
        status = AffordabilityStatus.notRecommended;
        reason =
            'This expense (₹${productCost.toStringAsFixed(0)}) exceeds your available balance (₹${currentBalance.toStringAsFixed(0)}) after accounting for essential expenses. It is not recommended at this time.';
      }

      final result = AffordabilityResult(
        productName: productName,
        productCost: productCost,
        status: status,
        reason: reason,
      );

      state = AffordabilityState(
        lastResult: result,
        currentBalance: currentBalance,
        daysUntilSalary: daysUntilSalary,
        todaySafeSpend: todaySafeSpend,
      );

      return result;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  /// Clear the last affordability check result.
  void clearResult() {
    state = state.copyWith(lastResult: null, error: null);
  }
}

/// Provider for AffordabilityNotifier.
final affordabilityProvider =
    StateNotifierProvider<AffordabilityNotifier, AffordabilityState>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return AffordabilityNotifier(
    IncomeDao(db),
    ExpenseDao(db),
    RentDao(db),
    SavingsGoalDao(db),
    SettingsDao(db),
  );
});
