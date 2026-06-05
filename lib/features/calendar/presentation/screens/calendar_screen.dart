import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/calendar_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(calendarProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(calendarProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
              ? Center(child: Text('Error: ${state.error}'))
              : _buildContent(context, state, theme),
    );
  }

  Widget _buildContent(
      BuildContext context, CalendarState state, ThemeData theme) {
    final now = DateTime.now();
    final firstDay =
        DateTime(state.selectedYear, state.selectedMonth, 1);
    final lastDay =
        DateTime(state.selectedYear, state.selectedMonth + 1, 0);
    final daysInMonth = lastDay.day;
    final firstWeekday = firstDay.weekday; // 1=Mon ... 7=Sun

    return Column(
      children: [
        // Month/Year header with navigation
        _buildMonthHeader(state, theme),
        // Weekday labels
        _buildWeekdayLabels(theme),
        // Day grid
        Expanded(
          child: _buildDayGrid(
            context, state, theme, firstWeekday, daysInMonth, now, firstDay),
        ),
        // Today button
        Padding(
          padding: const EdgeInsets.all(12),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                ref.read(calendarProvider.notifier).goToToday();
              },
              icon: const Icon(Icons.today, size: 18),
              label: const Text('Today'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMonthHeader(CalendarState state, ThemeData theme) {
    final date = DateTime(state.selectedYear, state.selectedMonth);
    final monthYear = DateFormatter.formatMonthYear(date);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              ref.read(calendarProvider.notifier).previousMonth();
            },
          ),
          Text(
            monthYear,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              ref.read(calendarProvider.notifier).nextMonth();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWeekdayLabels(ThemeData theme) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: weekdays.map((day) {
          return Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  day,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.outline,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDayGrid(
    BuildContext context,
    CalendarState state,
    ThemeData theme,
    int firstWeekday,
    int daysInMonth,
    DateTime now,
    DateTime firstDay,
  ) {
    // Adjust for Sunday-based week (DateTime.sunday = 7)
    // We want Monday=0, so offset = firstWeekday - 1
    final leadingBlanks = firstWeekday - 1;

    final totalCells = leadingBlanks + daysInMonth;
    final rows = (totalCells / 7).ceil();

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 0.85,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
      ),
      itemCount: rows * 7,
      itemBuilder: (context, index) {
        final dayNumber = index - leadingBlanks + 1;
        if (dayNumber < 1 || dayNumber > daysInMonth) {
          return const SizedBox.shrink();
        }

        final date = DateTime(
          state.selectedYear, state.selectedMonth, dayNumber);
        final isToday = DateFormatter.isSameDay(date, now);
        final dayData = state.transactionsByDate[date];
        final hasIncome = dayData?.totalIncome != null && dayData!.totalIncome > 0;
        final hasExpense =
            dayData?.totalExpense != null && dayData!.totalExpense > 0;
        final isSunday = date.weekday == 7;

        return GestureDetector(
          onTap: () => _showDayTransactions(context, date, dayData, theme),
          child: Container(
            decoration: BoxDecoration(
              color: isToday
                  ? theme.colorScheme.primaryContainer
                  : null,
              borderRadius: BorderRadius.circular(8),
              border: isToday
                  ? Border.all(
                      color: theme.colorScheme.primary, width: 1.5)
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$dayNumber',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    color: isToday
                        ? theme.colorScheme.primary
                        : isSunday
                            ? Colors.redAccent
                            : null,
                  ),
                ),
                const SizedBox(height: 2),
                if (hasIncome || hasExpense)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (hasIncome)
                        _dot(Colors.green),
                      if (hasIncome && hasExpense)
                        const SizedBox(width: 3),
                      if (hasExpense)
                        _dot(Colors.red),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _dot(Color color) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  void _showDayTransactions(
    BuildContext context,
    DateTime date,
    DayTransactions? dayData,
    ThemeData theme,
  ) {
    if (dayData == null || dayData.transactions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No transactions on ${DateFormatter.formatFullDate(date)}',
          ),
          duration: const Duration(seconds: 1),
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.3,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    DateFormatter.formatFullDate(date),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (dayData.totalIncome > 0)
                        _summaryChip(
                          'Income: ${NumberFormatter.formatCurrency(dayData.totalIncome)}',
                          Colors.green,
                        ),
                      if (dayData.totalIncome > 0 && dayData.totalExpense > 0)
                        const SizedBox(width: 8),
                      if (dayData.totalExpense > 0)
                        _summaryChip(
                          'Expenses: ${NumberFormatter.formatCurrency(dayData.totalExpense)}',
                          Colors.red,
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: dayData.transactions.length,
                      itemBuilder: (ctx, i) {
                        final tx = dayData.transactions[i];
                        final isIncome = tx.type == 'income';
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isIncome
                                ? Colors.green.withOpacity(0.1)
                                : Colors.red.withOpacity(0.1),
                            child: Icon(
                              isIncome
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
                              color: isIncome ? Colors.green : Colors.red,
                              size: 20,
                            ),
                          ),
                          title: Text(tx.description),
                          subtitle: Text(tx.category),
                          trailing: Text(
                            '${isIncome ? '+' : '-'}${NumberFormatter.formatCurrency(tx.amount)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isIncome ? Colors.green : Colors.red,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _summaryChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
