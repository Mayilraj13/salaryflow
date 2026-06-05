import 'package:get_it/get_it.dart';
import '../database/app_database.dart';
import '../database/dao/all_daos.dart';
import '../services/security_service.dart';
import '../services/notification_service.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Database
  final db = AppDatabase();
  sl.registerLazySingleton<AppDatabase>(() => db);

  // DAOs
  sl.registerLazySingleton<IncomeDao>(() => IncomeDao(db));
  sl.registerLazySingleton<ExpenseDao>(() => ExpenseDao(db));
  sl.registerLazySingleton<RentDao>(() => RentDao(db));
  sl.registerLazySingleton<SavingsGoalDao>(() => SavingsGoalDao(db));
  sl.registerLazySingleton<SavingsTransactionDao>(
      () => SavingsTransactionDao(db));
  sl.registerLazySingleton<ReflectionDao>(() => ReflectionDao(db));
  sl.registerLazySingleton<SettingsDao>(() => SettingsDao(db));
  sl.registerLazySingleton<NotificationDao>(() => NotificationDao(db));

  // Services
  sl.registerLazySingleton<SecurityService>(() => SecurityService());
  sl.registerLazySingleton<NotificationService>(() => NotificationService());
}
