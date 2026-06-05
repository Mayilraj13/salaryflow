import 'package:drift/drift.dart';

// ==========================================
// INCOME TABLE
// ==========================================
class IncomeRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get amount => real()();
  TextColumn get category => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get description => text().nullable()();
  TextColumn get source => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// ==========================================
// EXPENSE TABLE
// ==========================================
class ExpenseRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get amount => real()();
  TextColumn get category => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get description => text().nullable()();
  TextColumn get paymentMethod => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get receiptImagePath => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// ==========================================
// RENT TABLE
// ==========================================
class RentRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get amount => real()();
  DateTimeColumn get dueDate => dateTime()();
  DateTimeColumn get paidDate => dateTime().nullable()();
  BoolColumn get isPaid => boolean().withDefault(const Constant(false))();
  TextColumn get notes => text().nullable()();
  TextColumn get landlordNotes => text().nullable()();
  IntColumn get month => integer()();
  IntColumn get year => integer()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// ==========================================
// SAVINGS GOALS TABLE
// ==========================================
class SavingsGoals extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  RealColumn get targetAmount => real()();
  RealColumn get currentAmount => real().withDefault(const Constant(0))();
  DateTimeColumn get targetDate => dateTime().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get colorHex => text().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// ==========================================
// SAVINGS TRANSACTIONS TABLE
// ==========================================
class SavingsTransactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get goalId => integer().references(SavingsGoals, #id)();
  RealColumn get amount => real()();
  TextColumn get type => text()(); // 'deposit' or 'withdrawal'
  DateTimeColumn get date => dateTime()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// ==========================================
// MONTHLY REFLECTIONS TABLE
// ==========================================
class MonthlyReflections extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get month => integer()();
  IntColumn get year => integer()();
  TextColumn get wentWell => text().nullable()();
  TextColumn get canImprove => text().nullable()();
  TextColumn get biggestExpense => text().nullable()();
  TextColumn get bestDecision => text().nullable()();
  RealColumn get totalIncome => real().nullable()();
  RealColumn get totalExpenses => real().nullable()();
  RealColumn get totalSavings => real().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// ==========================================
// SETTINGS TABLE
// ==========================================
class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {key};
}

// ==========================================
// NOTIFICATIONS TABLE
// ==========================================
class AppNotifications extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get body => text()();
  TextColumn get type => text()();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
