import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../dashboard/presentation/providers/dashboard_provider.dart';
import '../../../../core/database/dao/all_daos.dart';
import '../../../../core/database/app_database.dart';
import 'package:drift/drift.dart';

/// State for the monthly reflection feature.
class ReflectionState {
  final List<MonthlyReflection> reflections;
  final MonthlyReflection? currentMonthReflection;
  final bool isLoading;
  final String? error;

  const ReflectionState({
    this.reflections = const [],
    this.currentMonthReflection,
    this.isLoading = false,
    this.error,
  });

  ReflectionState copyWith({
    List<MonthlyReflection>? reflections,
    MonthlyReflection? currentMonthReflection,
    bool? isLoading,
    String? error,
    bool clearCurrent = false,
  }) {
    return ReflectionState(
      reflections: reflections ?? this.reflections,
      currentMonthReflection: clearCurrent
          ? null
          : (currentMonthReflection ?? this.currentMonthReflection),
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Notifier for monthly financial reflections.
class ReflectionNotifier extends StateNotifier<ReflectionState> {
  final ReflectionDao _dao;
  final IncomeDao _incomeDao;
  final ExpenseDao _expenseDao;

  ReflectionNotifier(this._dao, this._incomeDao, this._expenseDao)
      : super(const ReflectionState());

  /// Load all reflections and the current month's reflection.
  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final now = DateTime.now();
      final results = await Future.wait([
        _dao.getAll(),
        _dao.getByMonth(now.month, now.year),
      ]);
      state = ReflectionState(
        reflections: results[0] as List<MonthlyReflection>,
        currentMonthReflection: results[1] as MonthlyReflection?,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Get current month's income and expense totals.
  Future<Map<String, double>> getCurrentMonthTotals() async {
    final now = DateTime.now();
    final results = await Future.wait([
      _incomeDao.getTotalByMonth(now.month, now.year),
      _expenseDao.getTotalByMonth(now.month, now.year),
    ]);
    return {
      'totalIncome': results[0] as double,
      'totalExpenses': results[1] as double,
    };
  }

  /// Save or update a reflection for the given month/year.
  Future<bool> saveReflection({
    required int month,
    required int year,
    String? wentWell,
    String? canImprove,
    String? biggestExpense,
    String? bestDecision,
    double? totalIncome,
    double? totalExpenses,
    double? totalSavings,
  }) async {
    try {
      final existing = await _dao.getByMonth(month, year);

      if (existing != null) {
        await _dao.update(MonthlyReflectionsCompanion(
          id: Value(existing.id),
          month: Value(month),
          year: Value(year),
          wentWell: Value(wentWell),
          canImprove: Value(canImprove),
          biggestExpense: Value(biggestExpense),
          bestDecision: Value(bestDecision),
          totalIncome: Value(totalIncome),
          totalExpenses: Value(totalExpenses),
          totalSavings: Value(totalSavings),
        ));
      } else {
        await _dao.insert(MonthlyReflectionsCompanion(
          month: Value(month),
          year: Value(year),
          wentWell: Value(wentWell),
          canImprove: Value(canImprove),
          biggestExpense: Value(biggestExpense),
          bestDecision: Value(bestDecision),
          totalIncome: Value(totalIncome),
          totalExpenses: Value(totalExpenses),
          totalSavings: Value(totalSavings),
        ));
      }

      await load();
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }
}

/// Provider for ReflectionNotifier.
final reflectionProvider =
    StateNotifierProvider<ReflectionNotifier, ReflectionState>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ReflectionNotifier(
    ReflectionDao(db),
    IncomeDao(db),
    ExpenseDao(db),
  );
});
