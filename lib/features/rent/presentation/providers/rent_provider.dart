import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/dao/all_daos.dart';
import '../../../../core/database/app_database.dart';
import '../../../dashboard/presentation/providers/dashboard_provider.dart';

/// Represents the state of rent-related operations.
class RentState {
  final List<RentRecord> rentHistory;
  final RentRecord? currentMonth;
  final bool isCurrentPaid;
  final bool isLoading;
  final String? error;

  const RentState({
    this.rentHistory = const [],
    this.currentMonth,
    this.isCurrentPaid = false,
    this.isLoading = false,
    this.error,
  });

  RentState copyWith({
    List<RentRecord>? rentHistory,
    RentRecord? currentMonth,
    bool? isCurrentPaid,
    bool? isLoading,
    String? error,
  }) {
    return RentState(
      rentHistory: rentHistory ?? this.rentHistory,
      currentMonth: currentMonth ?? this.currentMonth,
      isCurrentPaid: isCurrentPaid ?? this.isCurrentPaid,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Notifier for rent management: mark paid, history, auto-create.
class RentNotifier extends StateNotifier<RentState> {
  final RentDao _dao;
  final SettingsDao _settingsDao;
  final Ref _ref;

  RentNotifier(this._dao, this._settingsDao, this._ref)
      : super(const RentState(isLoading: true));

  /// Load current month rent and history.
  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final results = await Future.wait([
        _dao.getCurrentMonth(),
        _dao.getAll(),
      ]);
      final currentMonth = results[0] as RentRecord?;
      final history = results[1] as List<RentRecord>;

      // Auto-create rent record for current month if missing
      RentRecord? resolvedCurrent = currentMonth;
      if (resolvedCurrent == null) {
        resolvedCurrent = await _autoCreateCurrentMonth();
      }

      state = RentState(
        rentHistory: history,
        currentMonth: resolvedCurrent,
        isCurrentPaid: resolvedCurrent?.isPaid ?? false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Auto-create a rent record for the current month.
  Future<RentRecord> _autoCreateCurrentMonth() async {
    final now = DateTime.now();
    final rentAmountStr = await _settingsDao.get('rent_amount');
    final rentDueDayStr = await _settingsDao.get('rent_due_day');
    final rentAmount = double.tryParse(rentAmountStr ?? '0') ?? 0;
    final rentDueDay = int.tryParse(rentDueDayStr ?? '1') ?? 1;

    final dueDate = DateTime(now.year, now.month, rentDueDay);
    final companion = RentRecordsCompanion(
      amount: Value(rentAmount),
      dueDate: Value(dueDate),
      month: Value(now.month),
      year: Value(now.year),
      isPaid: const Value(false),
    );
    final id = await _dao.insert(companion);
    return _dao.getById(id);
  }

  /// Mark the current month's rent as paid.
  Future<bool> markAsPaid({
    DateTime? paidDate,
    String? notes,
    String? landlordNotes,
  }) async {
    try {
      final now = DateTime.now();
      RentRecord? current = state.currentMonth;

      // If no record exists, auto-create one first
      if (current == null) {
        current = await _autoCreateCurrentMonth();
      }

      final companion = RentRecordsCompanion(
        id: Value(current.id),
        amount: Value(current.amount),
        dueDate: Value(current.dueDate),
        month: Value(current.month),
        year: Value(current.year),
        isPaid: const Value(true),
        paidDate: Value(paidDate ?? now),
        notes: Value(current.notes),
        landlordNotes: Value(current.landlordNotes),
      );

      await _dao.update(companion);
      await load();
      _invalidateDashboard();
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Get rent status for a specific month and year.
  Future<RentRecord?> getByMonth(int month, int year) {
    return _dao.getByMonth(month, year);
  }

  /// Get rent history for a year.
  Future<List<RentRecord>> getByYear(int year) {
    return _dao.getByYear(year);
  }

  void _invalidateDashboard() {
    _ref.invalidate(dashboardProvider);
  }
}

/// Provider for RentNotifier.
final rentProvider =
    StateNotifierProvider<RentNotifier, RentState>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final dao = RentDao(db);
  final settingsDao = SettingsDao(db);
  return RentNotifier(dao, settingsDao, ref);
});
