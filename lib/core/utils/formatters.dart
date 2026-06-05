import 'package:intl/intl.dart';

class NumberFormatter {
  static final _currencyFormat = NumberFormat.currency(
    symbol: '₹',
    decimalDigits: 0,
    locale: 'en_IN',
  );

  static final _compactFormat = NumberFormat.compact(
    locale: 'en_IN',
  );

  static final _numberFormat = NumberFormat('#,##0', 'en_IN');
  static final _decimalFormat = NumberFormat('#,##0.00', 'en_IN');

  static String formatCurrency(double amount) {
    return _currencyFormat.format(amount);
  }

  static String formatCompact(double amount) {
    return '₹${_compactFormat.format(amount)}';
  }

  static String formatNumber(double amount) {
    return _numberFormat.format(amount);
  }

  static String formatDecimal(double amount) {
    return _decimalFormat.format(amount);
  }

  static String formatPercentage(double value) {
    return '${value.toStringAsFixed(1)}%';
  }
}

class DateFormatter {
  static final _dateFormat = DateFormat('dd MMM yyyy');
  static final _dayFormat = DateFormat('dd');
  static final _monthFormat = DateFormat('MMM');
  static final _yearFormat = DateFormat('yyyy');
  static final _monthYearFormat = DateFormat('MMM yyyy');
  static final _fullDateFormat = DateFormat('EEEE, dd MMMM yyyy');
  static final _timeFormat = DateFormat('hh:mm a');
  static final _dateTimeFormat = DateFormat('dd MMM yyyy, hh:mm a');

  static String formatDate(DateTime date) => _dateFormat.format(date);
  static String formatDay(DateTime date) => _dayFormat.format(date);
  static String formatMonth(DateTime date) => _monthFormat.format(date);
  static String formatYear(DateTime date) => _yearFormat.format(date);
  static String formatMonthYear(DateTime date) => _monthYearFormat.format(date);
  static String formatFullDate(DateTime date) => _fullDateFormat.format(date);
  static String formatTime(DateTime date) => _timeFormat.format(date);
  static String formatDateTime(DateTime date) => _dateTimeFormat.format(date);

  static String getRelativeDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return 'Today';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else if (diff.inDays < 30) {
      final weeks = (diff.inDays / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else if (diff.inDays < 365) {
      final months = (diff.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else {
      final years = (diff.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    }
  }

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static bool isCurrentMonth(DateTime date) {
    final now = DateTime.now();
    return date.month == now.month && date.year == now.year;
  }

  static int daysUntil(DateTime target) {
    final now = DateTime.now();
    return target.difference(DateTime(now.year, now.month, now.day)).inDays;
  }

  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  static DateTime endOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0);
  }

  static List<DateTime> getDaysInMonth(DateTime date) {
    final first = startOfMonth(date);
    final last = endOfMonth(date);
    final days = <DateTime>[];
    for (var i = 0; i < last.day; i++) {
      days.add(DateTime(first.year, first.month, i + 1));
    }
    return days;
  }
}

class AmountValidator {
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an amount';
    }
    final amount = double.tryParse(value);
    if (amount == null || amount <= 0) {
      return 'Please enter a valid amount greater than 0';
    }
    return null;
  }
}
