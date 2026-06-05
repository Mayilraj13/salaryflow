import 'package:drift/drift.dart';
import '../app_database.dart';

// ==========================================
// INCOME DAO
// ==========================================
class IncomeDao {
  final AppDatabase _db;
  IncomeDao(this._db);

  Future<List<IncomeRecord>> getAll() => _db.select(_db.incomeRecords).get();

  Future<List<IncomeRecord>> getByMonth(int month, int year) {
    return (_db.select(_db.incomeRecords)
      ..where((t) => t.date.year.equals(year) & t.date.month.equals(month))
      ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)])
    ).get();
  }

  Future<double> getTotalByMonth(int month, int year) async {
    final records = await getByMonth(month, year);
    return records.fold<double>(0, (sum, r) => sum + r.amount);
  }

  Future<double> getTotalByYear(int year) async {
    final records = await (_db.select(_db.incomeRecords)
      ..where((t) => t.date.year.equals(year))
    ).get();
    return records.fold<double>(0, (sum, r) => sum + r.amount);
  }

  Future<double> getTotalAll() async {
    final records = await _db.select(_db.incomeRecords).get();
    return records.fold<double>(0, (sum, r) => sum + r.amount);
  }

  Future<IncomeRecord> getById(int id) {
    return (_db.select(_db.incomeRecords)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<int> insert(Insertable<IncomeRecord> income) {
    return _db.into(_db.incomeRecords).insert(income);
  }

  Future<bool> update(Insertable<IncomeRecord> income) {
    return _db.update(_db.incomeRecords).replace(income);
  }

  Future<int> delete(int id) {
    return (_db.delete(_db.incomeRecords)..where((t) => t.id.equals(id))).go();
  }

  Future<List<IncomeRecord>> search(String query) {
    final pattern = '%$query%';
    return (_db.select(_db.incomeRecords)
      ..where((t) => t.description.like(pattern) | t.category.like(pattern) | t.source.like(pattern))
      ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)])
    ).get();
  }

  Future<List<IncomeRecord>> getByDateRange(DateTime start, DateTime end) {
    return (_db.select(_db.incomeRecords)
      ..where((t) => t.date.isBetweenValues(start, end))
      ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)])
    ).get();
  }
}

// ==========================================
// EXPENSE DAO
// ==========================================
class ExpenseDao {
  final AppDatabase _db;
  ExpenseDao(this._db);

  Future<List<ExpenseRecord>> getAll() => _db.select(_db.expenseRecords).get();

  Future<List<ExpenseRecord>> getByMonth(int month, int year) {
    return (_db.select(_db.expenseRecords)
      ..where((t) => t.date.year.equals(year) & t.date.month.equals(month))
      ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)])
    ).get();
  }

  Future<double> getTotalByMonth(int month, int year) async {
    final records = await getByMonth(month, year);
    return records.fold<double>(0, (sum, r) => sum + r.amount);
  }

  Future<double> getTotalByYear(int year) async {
    final records = await (_db.select(_db.expenseRecords)
      ..where((t) => t.date.year.equals(year))
    ).get();
    return records.fold<double>(0, (sum, r) => sum + r.amount);
  }

  Future<double> getTotalAll() async {
    final records = await _db.select(_db.expenseRecords).get();
    return records.fold<double>(0, (sum, r) => sum + r.amount);
  }

  Future<ExpenseRecord> getById(int id) {
    return (_db.select(_db.expenseRecords)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<int> insert(Insertable<ExpenseRecord> expense) {
    return _db.into(_db.expenseRecords).insert(expense);
  }

  Future<bool> update(Insertable<ExpenseRecord> expense) {
    return _db.update(_db.expenseRecords).replace(expense);
  }

  Future<int> delete(int id) {
    return (_db.delete(_db.expenseRecords)..where((t) => t.id.equals(id))).go();
  }

  Future<double> getCategoryTotalByMonth(String category, int month, int year) async {
    final records = await (_db.select(_db.expenseRecords)
      ..where((t) => t.category.equals(category) & t.date.year.equals(year) & t.date.month.equals(month))
    ).get();
    return records.fold<double>(0, (sum, r) => sum + r.amount);
  }

  Future<List<ExpenseRecord>> getByCategory(String category) {
    return (_db.select(_db.expenseRecords)
      ..where((t) => t.category.equals(category))
      ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)])
    ).get();
  }

  Future<List<ExpenseRecord>> search(String query) {
    final pattern = '%$query%';
    return (_db.select(_db.expenseRecords)
      ..where((t) => t.description.like(pattern) | t.category.like(pattern))
      ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)])
    ).get();
  }

  Future<Map<String, double>> getCategoryTotalsByMonth(int month, int year) async {
    final records = await getByMonth(month, year);
    final totals = <String, double>{};
    for (final r in records) {
      totals[r.category] = (totals[r.category] ?? 0) + r.amount;
    }
    return totals;
  }

  Future<List<ExpenseRecord>> getByDateRange(DateTime start, DateTime end) {
    return (_db.select(_db.expenseRecords)
      ..where((t) => t.date.isBetweenValues(start, end))
      ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)])
    ).get();
  }

  Future<Map<String, double>> getCategoryTotals() async {
    final records = await _db.select(_db.expenseRecords).get();
    final totals = <String, double>{};
    for (final r in records) {
      totals[r.category] = (totals[r.category] ?? 0) + r.amount;
    }
    return totals;
  }

  Future<double> getTodayTotal() async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1));
    final records = await (_db.select(_db.expenseRecords)
      ..where((t) => t.date.isBetweenValues(start, end))
    ).get();
    return records.fold<double>(0, (sum, r) => sum + r.amount);
  }
}

// ==========================================
// RENT DAO
// ==========================================
class RentDao {
  final AppDatabase _db;
  RentDao(this._db);

  Future<List<RentRecord>> getAll() => _db.select(_db.rentRecords).get();

  Future<RentRecord?> getByMonth(int month, int year) {
    return (_db.select(_db.rentRecords)
      ..where((t) => t.month.equals(month) & t.year.equals(year))
    ).getSingleOrNull();
  }

  Future<RentRecord> getById(int id) {
    return (_db.select(_db.rentRecords)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<bool> isPaid(int month, int year) async {
    final record = await getByMonth(month, year);
    return record?.isPaid ?? false;
  }

  Future<int> insert(Insertable<RentRecord> rent) {
    return _db.into(_db.rentRecords).insert(rent);
  }

  Future<bool> update(Insertable<RentRecord> rent) {
    return _db.update(_db.rentRecords).replace(rent);
  }

  Future<int> delete(int id) {
    return (_db.delete(_db.rentRecords)..where((t) => t.id.equals(id))).go();
  }

  Future<List<RentRecord>> getHistory() {
    return (_db.select(_db.rentRecords)
      ..orderBy([(t) => OrderingTerm(expression: t.year, mode: OrderingMode.desc),
                 (t) => OrderingTerm(expression: t.month, mode: OrderingMode.desc)])
    ).get();
  }

  Future<double> getTotalPaidByYear(int year) async {
    final records = await (_db.select(_db.rentRecords)
      ..where((t) => t.year.equals(year) & t.isPaid.equals(true))
    ).get();
    return records.fold<double>(0, (sum, r) => sum + r.amount);
  }

  Future<RentRecord?> getCurrentMonth() {
    final now = DateTime.now();
    return getByMonth(now.month, now.year);
  }

  Future<List<RentRecord>> getByYear(int year) {
    return (_db.select(_db.rentRecords)
      ..where((t) => t.year.equals(year))
      ..orderBy([(t) => OrderingTerm(expression: t.month, mode: OrderingMode.desc)])
    ).get();
  }
}

// ==========================================
// SAVINGS GOAL DAO
// ==========================================
class SavingsGoalDao {
  final AppDatabase _db;
  SavingsGoalDao(this._db);

  Future<List<SavingsGoal>> getAll() => _db.select(_db.savingsGoals).get();

  Future<List<SavingsGoal>> getActive() {
    return (_db.select(_db.savingsGoals)
      ..where((t) => t.isCompleted.equals(false))
    ).get();
  }

  Future<List<SavingsGoal>> getCompleted() {
    return (_db.select(_db.savingsGoals)
      ..where((t) => t.isCompleted.equals(true))
    ).get();
  }

  Future<SavingsGoal> getById(int id) {
    return (_db.select(_db.savingsGoals)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<double> getTotalSaved() async {
    final goals = await _db.select(_db.savingsGoals).get();
    return goals.fold<double>(0, (sum, g) => sum + g.currentAmount);
  }

  Future<double> getTotalTarget() async {
    final goals = await _db.select(_db.savingsGoals).get();
    return goals.fold<double>(0, (sum, g) => sum + g.targetAmount);
  }

  Future<int> insert(Insertable<SavingsGoal> goal) {
    return _db.into(_db.savingsGoals).insert(goal);
  }

  Future<bool> update(Insertable<SavingsGoal> goal) {
    return _db.update(_db.savingsGoals).replace(goal);
  }

  Future<int> delete(int id) {
    return (_db.delete(_db.savingsGoals)..where((t) => t.id.equals(id))).go();
  }
}

// ==========================================
// SAVINGS TRANSACTION DAO
// ==========================================
class SavingsTransactionDao {
  final AppDatabase _db;
  SavingsTransactionDao(this._db);

  Future<List<SavingsTransaction>> getByGoal(int goalId) {
    return (_db.select(_db.savingsTransactions)
      ..where((t) => t.goalId.equals(goalId))
      ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)])
    ).get();
  }

  Future<List<SavingsTransaction>> getAll() => _db.select(_db.savingsTransactions).get();

  Future<List<SavingsTransaction>> getByMonth(int month, int year) {
    return (_db.select(_db.savingsTransactions)
      ..where((t) => t.date.year.equals(year) & t.date.month.equals(month))
      ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)])
    ).get();
  }

  Future<int> insert(Insertable<SavingsTransaction> tx) {
    return _db.into(_db.savingsTransactions).insert(tx);
  }
}

// ==========================================
// REFLECTION DAO
// ==========================================
class ReflectionDao {
  final AppDatabase _db;
  ReflectionDao(this._db);

  Future<List<MonthlyReflection>> getAll() => _db.select(_db.monthlyReflections).get();

  Future<MonthlyReflection?> getByMonth(int month, int year) {
    return (_db.select(_db.monthlyReflections)
      ..where((t) => t.month.equals(month) & t.year.equals(year))
    ).getSingleOrNull();
  }

  Future<int> insert(Insertable<MonthlyReflection> reflection) {
    return _db.into(_db.monthlyReflections).insert(reflection);
  }

  Future<bool> update(Insertable<MonthlyReflection> reflection) {
    return _db.update(_db.monthlyReflections).replace(reflection);
  }
}

// ==========================================
// SETTINGS DAO
// ==========================================
class SettingsDao {
  final AppDatabase _db;
  SettingsDao(this._db);

  Future<String?> get(String key) async {
    final result = await (_db.select(_db.appSettings)
      ..where((t) => t.key.equals(key))
    ).getSingleOrNull();
    return result?.value;
  }

  Future<void> set(String key, String value) async {
    final existing = await (_db.select(_db.appSettings)
      ..where((t) => t.key.equals(key))
    ).getSingleOrNull();
    if (existing != null) {
      await _db.update(_db.appSettings).replace(AppSettingsCompanion(
        key: Value(key),
        value: Value(value),
        updatedAt: Value(DateTime.now()),
      ));
    } else {
      await _db.into(_db.appSettings).insert(AppSettingsCompanion.insert(
        key: key,
        value: value,
      ));
    }
  }

  Future<void> setMultiple(Map<String, String> entries) async {
    for (final entry in entries.entries) {
      await set(entry.key, entry.value);
    }
  }

  Future<Map<String, String>> getAll() async {
    final rows = await _db.select(_db.appSettings).get();
    return {for (final r in rows) r.key: r.value};
  }

  Future<void> delete(String key) async {
    await (_db.delete(_db.appSettings)..where((t) => t.key.equals(key))).go();
  }
}

// ==========================================
// NOTIFICATION DAO
// ==========================================
class NotificationDao {
  final AppDatabase _db;
  NotificationDao(this._db);

  Future<List<AppNotification>> getAll() {
    return (_db.select(_db.appNotifications)
      ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)])
    ).get();
  }

  Future<List<AppNotification>> getUnread() {
    return (_db.select(_db.appNotifications)
      ..where((t) => t.isRead.equals(false))
      ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)])
    ).get();
  }

  Future<int> getUnreadCount() async {
    final records = await getUnread();
    return records.length;
  }

  Future<int> insert(Insertable<AppNotification> notification) {
    return _db.into(_db.appNotifications).insert(notification);
  }

  Future<int> clearAll() {
    return _db.delete(_db.appNotifications).go();
  }

  Future<void> markAsRead(int id) async {
    await (_db.update(_db.appNotifications)..where((t) => t.id.equals(id)))
      .write(AppNotificationsCompanion(isRead: Value(true)));
  }

  Future<void> markAllAsRead() async {
    await _db.update(_db.appNotifications)
      .write(AppNotificationsCompanion(isRead: Value(true)));
  }
}
