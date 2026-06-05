import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/dao/all_daos.dart';
import '../../../../core/database/app_database.dart';
import '../../../dashboard/presentation/providers/dashboard_provider.dart';
import '../../../analytics/presentation/providers/analytics_provider.dart';

/// Represents the state of income-related operations.
class IncomeState {
  final List<IncomeRecord> incomes;
  final double totalByMonth;
  final bool isLoading;
  final String? error;
  final String searchQuery;

  const IncomeState({
    this.incomes = const [],
    this.totalByMonth = 0,
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
  });

  IncomeState copyWith({
    List<IncomeRecord>? incomes,
    double? totalByMonth,
    bool? isLoading,
    String? error,
    String? searchQuery,
  }) {
    return IncomeState(
      incomes: incomes ?? this.incomes,
      totalByMonth: totalByMonth ?? this.totalByMonth,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// Notifier managing income records with full CRUD + search.
class IncomeNotifier extends StateNotifier<IncomeState> {
  final IncomeDao _dao;
  final Ref _ref;

  IncomeNotifier(this._dao, this._ref) : super(const IncomeState(isLoading: true));

  /// Load income records for a given month/year.
  Future<void> loadByMonth(int month, int year) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final results = await Future.wait([
        _dao.getByMonth(month, year),
        _dao.getTotalByMonth(month, year),
      ]);
      state = IncomeState(
        incomes: results[0] as List<IncomeRecord>,
        totalByMonth: results[1] as double,
        searchQuery: state.searchQuery,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Load all income records.
  Future<void> loadAll() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final incomes = await _dao.getAll();
      state = IncomeState(incomes: incomes);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Add a new income record.
  Future<bool> addIncome(IncomeRecord model) async {
    try {
      final companion = IncomeRecordsCompanion.insert(
        amount: model.amount,
        category: model.category,
        date: model.date,
        description: Value(model.description),
        source: Value(model.source),
        notes: Value(model.notes),
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

  /// Edit an existing income record.
  Future<bool> editIncome(IncomeRecord model) async {
    if (model.id == null) return false;
    try {
      final companion = IncomeRecordsCompanion(
        id: Value(model.id!),
        amount: Value(model.amount),
        category: Value(model.category),
        date: Value(model.date),
        description: Value(model.description),
        source: Value(model.source),
        notes: Value(model.notes),
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

  /// Delete an income record by ID.
  Future<bool> deleteIncome(int id) async {
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

  /// Search income records.
  Future<void> search(String query) async {
    state = state.copyWith(isLoading: true, searchQuery: query);
    try {
      if (query.isEmpty) {
        await refreshCurrentMonth();
      } else {
        final incomes = await _dao.search(query);
        final total = incomes.fold<double>(0, (sum, r) => sum + r.amount);
        state = IncomeState(
          incomes: incomes,
          totalByMonth: total,
          searchQuery: query,
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Get total income for a month.
  Future<double> getTotalByMonth(int month, int year) {
    return _dao.getTotalByMonth(month, year);
  }

  /// Get incomes for a specific month.
  Future<List<IncomeRecord>> getByMonth(int month, int year) {
    return _dao.getByMonth(month, year);
  }

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

/// Provider for IncomeNotifier.
final incomeProvider =
    StateNotifierProvider<IncomeNotifier, IncomeState>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final dao = IncomeDao(db);
  return IncomeNotifier(dao, ref);
});
