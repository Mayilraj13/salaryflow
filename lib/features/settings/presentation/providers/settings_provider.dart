import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/dao/all_daos.dart';
import '../../../dashboard/presentation/providers/dashboard_provider.dart';
import '../../../rent/presentation/providers/rent_provider.dart';



/// Represents the app settings state.
class SettingsState {
  final bool isDarkMode;
  final String currency;
  final String currencySymbol;
  final bool isPinEnabled;
  final String? pinHash;
  final bool areNotificationsEnabled;
  final double salaryAmount;
  final int salaryDate;
  final double rentAmount;
  final int rentDueDay;
  final bool isLoading;
  final String? error;
  final bool isFirstLaunch;

  const SettingsState({
    this.isDarkMode = false,
    this.currency = 'INR',
    this.currencySymbol = '₹',
    this.isPinEnabled = false,
    this.pinHash,
    this.areNotificationsEnabled = true,
    this.salaryAmount = 35000,
    this.salaryDate = 1,
    this.rentAmount = 8000,
    this.rentDueDay = 5,
    this.isLoading = false,
    this.error,
    this.isFirstLaunch = true,
  });

  SettingsState copyWith({
    bool? isDarkMode,
    String? currency,
    String? currencySymbol,
    bool? isPinEnabled,
    String? pinHash,
    bool? areNotificationsEnabled,
    double? salaryAmount,
    int? salaryDate,
    double? rentAmount,
    int? rentDueDay,
    bool? isLoading,
    String? error,
    bool? isFirstLaunch,
  }) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      currency: currency ?? this.currency,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      isPinEnabled: isPinEnabled ?? this.isPinEnabled,
      pinHash: pinHash ?? this.pinHash,
      areNotificationsEnabled: areNotificationsEnabled ?? this.areNotificationsEnabled,
      salaryAmount: salaryAmount ?? this.salaryAmount,
      salaryDate: salaryDate ?? this.salaryDate,
      rentAmount: rentAmount ?? this.rentAmount,
      rentDueDay: rentDueDay ?? this.rentDueDay,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isFirstLaunch: isFirstLaunch ?? this.isFirstLaunch,
    );
  }
}

/// Notifier for managing app settings (theme, currency, PIN, notifications).
class SettingsNotifier extends StateNotifier<SettingsState> {
  final SettingsDao _dao;
  final Ref _ref;

  SettingsNotifier(this._dao, this._ref) : super(const SettingsState(isLoading: true));

  /// Load all settings from the database.
  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final results = await Future.wait([
        _dao.get('dark_mode').then((v) => v == 'true'),
        _dao.get('currency'),
        _dao.get('pin_enabled'),
        _dao.get('pin_hash'),
        _dao.get('notifications_enabled'),
        _dao.get('salary_amount').then((v) => double.tryParse(v ?? '0') ?? 0),
        _dao.get('salary_date').then((v) => int.tryParse(v ?? '1') ?? 1),
        _dao.get('rent_amount').then((v) => double.tryParse(v ?? '0') ?? 0),
        _dao.get('rent_due_day').then((v) => int.tryParse(v ?? '1') ?? 1),
        _dao.get('first_launch').then((v) => v != 'false'),
      ]);

      final isDarkMode = results[0] as bool;
      final currency = (results[1] as String?) ?? 'INR';
      final isPinEnabled = (results[2] as String?) == 'true';
      final pinHash = results[3] as String?;
      final notifEnabled = (results[4] as String?) != 'false';
      final salaryAmount = results[5] as double;
      final salaryDate = results[6] as int;
      final rentAmount = results[7] as double;
      final rentDueDay = results[8] as int;
      final isFirstLaunch = results[9] as bool;

      // Determine currency symbol
      String symbol;
      switch (currency) {
        case 'USD':
          symbol = '\$';
          break;
        case 'EUR':
          symbol = '€';
          break;
        case 'GBP':
          symbol = '£';
          break;
        case 'JPY':
          symbol = '¥';
          break;
        default:
          symbol = '₹';
      }

      state = SettingsState(
        isDarkMode: isDarkMode,
        currency: currency,
        currencySymbol: symbol,
        isPinEnabled: isPinEnabled,
        pinHash: pinHash,
        areNotificationsEnabled: notifEnabled,
        salaryAmount: salaryAmount,
        salaryDate: salaryDate,
        rentAmount: rentAmount,
        rentDueDay: rentDueDay,
        isFirstLaunch: isFirstLaunch,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ─── Theme ────────────────────────────────────────────────

  /// Toggle dark mode.
  Future<void> toggleDarkMode() async {
    final newValue = !state.isDarkMode;
    try {
      await _dao.set('dark_mode', newValue.toString());
      state = state.copyWith(isDarkMode: newValue);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Set dark mode explicitly.
  Future<void> setDarkMode(bool value) async {
    try {
      await _dao.set('dark_mode', value.toString());
      state = state.copyWith(isDarkMode: value);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // ─── Currency ─────────────────────────────────────────────

  /// Update currency code and symbol.
  Future<void> setCurrency(String code) async {
    try {
      await _dao.set('currency', code);
      // Determine symbol
      String symbol;
      switch (code) {
        case 'USD':
          symbol = '\$';
          break;
        case 'EUR':
          symbol = '€';
          break;
        case 'GBP':
          symbol = '£';
          break;
        case 'JPY':
          symbol = '¥';
          break;
        default:
          symbol = '₹';
      }
      state = state.copyWith(currency: code, currencySymbol: symbol);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // ─── PIN ──────────────────────────────────────────────────

  /// Enable PIN.
  Future<bool> enablePin(String pinHash) async {
    try {
      await _dao.set('pin_enabled', 'true');
      await _dao.set('pin_hash', pinHash);
      state = state.copyWith(isPinEnabled: true, pinHash: pinHash);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Disable PIN.
  Future<bool> disablePin() async {
    try {
      await _dao.set('pin_enabled', 'false');
      await _dao.set('pin_hash', '');
      state = state.copyWith(isPinEnabled: false, pinHash: null);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Change PIN hash.
  Future<bool> changePin(String newPinHash) async {
    try {
      await _dao.set('pin_hash', newPinHash);
      state = state.copyWith(pinHash: newPinHash);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  // ─── Notifications ────────────────────────────────────────

  /// Toggle notifications.
  Future<void> toggleNotifications() async {
    final newValue = !state.areNotificationsEnabled;
    try {
      await _dao.set('notifications_enabled', newValue.toString());
      state = state.copyWith(areNotificationsEnabled: newValue);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Set notifications explicitly.
  Future<void> setNotifications(bool value) async {
    try {
      await _dao.set('notifications_enabled', value.toString());
      state = state.copyWith(areNotificationsEnabled: value);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // ─── Salary ───────────────────────────────────────────────

  /// Update salary amount.
  Future<void> setSalaryAmount(double amount) async {
    try {
      await _dao.set('salary_amount', amount.toString());
      state = state.copyWith(salaryAmount: amount);
      _invalidateDashboard();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Update salary date (day of month).
  Future<void> setSalaryDate(int day) async {
    try {
      await _dao.set('salary_date', day.toString());
      state = state.copyWith(salaryDate: day);
      _invalidateDashboard();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // ─── Rent ─────────────────────────────────────────────────

  /// Update rent amount.
  Future<void> setRentAmount(double amount) async {
    try {
      await _dao.set('rent_amount', amount.toString());
      state = state.copyWith(rentAmount: amount);
      
      final rentDao = RentDao(_ref.read(appDatabaseProvider));
      final currentRent = await rentDao.getCurrentMonth();
      if (currentRent != null && !currentRent.isPaid) {
        final companion = RentRecordsCompanion(
          id: Value(currentRent.id),
          amount: Value(amount),
        );
        await rentDao.update(companion);
      }

      _invalidateDashboard();
      _ref.invalidate(rentProvider);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Update rent due day.
  Future<void> setRentDueDay(int day) async {
    try {
      await _dao.set('rent_due_day', day.toString());
      state = state.copyWith(rentDueDay: day);

      final rentDao = RentDao(_ref.read(appDatabaseProvider));
      final currentRent = await rentDao.getCurrentMonth();
      if (currentRent != null && !currentRent.isPaid) {
        final newDueDate = DateTime(currentRent.year, currentRent.month, day);
        final companion = RentRecordsCompanion(
          id: Value(currentRent.id),
          dueDate: Value(newDueDate),
        );
        await rentDao.update(companion);
      }

      _invalidateDashboard();
      _ref.invalidate(rentProvider);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // ─── First Launch ─────────────────────────────────────────

  /// Mark first launch as done.
  Future<void> completeFirstLaunch() async {
    try {
      await _dao.set('first_launch', 'false');
      state = state.copyWith(isFirstLaunch: false);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void _invalidateDashboard() {
    _ref.invalidate(dashboardProvider);
  }
}

/// Provider for SettingsNotifier.
final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return SettingsNotifier(SettingsDao(db), ref);
});
