
class IncomeModel {
  final int? id;
  final double amount;
  final String category;
  final DateTime date;
  final String? description;
  final String? source;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  IncomeModel({
    this.id,
    required this.amount,
    required this.category,
    required this.date,
    this.description,
    this.source,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'amount': amount,
    'category': category,
    'date': date.toIso8601String(),
    'description': description,
    'source': source,
    'notes': notes,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };

  factory IncomeModel.fromMap(Map<String, dynamic> map) => IncomeModel(
    id: map['id'] as int?,
    amount: (map['amount'] as num).toDouble(),
    category: map['category'] as String,
    date: DateTime.parse(map['date'] as String),
    description: map['description'] as String?,
    source: map['source'] as String?,
    notes: map['notes'] as String?,
    createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt'] as String) : null,
    updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt'] as String) : null,
  );
}

class ExpenseModel {
  final int? id;
  final double amount;
  final String category;
  final DateTime date;
  final String? description;
  final String? paymentMethod;
  final String? notes;
  final String? receiptImagePath;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ExpenseModel({
    this.id,
    required this.amount,
    required this.category,
    required this.date,
    this.description,
    this.paymentMethod,
    this.notes,
    this.receiptImagePath,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'amount': amount,
    'category': category,
    'date': date.toIso8601String(),
    'description': description,
    'paymentMethod': paymentMethod,
    'notes': notes,
    'receiptImagePath': receiptImagePath,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };

  factory ExpenseModel.fromMap(Map<String, dynamic> map) => ExpenseModel(
    id: map['id'] as int?,
    amount: (map['amount'] as num).toDouble(),
    category: map['category'] as String,
    date: DateTime.parse(map['date'] as String),
    description: map['description'] as String?,
    paymentMethod: map['paymentMethod'] as String?,
    notes: map['notes'] as String?,
    receiptImagePath: map['receiptImagePath'] as String?,
    createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt'] as String) : null,
    updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt'] as String) : null,
  );

  static const List<String> categories = [
    'Room Rent', 'Food', 'Travel', 'Shopping', 'Electricity',
    'Internet', 'Mobile Recharge', 'Training Materials',
    'Project Components', 'Medical', 'Entertainment',
    'Tea', 'Emergency', 'Others',
  ];
}

class RentModel {
  final int? id;
  final double amount;
  final DateTime dueDate;
  final DateTime? paidDate;
  final bool isPaid;
  final String? notes;
  final String? landlordNotes;
  final int month;
  final int year;
  final DateTime? createdAt;

  RentModel({
    this.id,
    required this.amount,
    required this.dueDate,
    this.paidDate,
    this.isPaid = false,
    this.notes,
    this.landlordNotes,
    required this.month,
    required this.year,
    this.createdAt,
  });

  RentModel copyWith({bool? isPaid, DateTime? paidDate}) => RentModel(
    id: id,
    amount: amount,
    dueDate: dueDate,
    paidDate: paidDate ?? this.paidDate,
    isPaid: isPaid ?? this.isPaid,
    notes: notes,
    landlordNotes: landlordNotes,
    month: month,
    year: year,
    createdAt: createdAt,
  );
}

class SavingsGoalModel {
  final int? id;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final DateTime? targetDate;
  final String? notes;
  final String? colorHex;
  final bool isCompleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SavingsGoalModel({
    this.id,
    required this.name,
    required this.targetAmount,
    this.currentAmount = 0,
    this.targetDate,
    this.notes,
    this.colorHex,
    this.isCompleted = false,
    this.createdAt,
    this.updatedAt,
  });

  double get progress => targetAmount > 0 ? (currentAmount / targetAmount) * 100 : 0;

  SavingsGoalModel copyWith({double? currentAmount, bool? isCompleted}) => SavingsGoalModel(
    id: id,
    name: name,
    targetAmount: targetAmount,
    currentAmount: currentAmount ?? this.currentAmount,
    targetDate: targetDate,
    notes: notes,
    colorHex: colorHex,
    isCompleted: isCompleted ?? this.isCompleted,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

/// Result of an affordability check.
class AffordabilityResult {
  final String productName;
  final double productCost;
  final AffordabilityStatus status;
  final String reason;

  AffordabilityResult({
    required this.productName,
    required this.productCost,
    required this.status,
    required this.reason,
  });
}

/// Status recommendation for an affordability check.
enum AffordabilityStatus {
  safe,
  caution,
  notRecommended,
}

class FinancialHealthScore {
  final double score;
  final String label;
  final String emoji;
  final double savingsRate;
  final double expenseRatio;
  final double rentRatio;
  final bool hasEmergencyFund;

  FinancialHealthScore({
    required this.score,
    required this.label,
    required this.emoji,
    required this.savingsRate,
    required this.expenseRatio,
    required this.rentRatio,
    required this.hasEmergencyFund,
  });
}

class DailyBudget {
  final double remainingBalance;
  final int daysRemaining;
  final double safeDailySpend;

  DailyBudget({
    required this.remainingBalance,
    required this.daysRemaining,
    required this.safeDailySpend,
  });
}
