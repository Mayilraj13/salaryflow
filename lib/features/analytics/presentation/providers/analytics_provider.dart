import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../dashboard/presentation/providers/dashboard_provider.dart';
import '../../../../core/database/dao/all_daos.dart';
import '../../../../core/database/app_database.dart';
import '../../../../data/models/all_models.dart';

/// Data point for chart rendering (pie charts, line charts).
class ChartDataPoint {
  final String label;
  final double value;

  ChartDataPoint(this.label, this.value);
}

/// Represents the analytics data state.
class AnalyticsState {
  /// Category totals for pie chart (expense breakdown).
  final List<ChartDataPoint> categoryTotals;

  /// Monthly spending trend (last 12 months).
  final List<ChartDataPoint> monthlySpendingTrend;

  /// Income vs expense comparison by month.
  final List<ChartDataPoint> incomeVsExpenses;

  /// Monthly savings trend.
  final List<ChartDataPoint> savingsTrend;

  final double totalIncome;
  final double totalExpenses;
  final double netSavings;
  final bool isLoading;
  final String? error;
  final int selectedYear;

  const AnalyticsState({
    this.categoryTotals = const [],
    this.monthlySpendingTrend = const [],
    this.incomeVsExpenses = const [],
    this.savingsTrend = const [],
    this.totalIncome = 0,
    this.totalExpenses = 0,
    this.netSavings = 0,
    this.isLoading = false,
    this.error,
    this.selectedYear = 0,
  });

  AnalyticsState copyWith({
    List<ChartDataPoint>? categoryTotals,
    List<ChartDataPoint>? monthlySpendingTrend,
    List<ChartDataPoint>? incomeVsExpenses,
    List<ChartDataPoint>? savingsTrend,
    double? totalIncome,
    double? totalExpenses,
    double? netSavings,
    bool? isLoading,
    String? error,
    int? selectedYear,
  }) {
    return AnalyticsState(
      categoryTotals: categoryTotals ?? this.categoryTotals,
      monthlySpendingTrend: monthlySpendingTrend ?? this.monthlySpendingTrend,
      incomeVsExpenses: incomeVsExpenses ?? this.incomeVsExpenses,
      savingsTrend: savingsTrend ?? this.savingsTrend,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpenses: totalExpenses ?? this.totalExpenses,
      netSavings: netSavings ?? this.netSavings,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedYear: selectedYear ?? this.selectedYear,
    );
  }
}

/// Notifier providing analytics data for charts and summaries.
class AnalyticsNotifier extends StateNotifier<AnalyticsState> {
  final IncomeDao _incomeDao;
  final ExpenseDao _expenseDao;
  final SavingsGoalDao _savingsGoalDao;
  final SavingsTransactionDao _savingsTxDao;

  AnalyticsNotifier(
    this._incomeDao,
    this._expenseDao,
    this._savingsGoalDao,
    this._savingsTxDao,
  ) : super(const AnalyticsState());

  /// Load analytics for a given year (defaults to current year).
  Future<void> load({int? year}) async {
    final targetYear = year ?? DateTime.now().year;
    state = state.copyWith(isLoading: true, error: null, selectedYear: targetYear);
    try {
      await Future.wait([
        _loadCategoryTotals(targetYear),
        _loadMonthlyTrends(targetYear),
      ]);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> _loadCategoryTotals(int year) async {
    final currentMonth = DateTime.now().month;
    final month = DateTime.now().month;

    // Get category breakdown for the current month
    final categoryMap = await _expenseDao.getCategoryTotalsByMonth(month, year);
    final categoryTotals = categoryMap.entries
        .map((e) => ChartDataPoint(e.key, e.value))
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    state = state.copyWith(categoryTotals: categoryTotals);
  }

  Future<void> _loadMonthlyTrends(int year) async {
    final now = DateTime.now();
    final monthlySpending = <ChartDataPoint>[];
    final incomeVsExpenses = <ChartDataPoint>[];
    final savingsData = <ChartDataPoint>[];
    double totalIncome = 0;
    double totalExpenses = 0;

    final monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];

    // Load data for the last 12 months (or up to the current month of the year)
    final maxMonth = year == now.year ? now.month : 12;
    for (int m = 1; m <= maxMonth; m++) {
      final results = await Future.wait([
        _incomeDao.getTotalByMonth(m, year),
        _expenseDao.getTotalByMonth(m, year),
        _savingsTxDao.getByMonth(m, year),
      ]);

      final income = results[0] as double;
      final expense = results[1] as double;
      final txList = results[2] as List<SavingsTransaction>;

      monthlySpending.add(ChartDataPoint(monthNames[m - 1], expense));
      incomeVsExpenses.add(ChartDataPoint('${monthNames[m - 1]} Income', income));
      incomeVsExpenses.add(ChartDataPoint('${monthNames[m - 1]} Expense', expense));

      // Monthly savings = deposits - withdrawals
      final deposits =
          txList.where((t) => t.type == 'deposit').fold<double>(0, (s, t) => s + t.amount);
      final withdrawals =
          txList.where((t) => t.type == 'withdrawal').fold<double>(0, (s, t) => s + t.amount);
      savingsData.add(ChartDataPoint(monthNames[m - 1], deposits - withdrawals));

      totalIncome += income;
      totalExpenses += expense;
    }

    state = state.copyWith(
      monthlySpendingTrend: monthlySpending,
      incomeVsExpenses: incomeVsExpenses,
      savingsTrend: savingsData,
      totalIncome: totalIncome,
      totalExpenses: totalExpenses,
      netSavings: totalIncome - totalExpenses,
      isLoading: false,
    );
  }

  /// Reload analytics for a different year.
  Future<void> changeYear(int year) async {
    await load(year: year);
  }
}

/// Provider for AnalyticsNotifier.
final analyticsProvider =
    StateNotifierProvider<AnalyticsNotifier, AnalyticsState>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return AnalyticsNotifier(
    IncomeDao(db),
    ExpenseDao(db),
    SavingsGoalDao(db),
    SavingsTransactionDao(db),
  );
});
