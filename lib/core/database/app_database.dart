import 'dart:io';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:drift/drift.dart';
import 'tables/all_tables.dart';
import '../../core/constants/app_constants.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    IncomeRecords,
    ExpenseRecords,
    RentRecords,
    SavingsGoals,
    SavingsTransactions,
    MonthlyReflections,
    AppSettings,
    AppNotifications,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => AppConstants.databaseVersion;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
        await _insertDefaultSettings();
      },
      onUpgrade: (m, from, to) async {
        // Handle future migrations here
      },
    );
  }

  Future<void> _insertDefaultSettings() async {
    await batch((batch) {
      batch.insertAll(
        appSettings,
        [
          AppSettingsCompanion.insert(
            key: 'salary_amount',
            value: AppConstants.defaultSalary.toString(),
          ),
          AppSettingsCompanion.insert(
            key: 'salary_date',
            value: '1',
          ),
          AppSettingsCompanion.insert(
            key: 'rent_amount',
            value: AppConstants.defaultRent.toString(),
          ),
          AppSettingsCompanion.insert(
            key: 'rent_due_day',
            value: AppConstants.defaultRentDueDay.toString(),
          ),
          AppSettingsCompanion.insert(
            key: 'currency',
            value: AppConstants.currencyCode,
          ),
          AppSettingsCompanion.insert(
            key: 'dark_mode',
            value: 'false',
          ),
          AppSettingsCompanion.insert(
            key: 'pin_enabled',
            value: 'false',
          ),
          AppSettingsCompanion.insert(
            key: 'first_launch',
            value: 'true',
          ),
        ],
      );
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, AppConstants.databaseName));
    return NativeDatabase(file);
  });
}
