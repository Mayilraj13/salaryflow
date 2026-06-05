import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/dao/all_daos.dart';
import '../../../../core/database/app_database.dart';
import '../../../dashboard/presentation/providers/dashboard_provider.dart';
import '../../../analytics/presentation/providers/analytics_provider.dart';

/// Expense list filtering options.
class DateRange {
  final DateTime start;
  final DateTime end;
  const DateRange({required this.start, required this.end});
}

class ExpenseFilter {
  final String? category;
  final DateRange? dateRange;
  final double? minAmount;
  final double? maxAmount;

  const ExpenseFilter({
    this.category,
    this.dateRange,
    this.minAmount,
    this.maxAmount,
  });

  ExpenseFilter copyWith({
    String? category,
    DateRange? dateRange,
    double? minAmount,
    double? maxAmount,
    bool clearCategory = false,
    bool clearDateRange = false,
  }) {
    return ExpenseFilter(
      category: clearCategory ? null : (category ?? this.category),
      dateRange: clearDateRange ? null : (dateRange ?? this.dateRange),
      minAmount: minAmount ?? this.minAmount,
      maxAmount: maxAmount ?? this.maxAmount,
    );
  }

  bool get isActive =>
      category != null ||
      dateRange != null ||
      minAmount != null ||
      maxAmount != null;
}

/// Represents the state of expense-related operations.
class ExpenseState {
  final List<ExpenseRecord> expenses;
  final double totalByMonth;
  final double todayTotal;
  final bool isLoading;
  final String? error;
  final String searchQuery;
  final ExpenseFilter filter;

  const ExpenseState({
    this.expenses = const [],
    this.totalByMonth = 0,
    this.todayTotal = 0,
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
    this.filter = const ExpenseFilter(),
  });

  ExpenseState copyWith({
    List<ExpenseRecord>? expenses,
    double? totalByMonth,
    double? todayTotal,
    bool? isLoading,
    String? error,
    String? searchQuery,
    ExpenseFilter? filter,
  }) {
    return ExpenseState(
      expenses: expenses ?? this.expenses,
      totalByMonth: totalByMonth ?? this.totalByMonth,
      todayTotal: todayTotal ?? this.todayTotal,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
      filter: filter ?? this.filter,
    );
  }
}

/// Notifier managing expense records with CRUD, search, filter, quick-add.
class ExpenseNotifier extends StateNotifier<ExpenseState> {
  final ExpenseDao _dao;
  final Ref _ref;

  ExpenseNotifier(this._dao, this._ref) : super(const ExpenseState(isLoading: true));

  /// Load expenses for a given month/year.
  Future<void> loadByMonth(int month, int year) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final results = await Future.wait([
        _dao.getByMonth(month, year),
        _dao.getTotalByMonth(month, year),
        _dao.getTodayTotal(),
      ]);
      state = ExpenseState(
        expenses: results[0] as List<ExpenseRecord>,
        totalByMonth: results[1] as double,
        todayTotal: results[2] as double,
        searchQuery: state.searchQuery,
        filter: state.filter,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Load all expense records.
  Future<void> loadAll() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final expenses = await _dao.getAll();
      state = ExpenseState(expenses: expenses);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Add a new expense record.
  Future<bool> addExpense(ExpenseRecord model) async {
    try {
      final companion = ExpenseRecordsCompanion.insert(
        amount: model.amount,
        category: model.category,
        date: model.date,
        description: Value(model.description),
        paymentMethod: Value(model.paymentMethod),
        notes: Value(model.notes),
        receiptImagePath: Value(model.receiptImagePath),
      );
      await _dao.insert(companion);
      await refreshCurrentMonth();
      _invalidateDashboard();
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Quick-add expense: minimal fields, 3 clicks max (category → amount → confirm).
  /// Defaults date to now.
  Future<bool> quickAddExpense({
    required double amount,
    required String category,
    String? description,
    String? paymentMethod,
  }) async {
    try {
      final companion = ExpenseRecordsCompanion.insert(
        amount: amount,
        category: category,
        date: DateTime.now(),
        description: Value(description),
        paymentMethod: Value(paymentMethod),
      );
      await _dao.insert(companion);
      await refreshCurrentMonth();
      _invalidateDashboard();
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Edit an existing expense record.
  Future<bool> editExpense(ExpenseRecord model) async {
    if (model.id == null) return false;
    try {
      final companion = ExpenseRecordsCompanion(
        id: Value(model.id!),
        amount: Value(model.amount),
        category: Value(model.category),
        date: Value(model.date),
        description: Value(model.description),
        paymentMethod: Value(model.paymentMethod),
        notes: Value(model.notes),
        receiptImagePath: Value(model.receiptImagePath),
        updatedAt: Value(DateTime.now()),
      );
      await _dao.update(companion);
      await refreshCurrentMonth();
      _invalidateDashboard();
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Delete an expense record by ID.
  Future<bool> deleteExpense(int id) async {
    try {
      await _dao.delete(id);
      await refreshCurrentMonth();
      _invalidateDashboard();
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Search expenses.
  Future<void> search(String query) async {
    state = state.copyWith(isLoading: true, searchQuery: query);
    try {
      if (query.isEmpty) {
        await refreshCurrentMonth();
      } else {
        final expenses = await _dao.search(query);
        final total = expenses.fold<double>(0, (sum, r) => sum + r.amount);
        state = ExpenseState(
          expenses: expenses,
          totalByMonth: total,
          searchQuery: query,
          filter: state.filter,
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Filter expenses by category.
  Future<void> filterByCategory(String? category) async {
    state = state.copyWith(
      filter: state.filter.copyWith(
        category: category,
        clearCategory: category == null,
      ),
    );
    await _applyFilter();
  }

  /// Filter expenses by date range.
  Future<void> filterByDateRange(DateRange? range) async {
    state = state.copyWith(
      filter: state.filter.copyWith(
        dateRange: range,
        clearDateRange: range == null,
      ),
    );
    await _applyFilter();
  }

  /// Clear all active filters.
  Future<void> clearFilters() async {
    state = state.copyWith(
      filter: const ExpenseFilter(),
      searchQuery: '',
    );
    await refreshCurrentMonth();
  }

  Future<void> _applyFilter() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      List<ExpenseRecord> filtered = await _dao.getAll();
      final filter = state.filter;

      if (filter.category != null) {
        filtered = filtered.where((e) => e.category == filter.category).toList();
      }
      if (filter.dateRange != null) {
        filtered = filtered
            .where((e) =>
                e.date.isAfter(filter.dateRange!.start.subtract(const Duration(days: 1))) &&
                e.date.isBefore(filter.dateRange!.end.add(const Duration(days: 1))))
            .toList();
      }
      if (filter.minAmount != null) {
        filtered = filtered.where((e) => e.amount >= filter.minAmount!).toList();
      }
      if (filter.maxAmount != null) {
        filtered = filtered.where((e) => e.amount <= filter.maxAmount!).toList();
      }

      final total = filtered.fold<double>(0, (sum, r) => sum + r.amount);
      state = ExpenseState(
        expenses: filtered,
        totalByMonth: total,
        todayTotal: await _dao.getTodayTotal(),
        searchQuery: state.searchQuery,
        filter: filter,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Get today's expense total.
  Future<double> getTodayTotal() => _dao.getTodayTotal();

  Future<void> refreshCurrentMonth() async {
    final now = DateTime.now();
    await loadByMonth(now.month, now.year);
  }

  void _invalidateDashboard() {
    _ref.invalidate(dashboardProvider);
    _ref.invalidate(cycleReportProvider);
    _ref.invalidate(pastCyclesProvider);
  }
}

/// Provider for ExpenseNotifier.
final expenseProvider =
    StateNotifierProvider<ExpenseNotifier, ExpenseState>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final dao = ExpenseDao(db);
  return ExpenseNotifier(dao, ref);
});
