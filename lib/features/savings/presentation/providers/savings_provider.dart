import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../../../../core/database/dao/all_daos.dart';
import '../../../../core/database/app_database.dart';
import '../../../dashboard/presentation/providers/dashboard_provider.dart';

/// Represents the state of savings-related operations.
class SavingsState {
  final List<SavingsGoal> goals;
  final List<SavingsGoal> activeGoals;
  final List<SavingsGoal> completedGoals;
  final double totalSaved;
  final double totalTarget;
  final bool isLoading;
  final String? error;

  const SavingsState({
    this.goals = const [],
    this.activeGoals = const [],
    this.completedGoals = const [],
    this.totalSaved = 0,
    this.totalTarget = 0,
    this.isLoading = false,
    this.error,
  });

  SavingsState copyWith({
    List<SavingsGoal>? goals,
    List<SavingsGoal>? activeGoals,
    List<SavingsGoal>? completedGoals,
    double? totalSaved,
    double? totalTarget,
    bool? isLoading,
    String? error,
  }) {
    return SavingsState(
      goals: goals ?? this.goals,
      activeGoals: activeGoals ?? this.activeGoals,
      completedGoals: completedGoals ?? this.completedGoals,
      totalSaved: totalSaved ?? this.totalSaved,
      totalTarget: totalTarget ?? this.totalTarget,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Notifier managing savings goals with CRUD and transactions.
class SavingsNotifier extends StateNotifier<SavingsState> {
  final SavingsGoalDao _goalDao;
  final SavingsTransactionDao _txDao;
  final Ref _ref;

  SavingsNotifier(this._goalDao, this._txDao, this._ref)
      : super(const SavingsState(isLoading: true));

  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final results = await Future.wait([
        _goalDao.getAll(),
        _goalDao.getActive(),
        _goalDao.getCompleted(),
        _goalDao.getTotalSaved(),
        _goalDao.getTotalTarget(),
      ]);
      state = SavingsState(
        goals: results[0] as List<SavingsGoal>,
        activeGoals: results[1] as List<SavingsGoal>,
        completedGoals: results[2] as List<SavingsGoal>,
        totalSaved: results[3] as double,
        totalTarget: results[4] as double,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> addGoal(String name, double targetAmount, {double currentAmount = 0, DateTime? targetDate, String? notes, String? colorHex}) async {
    try {
      final companion = SavingsGoalsCompanion.insert(
        name: name,
        targetAmount: targetAmount,
        currentAmount: Value(currentAmount),
        targetDate: Value(targetDate),
        notes: Value(notes),
        colorHex: Value(colorHex),
      );
      await _goalDao.insert(companion);
      await load();
      _invalidateDashboard();
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  Future<bool> editGoal(int id, String name, double targetAmount, {double? currentAmount, DateTime? targetDate, String? notes, String? colorHex, bool? isCompleted}) async {
    try {
      final companion = SavingsGoalsCompanion(
        id: Value(id),
        name: Value(name),
        targetAmount: Value(targetAmount),
        currentAmount: Value(currentAmount ?? 0),
        targetDate: Value(targetDate),
        notes: Value(notes),
        colorHex: Value(colorHex),
        isCompleted: Value(isCompleted ?? false),
        updatedAt: Value(DateTime.now()),
      );
      await _goalDao.update(companion);
      await load();
      _invalidateDashboard();
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  Future<bool> deleteGoal(int id) async {
    try {
      await _goalDao.delete(id);
      await load();
      _invalidateDashboard();
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  Future<bool> addDeposit(int goalId, double amount, {String? notes, DateTime? date}) async {
    try {
      final now = date ?? DateTime.now();
      await _txDao.insert(SavingsTransactionsCompanion.insert(
        goalId: goalId,
        amount: amount,
        type: 'deposit',
        date: now,
        notes: Value(notes),
      ));

      final goal = await _goalDao.getById(goalId);
      final newAmount = goal.currentAmount + amount;
      final isCompleted = newAmount >= goal.targetAmount;
      await _goalDao.update(SavingsGoalsCompanion(
        id: Value(goal.id),
        name: Value(goal.name),
        targetAmount: Value(goal.targetAmount),
        currentAmount: Value(newAmount),
        targetDate: Value(goal.targetDate),
        notes: Value(goal.notes),
        colorHex: Value(goal.colorHex),
        isCompleted: Value(isCompleted),
        updatedAt: Value(DateTime.now()),
      ));
      await load();
      _invalidateDashboard();
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  Future<bool> addWithdrawal(int goalId, double amount, {String? notes, DateTime? date}) async {
    try {
      final now = date ?? DateTime.now();
      await _txDao.insert(SavingsTransactionsCompanion.insert(
        goalId: goalId,
        amount: amount,
        type: 'withdrawal',
        date: now,
        notes: Value(notes),
      ));

      final goal = await _goalDao.getById(goalId);
      final newAmount = (goal.currentAmount - amount).clamp(0, goal.currentAmount);
      await _goalDao.update(SavingsGoalsCompanion(
        id: Value(goal.id),
        name: Value(goal.name),
        targetAmount: Value(goal.targetAmount),
        currentAmount: Value(newAmount.toDouble()),
        targetDate: Value(goal.targetDate),
        notes: Value(goal.notes),
        colorHex: Value(goal.colorHex),
        isCompleted: Value(newAmount >= goal.targetAmount),
        updatedAt: Value(DateTime.now()),
      ));
      await load();
      _invalidateDashboard();
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  double calculateProgress(SavingsGoal goal) {
    return goal.targetAmount > 0 ? (goal.currentAmount / goal.targetAmount) * 100 : 0;
  }

  Future<List<SavingsTransaction>> getTransactionsByGoal(int goalId) {
    return _txDao.getByGoal(goalId);
  }

  void _invalidateDashboard() {
    _ref.invalidate(dashboardProvider);
  }
}

final savingsProvider =
    StateNotifierProvider<SavingsNotifier, SavingsState>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return SavingsNotifier(
    SavingsGoalDao(db),
    SavingsTransactionDao(db),
    ref,
  );
});
