import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../dashboard/presentation/providers/dashboard_provider.dart';
import '../../../../core/database/dao/all_daos.dart';
import '../../../../core/database/app_database.dart';
import '../../../../data/models/all_models.dart';

/// A single transaction entry displayed in the calendar.
class CalendarTransaction {
  final int id;
  final double amount;
  final String category;
  final String description;
  final String type; // 'income' or 'expense'

  CalendarTransaction({
    required this.id,
    required this.amount,
    required this.category,
    required this.description,
    required this.type,
  });
}

/// Transactions grouped by date for a calendar day.
class DayTransactions {
  final DateTime date;
  final List<CalendarTransaction> transactions;
  final double totalIncome;
  final double totalExpense;

  DayTransactions({
    required this.date,
    required this.transactions,
    this.totalIncome = 0,
    this.totalExpense = 0,
  });
}

/// Represents the calendar state.
class CalendarState {
  /// Transactions grouped by date for the selected month.
  final Map<DateTime, DayTransactions> transactionsByDate;

  final int selectedMonth;
  final int selectedYear;
  final bool isLoading;
  final String? error;

  const CalendarState({
    this.transactionsByDate = const {},
    this.selectedMonth = 0,
    this.selectedYear = 0,
    this.isLoading = false,
    this.error,
  });

  CalendarState copyWith({
    Map<DateTime, DayTransactions>? transactionsByDate,
    int? selectedMonth,
    int? selectedYear,
    bool? isLoading,
    String? error,
  }) {
    return CalendarState(
      transactionsByDate: transactionsByDate ?? this.transactionsByDate,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      selectedYear: selectedYear ?? this.selectedYear,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Notifier for the calendar view — returns transactions grouped by date.
class CalendarNotifier extends StateNotifier<CalendarState> {
  final IncomeDao _incomeDao;
  final ExpenseDao _expenseDao;

  CalendarNotifier(this._incomeDao, this._expenseDao)
      : super(const CalendarState());

  /// Load transactions for the given month/year.
  Future<void> load({int? month, int? year}) async {
    final now = DateTime.now();
    final targetMonth = month ?? now.month;
    final targetYear = year ?? now.year;

    state = state.copyWith(
      isLoading: true,
      error: null,
      selectedMonth: targetMonth,
      selectedYear: targetYear,
    );

    try {
      final results = await Future.wait([
        _incomeDao.getByMonth(targetMonth, targetYear),
        _expenseDao.getByMonth(targetMonth, targetYear),
      ]);

      final incomes = results[0] as List<IncomeModel>;
      final expenses = results[1] as List<ExpenseModel>;

      final grouped = <DateTime, List<CalendarTransaction>>{};

      // Normalize date to start of day for grouping
      DateTime normalizeDate(DateTime dt) =>
          DateTime(dt.year, dt.month, dt.day);

      // Add incomes
      for (final inc in incomes) {
        final key = normalizeDate(inc.date);
        grouped.putIfAbsent(key, () => []).add(CalendarTransaction(
              id: inc.id ?? 0,
              amount: inc.amount,
              category: inc.category,
              description: inc.description ?? 'Income',
              type: 'income',
            ));
      }

      // Add expenses
      for (final exp in expenses) {
        final key = normalizeDate(exp.date);
        grouped.putIfAbsent(key, () => []).add(CalendarTransaction(
              id: exp.id ?? 0,
              amount: exp.amount,
              category: exp.category,
              description: exp.description ?? 'Expense',
              type: 'expense',
            ));
      }

      // Build DayTransactions map
      final dayMap = <DateTime, DayTransactions>{};
      for (final entry in grouped.entries) {
        final txList = entry.value;
        double totalInc = 0;
        double totalExp = 0;
        for (final tx in txList) {
          if (tx.type == 'income') {
            totalInc += tx.amount;
          } else {
            totalExp += tx.amount;
          }
        }
        dayMap[entry.key] = DayTransactions(
          date: entry.key,
          transactions: txList,
          totalIncome: totalInc,
          totalExpense: totalExp,
        );
      }

      state = CalendarState(
        transactionsByDate: dayMap,
        selectedMonth: targetMonth,
        selectedYear: targetYear,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Navigate to the next month.
  Future<void> nextMonth() async {
    int m = state.selectedMonth + 1;
    int y = state.selectedYear;
    if (m > 12) {
      m = 1;
      y++;
    }
    await load(month: m, year: y);
  }

  /// Navigate to the previous month.
  Future<void> previousMonth() async {
    int m = state.selectedMonth - 1;
    int y = state.selectedYear;
    if (m < 1) {
      m = 12;
      y--;
    }
    await load(month: m, year: y);
  }

  /// Jump to today.
  Future<void> goToToday() async {
    final now = DateTime.now();
    await load(month: now.month, year: now.year);
  }
}

/// Provider for CalendarNotifier.
final calendarProvider =
    StateNotifierProvider<CalendarNotifier, CalendarState>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return CalendarNotifier(
    IncomeDao(db),
    ExpenseDao(db),
  );
});
