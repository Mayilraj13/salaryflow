import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/dao/all_daos.dart';
import '../../../../core/database/app_database.dart';
import '../../../../data/models/all_models.dart';
import '../../../dashboard/presentation/providers/dashboard_provider.dart';

/// A unified search result item across all entity types.
class SearchResult {
  final int id;
  final String title;
  final String subtitle;
  final double amount;
  final String type; // 'income', 'expense', 'rent', 'savings'
  final DateTime date;

  SearchResult({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.type,
    required this.date,
  });
}

/// Date range for filtering search results.
class SearchDateRange {
  final DateTime? start;
  final DateTime? end;

  const SearchDateRange({this.start, this.end});
}

/// Search filter criteria.
class SearchFilter {
  final SearchDateRange dateRange;
  final String? category;
  final double? minAmount;
  final double? maxAmount;
  final String? type; // 'income', 'expense', 'rent', 'savings', or null for all

  const SearchFilter({
    this.dateRange = const SearchDateRange(),
    this.category,
    this.minAmount,
    this.maxAmount,
    this.type,
  });

  SearchFilter copyWith({
    SearchDateRange? dateRange,
    String? category,
    double? minAmount,
    double? maxAmount,
    String? type,
    bool clearCategory = false,
    bool clearType = false,
  }) {
    return SearchFilter(
      dateRange: dateRange ?? this.dateRange,
      category: clearCategory ? null : (category ?? this.category),
      minAmount: minAmount ?? this.minAmount,
      maxAmount: maxAmount ?? this.maxAmount,
      type: clearType ? null : (type ?? this.type),
    );
  }

  bool get hasActiveFilters =>
      dateRange.start != null ||
      dateRange.end != null ||
      category != null ||
      minAmount != null ||
      maxAmount != null ||
      type != null;
}

/// State for the search feature.
class SearchState {
  final String query;
  final List<SearchResult> results;
  final bool isLoading;
  final String? error;
  final SearchFilter filter;
  final int resultCount;

  const SearchState({
    this.query = '',
    this.results = const [],
    this.isLoading = false,
    this.error,
    this.filter = const SearchFilter(),
    this.resultCount = 0,
  });

  SearchState copyWith({
    String? query,
    List<SearchResult>? results,
    bool? isLoading,
    String? error,
    SearchFilter? filter,
    int? resultCount,
  }) {
    return SearchState(
      query: query ?? this.query,
      results: results ?? this.results,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      filter: filter ?? this.filter,
      resultCount: resultCount ?? this.resultCount,
    );
  }
}

/// Notifier for search across all entities (income, expense, rent, savings).
class SearchNotifier extends StateNotifier<SearchState> {
  final IncomeDao _incomeDao;
  final ExpenseDao _expenseDao;
  final RentDao _rentDao;
  final SavingsGoalDao _savingsGoalDao;

  SearchNotifier(
    this._incomeDao,
    this._expenseDao,
    this._rentDao,
    this._savingsGoalDao,
  ) : super(const SearchState());

  /// Execute a search with the given query string.
  Future<void> search(String query) async {
    state = state.copyWith(isLoading: true, query: query, error: null);
    try {
      final results = <SearchResult>[];

      if (query.trim().isEmpty) {
        state = SearchState(query: query);
        return;
      }

      // Search across all entities concurrently
      final futures = await Future.wait([
        _incomeDao.search(query),
        _expenseDao.search(query),
      ]);

      // Income results
      final incomeResults = futures[0] as List<IncomeModel>;
      for (final inc in incomeResults) {
        results.add(SearchResult(
          id: inc.id ?? 0,
          title: inc.category,
          subtitle: inc.description ?? inc.source ?? 'Income',
          amount: inc.amount,
          type: 'income',
          date: inc.date,
        ));
      }

      // Expense results
      final expenseResults = futures[1] as List<ExpenseModel>;
      for (final exp in expenseResults) {
        results.add(SearchResult(
          id: exp.id ?? 0,
          title: exp.category,
          subtitle: exp.description ?? 'Expense',
          amount: exp.amount,
          type: 'expense',
          date: exp.date,
        ));
      }

      // Search rent records by notes/landlordNotes
      final allRent = await _rentDao.getAll();
      final q = query.toLowerCase();
      for (final rent in allRent) {
        if ((rent.notes?.toLowerCase().contains(q) ?? false) ||
            (rent.landlordNotes?.toLowerCase().contains(q) ?? false)) {
          results.add(SearchResult(
            id: rent.id ?? 0,
            title: 'Rent — ${rent.month}/${rent.year}',
            subtitle: rent.isPaid ? 'Paid' : 'Pending',
            amount: rent.amount,
            type: 'rent',
            date: rent.dueDate,
          ));
        }
      }

      // Search savings goals
      final allGoals = await _savingsGoalDao.getAll();
      for (final goal in allGoals) {
        if (goal.name.toLowerCase().contains(q) ||
            (goal.notes?.toLowerCase().contains(q) ?? false)) {
          results.add(SearchResult(
            id: goal.id ?? 0,
            title: goal.name,
            subtitle: '₹${goal.currentAmount.toStringAsFixed(0)} / ₹${goal.targetAmount.toStringAsFixed(0)}',
            amount: goal.currentAmount,
            type: 'savings',
            date: goal.createdAt ?? DateTime.now(),
          ));
        }
      }

      // Apply filters
      var filtered = results;
      final filter = state.filter;
      if (filter.hasActiveFilters) {
        if (filter.dateRange.start != null) {
          filtered = filtered
              .where((r) => r.date.isAfter(filter.dateRange.start!.subtract(const Duration(days: 1))))
              .toList();
        }
        if (filter.dateRange.end != null) {
          filtered = filtered
              .where((r) => r.date.isBefore(filter.dateRange.end!.add(const Duration(days: 1))))
              .toList();
        }
        if (filter.category != null) {
          filtered = filtered
              .where((r) => r.title.toLowerCase().contains(filter.category!.toLowerCase()))
              .toList();
        }
        if (filter.minAmount != null) {
          filtered = filtered.where((r) => r.amount >= filter.minAmount!).toList();
        }
        if (filter.maxAmount != null) {
          filtered = filtered.where((r) => r.amount <= filter.maxAmount!).toList();
        }
        if (filter.type != null) {
          filtered = filtered.where((r) => r.type == filter.type).toList();
        }
      }

      final sorted = filtered..sort((a, b) => b.date.compareTo(a.date));

      state = SearchState(
        query: query,
        results: sorted,
        filter: filter,
        resultCount: sorted.length,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Set a date range filter.
  Future<void> filterByDateRange(DateTime? start, DateTime? end) async {
    state = state.copyWith(
      filter: state.filter.copyWith(
        dateRange: SearchDateRange(start: start, end: end),
      ),
    );
    if (state.query.isNotEmpty) {
      await search(state.query);
    }
  }

  /// Set a category filter.
  Future<void> filterByCategory(String? category) async {
    state = state.copyWith(
      filter: state.filter.copyWith(
        category: category,
        clearCategory: category == null,
      ),
    );
    if (state.query.isNotEmpty) {
      await search(state.query);
    }
  }

  /// Set amount range filter.
  Future<void> filterByAmount(double? min, double? max) async {
    state = state.copyWith(
      filter: state.filter.copyWith(
        minAmount: min,
        maxAmount: max,
      ),
    );
    if (state.query.isNotEmpty) {
      await search(state.query);
    }
  }

  /// Filter by entity type.
  Future<void> filterByType(String? type) async {
    state = state.copyWith(
      filter: state.filter.copyWith(
        type: type,
        clearType: type == null,
      ),
    );
    if (state.query.isNotEmpty) {
      await search(state.query);
    }
  }

  /// Clear all active filters and re-search.
  Future<void> clearFilters() async {
    state = state.copyWith(filter: const SearchFilter());
    if (state.query.isNotEmpty) {
      await search(state.query);
    }
  }

  /// Clear the search state entirely.
  void clearSearch() {
    state = const SearchState();
  }
}

/// Provider for SearchNotifier.
final searchProvider =
    StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return SearchNotifier(
    IncomeDao(db),
    ExpenseDao(db),
    RentDao(db),
    SavingsGoalDao(db),
  );
});
