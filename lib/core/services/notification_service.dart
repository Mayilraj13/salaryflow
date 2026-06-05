import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../core/constants/app_constants.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;

  NotificationService() : _plugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    if (_initialized) return;
    
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _plugin.initialize(settings);
    _initialized = true;
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_initialized) await initialize();
    
    const androidDetails = AndroidNotificationDetails(
      'salaryflow_channel',
      'SalaryFlow Notifications',
      channelDescription: 'Notifications for salary, rent, budget updates',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    await _plugin.show(id, title, body, details, payload: payload);
  }

  Future<void> showRentDueReminder(DateTime dueDate) async {
    await showNotification(
      id: AppConstants.rentReminderNotificationId,
      title: 'Rent Due Reminder',
      body: 'Your rent is due on ${dueDate.day}/${dueDate.month}/${dueDate.year}',
    );
  }

  Future<void> showSalaryExpected() async {
    await showNotification(
      id: AppConstants.salaryNotificationId,
      title: 'Salary Expected',
      body: 'Your salary is expected tomorrow!',
    );
  }

  Future<void> showBudgetExceeded(double budget, double spent) async {
    await showNotification(
      id: AppConstants.budgetExceededNotificationId,
      title: 'Budget Exceeded',
      body: 'You have exceeded your daily budget of ₹${budget.toStringAsFixed(0)}. Spent: ₹${spent.toStringAsFixed(0)}',
    );
  }

  Future<void> showSavingsReminder(String goalName) async {
    await showNotification(
      id: AppConstants.savingsReminderNotificationId,
      title: 'Savings Goal Reminder',
      body: 'Don\'t forget to contribute to your goal: $goalName',
    );
  }

  Future<void> scheduleRentReminder(DateTime dueDate) async {
    // For offline scheduling, we schedule a one-time notification
    // In production, use android_alarm_manager or workmanager
    await showRentDueReminder(dueDate);
  }

  Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id);
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
