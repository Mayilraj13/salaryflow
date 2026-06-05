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

class CycleReportState {
  final int month;
  final int year;
  final double totalIncome;
  final double totalExpenses;
  final double netSavings;
  final List<ChartDataPoint> categoryTotals;
  final List<ExpenseRecord> expenses;
  final RentRecord? rentRecord;
  final bool isLoading;
  final String? error;

  const CycleReportState({
    this.month = 0,
    this.year = 0,
    this.totalIncome = 0,
    this.totalExpenses = 0,
    this.netSavings = 0,
    this.categoryTotals = const [],
    this.expenses = const [],
    this.rentRecord,
    this.isLoading = false,
    this.error,
  });

  CycleReportState copyWith({
    int? month,
    int? year,
    double? totalIncome,
    double? totalExpenses,
    double? netSavings,
    List<ChartDataPoint>? categoryTotals,
    List<ExpenseRecord>? expenses,
    RentRecord? rentRecord,
    bool? isLoading,
    String? error,
  }) {
    return CycleReportState(
      month: month ?? this.month,
      year: year ?? this.year,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpenses: totalExpenses ?? this.totalExpenses,
      netSavings: netSavings ?? this.netSavings,
      categoryTotals: categoryTotals ?? this.categoryTotals,
      expenses: expenses ?? this.expenses,
      rentRecord: rentRecord ?? this.rentRecord,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class CycleReportNotifier extends StateNotifier<CycleReportState> {
  final AppDatabase _db;
  final IncomeDao _incomeDao;
  final ExpenseDao _expenseDao;
  final RentDao _rentDao;
  final SettingsDao _settingsDao;

  CycleReportNotifier(this._db)
      : _incomeDao = IncomeDao(_db),
        _expenseDao = ExpenseDao(_db),
        _rentDao = RentDao(_db),
        _settingsDao = SettingsDao(_db),
        super(CycleReportState(
          month: DateTime.now().month,
          year: DateTime.now().year,
          isLoading: true,
        )) {
    load();
  }

  Future<void> changePeriod(int month, int year) async {
    state = state.copyWith(month: month, year: year, isLoading: true, error: null);
    await load();
  }

  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final salaryDateStr = await _settingsDao.get('salary_date');
      final salaryDate = int.tryParse(salaryDateStr ?? '1') ?? 1;

      // Calculate the start and end date of the cycle
      DateTime start;
      DateTime end;
      if (salaryDate <= 1) {
        start = DateTime(state.year, state.month, 1);
        end = DateTime(state.year, state.month + 1, 1).subtract(const Duration(days: 1));
      } else {
        start = DateTime(state.year, state.month - 1, salaryDate);
        end = DateTime(state.year, state.month, salaryDate).subtract(const Duration(days: 1));
      }

      final results = await Future.wait([
        _incomeDao.getByDateRange(start, end),
        _expenseDao.getByDateRange(start, end),
        _rentDao.getByMonth(state.month, state.year),
      ]);

      final incomeList = results[0] as List<IncomeRecord>;
      final expenseList = results[1] as List<ExpenseRecord>;
      final rentRecord = results[2] as RentRecord?;

      final totalIncome = incomeList.fold<double>(0, (sum, item) => sum + item.amount);
      final totalExpenses = expenseList.fold<double>(0, (sum, item) => sum + item.amount);

      final categoryMap = <String, double>{};
      for (final exp in expenseList) {
        categoryMap[exp.category] = (categoryMap[exp.category] ?? 0) + exp.amount;
      }
      final categoryTotals = categoryMap.entries
          .map((e) => ChartDataPoint(e.key, e.value))
          .toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      // Sort expenseList by date descending
      final sortedExpenses = List<ExpenseRecord>.from(expenseList)
        ..sort((a, b) => b.date.compareTo(a.date));

      state = CycleReportState(
        month: state.month,
        year: state.year,
        totalIncome: totalIncome,
        totalExpenses: totalExpenses,
        netSavings: totalIncome - totalExpenses,
        categoryTotals: categoryTotals,
        expenses: sortedExpenses,
        rentRecord: rentRecord,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final cycleReportProvider =
    StateNotifierProvider<CycleReportNotifier, CycleReportState>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return CycleReportNotifier(db);
});

class CycleSummary {
  final int month;
  final int year;
  final DateTime startDate;
  final DateTime endDate;
  final double totalIncome;
  final double totalExpenses;
  final double netSavings;
  final RentRecord? rentRecord;

  CycleSummary({
    required this.month,
    required this.year,
    required this.startDate,
    required this.endDate,
    required this.totalIncome,
    required this.totalExpenses,
    required this.netSavings,
    this.rentRecord,
  });
}

class PastCyclesState {
  final List<CycleSummary> cycles;
  final bool isLoading;
  final String? error;

  const PastCyclesState({
    this.cycles = const [],
    this.isLoading = false,
    this.error,
  });

  PastCyclesState copyWith({
    List<CycleSummary>? cycles,
    bool? isLoading,
    String? error,
  }) {
    return PastCyclesState(
      cycles: cycles ?? this.cycles,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class PastCyclesNotifier extends StateNotifier<PastCyclesState> {
  final AppDatabase _db;
  final IncomeDao _incomeDao;
  final ExpenseDao _expenseDao;
  final RentDao _rentDao;
  final SettingsDao _settingsDao;

  PastCyclesNotifier(this._db)
      : _incomeDao = IncomeDao(_db),
        _expenseDao = ExpenseDao(_db),
        _rentDao = RentDao(_db),
        _settingsDao = SettingsDao(_db),
        super(const PastCyclesState(isLoading: true)) {
    load();
  }

  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final salaryDateStr = await _settingsDao.get('salary_date');
      final salaryDate = int.tryParse(salaryDateStr ?? '1') ?? 1;

      final now = DateTime.now();
      final cycles = <CycleSummary>[];

      for (int i = 0; i < 12; i++) {
        final date = DateTime(now.year, now.month - i, 1);
        final m = date.month;
        final y = date.year;

        DateTime start;
        DateTime end;
        if (salaryDate <= 1) {
          start = DateTime(y, m, 1);
          end = DateTime(y, m + 1, 1).subtract(const Duration(days: 1));
        } else {
          start = DateTime(y, m - 1, salaryDate);
          end = DateTime(y, m, salaryDate).subtract(const Duration(days: 1));
        }

        final results = await Future.wait([
          _incomeDao.getByDateRange(start, end),
          _expenseDao.getByDateRange(start, end),
          _rentDao.getByMonth(m, y),
        ]);

        final incomeList = results[0] as List<IncomeRecord>;
        final expenseList = results[1] as List<ExpenseRecord>;
        final rentRecord = results[2] as RentRecord?;

        final totalIncome = incomeList.fold<double>(0, (sum, item) => sum + item.amount);
        final totalExpenses = expenseList.fold<double>(0, (sum, item) => sum + item.amount);

        if (incomeList.isNotEmpty || expenseList.isNotEmpty || rentRecord != null || i == 0) {
          cycles.add(CycleSummary(
            month: m,
            year: y,
            startDate: start,
            endDate: end,
            totalIncome: totalIncome,
            totalExpenses: totalExpenses,
            netSavings: totalIncome - totalExpenses,
            rentRecord: rentRecord,
          ));
        }
      }

      state = PastCyclesState(
        cycles: cycles,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final pastCyclesProvider =
    StateNotifierProvider<PastCyclesNotifier, PastCyclesState>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return PastCyclesNotifier(db);
});
