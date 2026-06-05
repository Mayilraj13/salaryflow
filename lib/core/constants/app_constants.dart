import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'SalaryFlow';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Personal Finance Tracker';

  // Currency
  static const String defaultCurrency = '₹';
  static const String currencySymbol = '₹';
  static const String currencyCode = 'INR';

  // Default Values
  static const double defaultSalary = 35000;
  static const double defaultRent = 8000;
  static const int defaultRentDueDay = 5;

  // Financial Health Score Ranges
  static const double healthExcellent = 80;
  static const double healthGood = 60;
  static const double healthAverage = 40;

  // Notification IDs
  static const int rentReminderNotificationId = 1;
  static const int salaryNotificationId = 2;
  static const int budgetExceededNotificationId = 3;
  static const int savingsReminderNotificationId = 4;

  // Shared Preferences Keys
  static const String prefPinEnabled = 'pin_enabled';
  static const String prefPinHash = 'pin_hash';
  static const String prefBiometricEnabled = 'biometric_enabled';
  static const String prefDarkMode = 'dark_mode';
  static const String prefSalaryAmount = 'salary_amount';
  static const String prefSalaryDate = 'salary_date';
  static const String prefRentAmount = 'rent_amount';
  static const String prefRentDueDay = 'rent_due_day';
  static const String prefCurrency = 'currency';
  static const String prefFirstLaunch = 'first_launch';

  // Database
  static const String databaseName = 'salaryflow.db';
  static const int databaseVersion = 1;

  // Animations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration fastAnimationDuration = Duration(milliseconds: 150);
  static const Duration slowAnimationDuration = Duration(milliseconds: 600);
}

class AppStrings {
  AppStrings._();

  // App
  static const String appTitle = 'SalaryFlow';
  static const String tagline = 'Your Personal Finance Tracker';

  // Navigation
  static const String navDashboard = 'Dashboard';
  static const String navIncome = 'Income';
  static const String navExpenses = 'Expenses';
  static const String navRent = 'Rent';
  static const String navSavings = 'Savings';
  static const String navAnalytics = 'Analytics';
  static const String navCalendar = 'Calendar';
  static const String navReports = 'Reports';
  static const String navSettings = 'Settings';

  // Dashboard
  static const String currentBalance = 'Current Balance';
  static const String monthlySalary = 'Monthly Salary';
  static const String totalExpenses = 'Total Expenses';
  static const String totalSavings = 'Total Savings';
  static const String healthScore = 'Financial Health';
  static const String daysUntilSalary = 'Days Until Salary';
  static const String todaySafeSpend = "Today's Safe Spend";
  static const String rentStatus = 'Room Rent Status';

  // Income
  static const String addIncome = 'Add Income';
  static const String editIncome = 'Edit Income';
  static const String deleteIncome = 'Delete Income';
  static const String incomeHistory = 'Income History';
  static const String monthlyIncome = 'Monthly Income';
  static const String totalIncome = 'Total Income';

  // Expense
  static const String addExpense = 'Add Expense';
  static const String editExpense = 'Edit Expense';
  static const String deleteExpense = 'Delete Expense';
  static const String expenseHistory = 'Expense History';
  static const String quickAdd = 'Quick Add';
  static const String searchExpense = 'Search Expenses';
  static const String filterExpense = 'Filter Expenses';

  // Rent
  static const String rentTitle = 'Room Rent';
  static const String rentPaid = 'Paid';
  static const String rentPending = 'Pending';
  static const String rentDueDate = 'Due Date';
  static const String rentAmount = 'Rent Amount';
  static const String markAsPaid = 'Mark as Paid';
  static const String rentHistory = 'Rent History';

  // Savings
  static const String savingsGoals = 'Savings Goals';
  static const String addGoal = 'Add Goal';
  static const String editGoal = 'Edit Goal';
  static const String targetAmount = 'Target Amount';
  static const String currentProgress = 'Current Progress';
  static const String progressPercentage = 'Progress';
  static const String estimatedCompletion = 'Estimated Completion';

  // Affordability
  static const String canIAfford = 'Can I Afford This?';
  static const String productName = 'Product Name';
  static const String productCost = 'Product Cost';
  static const String safeToBuy = 'Safe To Buy';
  static const String buyWithCaution = 'Buy With Caution';
  static const String notRecommended = 'Not Recommended';

  // Analytics
  static const String expenseBreakdown = 'Expense Breakdown';
  static const String spendingTrend = 'Spending Trend';
  static const String incomeTrend = 'Income Trend';
  static const String savingsGrowth = 'Savings Growth';
  static const String categoryDistribution = 'Category Distribution';

  // Reports
  static const String generatePDF = 'Generate PDF';
  static const String generateExcel = 'Generate Excel';
  static const String monthlySummary = 'Monthly Summary';
  static const String yearlySummary = 'Yearly Summary';

  // Calendar
  static const String calendarTitle = 'Calendar';

  // Settings
  static const String settings = 'Settings';
  static const String darkMode = 'Dark Mode';
  static const String lightMode = 'Light Mode';
  static const String pinSettings = 'PIN Settings';
  static const String notificationSettings = 'Notification Settings';
  static const String backupSettings = 'Backup Settings';
  static const String exportData = 'Export Data';
  static const String importData = 'Import Data';
  static const String about = 'About';

  // Error Messages
  static const String errorGeneral = 'Something went wrong';
  static const String errorSave = 'Failed to save data';
  static const String errorLoad = 'Failed to load data';
  static const String errorDelete = 'Failed to delete data';
  static const String errorInvalidAmount = 'Please enter a valid amount';
  static const String errorFieldRequired = 'This field is required';
  static const String errorNoData = 'No data available';

  // Success Messages
  static const String successSaved = 'Saved successfully';
  static const String successDeleted = 'Deleted successfully';
  static const String successExported = 'Exported successfully';
  static const String successImported = 'Imported successfully';
  static const String successBackup = 'Backup created successfully';
  static const String successRestore = 'Data restored successfully';

  // Empty States
  static const String noExpenses = 'No expenses yet';
  static const String noIncome = 'No income recorded yet';
  static const String noGoals = 'No savings goals yet';
  static const String noRent = 'No rent records yet';
  static const String noReflections = 'No reflections yet';
  static const String noTransactions = 'No transactions yet';
}
