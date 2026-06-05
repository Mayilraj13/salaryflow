import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/search_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/constants/app_constants.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  String _selectedType = 'All';

  final _typeFilters = ['All', 'Income', 'Expense', 'Rent', 'Savings'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _onSearch(String query) async {
    await ref.read(searchProvider.notifier).search(query);
  }

  Future<void> _onTypeFilter(String type) async {
    setState(() => _selectedType = type);
    final notifier = ref.read(searchProvider.notifier);
    if (type == 'All') {
      await notifier.filterByType(null);
    } else {
      await notifier.filterByType(type.toLowerCase());
    }
  }

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final start = await showDatePicker(
      context: context,
      initialDate: now.subtract(const Duration(days: 30)),
      firstDate: DateTime(2020),
      lastDate: now,
      helpText: 'Select start date',
    );
    if (start == null || !mounted) return;

    final end = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: start,
      lastDate: now,
      helpText: 'Select end date',
    );
    if (end == null || !mounted) return;

    await ref
        .read(searchProvider.notifier)
        .filterByDateRange(start, end);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search transactions...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(searchProvider.notifier).clearSearch();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (query) {
                if (query.trim().isEmpty) {
                  ref.read(searchProvider.notifier).clearSearch();
                } else {
                  _onSearch(query);
                }
              },
              textInputAction: TextInputAction.search,
              onSubmitted: _onSearch,
            ),
          ),

          // Filter chips row
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                ..._typeFilters.map((type) {
                  final isSelected = _selectedType == type;
                  Color chipColor;
                  switch (type) {
                    case 'Income':
                      chipColor = Colors.green;
                      break;
                    case 'Expense':
                      chipColor = Colors.red;
                      break;
                    case 'Rent':
                      chipColor = Colors.orange;
                      break;
                    case 'Savings':
                      chipColor = Colors.blue;
                      break;
                    default:
                      chipColor = theme.colorScheme.primary;
                  }
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(type),
                      selected: isSelected,
                      onSelected: (_) => _onTypeFilter(type),
                      selectedColor: chipColor.withOpacity(0.2),
                      checkmarkColor: chipColor,
                    ),
                  );
                }),
                // Date range button
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ActionChip(
                    avatar: const Icon(Icons.date_range, size: 18),
                    label: const Text('Date Range'),
                    onPressed: _pickDateRange,
                  ),
                ),
                // Clear filters
                if (state.filter.hasActiveFilters || _selectedType != 'All')
                  ActionChip(
                    avatar: const Icon(Icons.clear_all, size: 18),
                    label: const Text('Clear'),
                    onPressed: () async {
                      setState(() => _selectedType = 'All');
                      await ref
                          .read(searchProvider.notifier)
                          .clearFilters();
                    },
                  ),
              ],
            ),
          ),

          // Active filter indicator
          if (state.filter.hasActiveFilters ||
              state.filter.dateRange.start != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  if (state.filter.dateRange.start != null &&
                      state.filter.dateRange.end != null)
                    Chip(
                      avatar: const Icon(Icons.date_range, size: 16),
                      label: Text(
                        '${DateFormatter.formatDate(state.filter.dateRange.start!)} - ${DateFormatter.formatDate(state.filter.dateRange.end!)}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () async {
                        await ref
                            .read(searchProvider.notifier)
                            .filterByDateRange(null, null);
                      },
                    ),
                ],
              ),
            ),

          const Divider(height: 1),

          // Results count
          if (!state.isLoading && state.query.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                '${state.resultCount} result${state.resultCount == 1 ? '' : 's'} found',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ),

          // Loading / Empty / Results
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.query.isEmpty
                    ? _buildEmptyState(theme)
                    : state.results.isEmpty
                        ? _buildNoResults(theme)
                        : _buildResultsList(state, theme),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search, size: 64, color: theme.colorScheme.outline),
          const SizedBox(height: 16),
          Text(
            'Search your transactions',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Find income, expenses, rent, and savings',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, size: 64, color: theme.colorScheme.outline),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different search term or filter',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsList(SearchState state, ThemeData theme) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: state.results.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final result = state.results[index];
        return _buildResultTile(result, theme);
      },
    );
  }

  Widget _buildResultTile(dynamic result, ThemeData theme) {
    Color typeColor;
    IconData typeIcon;
    switch (result.type) {
      case 'income':
        typeColor = Colors.green;
        typeIcon = Icons.arrow_downward;
        break;
      case 'expense':
        typeColor = Colors.red;
        typeIcon = Icons.arrow_upward;
        break;
      case 'rent':
        typeColor = Colors.orange;
        typeIcon = Icons.home;
        break;
      case 'savings':
        typeColor = Colors.blue;
        typeIcon = Icons.savings;
        break;
      default:
        typeColor = Colors.grey;
        typeIcon = Icons.help_outline;
    }

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: typeColor.withOpacity(0.1),
        child: Icon(typeIcon, color: typeColor, size: 20),
      ),
      title: Text(
        result.title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(result.subtitle),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${result.type == 'income' ? '+' : result.type == 'expense' ? '-' : ''}${NumberFormatter.formatCurrency(result.amount)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: typeColor,
            ),
          ),
          Text(
            DateFormatter.formatDate(result.date),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
      onTap: () {
        // In a full implementation this would navigate to detail/edit
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${result.type}: ${result.title} — ${NumberFormatter.formatCurrency(result.amount)}'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
    );
  }
}
