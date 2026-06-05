// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $IncomeRecordsTable extends IncomeRecords
    with TableInfo<$IncomeRecordsTable, IncomeRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IncomeRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    amount,
    category,
    date,
    description,
    source,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'income_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<IncomeRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IncomeRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IncomeRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $IncomeRecordsTable createAlias(String alias) {
    return $IncomeRecordsTable(attachedDatabase, alias);
  }
}

class IncomeRecord extends DataClass implements Insertable<IncomeRecord> {
  final int id;
  final double amount;
  final String category;
  final DateTime date;
  final String? description;
  final String? source;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const IncomeRecord({
    required this.id,
    required this.amount,
    required this.category,
    required this.date,
    this.description,
    this.source,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['amount'] = Variable<double>(amount);
    map['category'] = Variable<String>(category);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || source != null) {
      map['source'] = Variable<String>(source);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  IncomeRecordsCompanion toCompanion(bool nullToAbsent) {
    return IncomeRecordsCompanion(
      id: Value(id),
      amount: Value(amount),
      category: Value(category),
      date: Value(date),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      source: source == null && nullToAbsent
          ? const Value.absent()
          : Value(source),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory IncomeRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IncomeRecord(
      id: serializer.fromJson<int>(json['id']),
      amount: serializer.fromJson<double>(json['amount']),
      category: serializer.fromJson<String>(json['category']),
      date: serializer.fromJson<DateTime>(json['date']),
      description: serializer.fromJson<String?>(json['description']),
      source: serializer.fromJson<String?>(json['source']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'amount': serializer.toJson<double>(amount),
      'category': serializer.toJson<String>(category),
      'date': serializer.toJson<DateTime>(date),
      'description': serializer.toJson<String?>(description),
      'source': serializer.toJson<String?>(source),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  IncomeRecord copyWith({
    int? id,
    double? amount,
    String? category,
    DateTime? date,
    Value<String?> description = const Value.absent(),
    Value<String?> source = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => IncomeRecord(
    id: id ?? this.id,
    amount: amount ?? this.amount,
    category: category ?? this.category,
    date: date ?? this.date,
    description: description.present ? description.value : this.description,
    source: source.present ? source.value : this.source,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  IncomeRecord copyWithCompanion(IncomeRecordsCompanion data) {
    return IncomeRecord(
      id: data.id.present ? data.id.value : this.id,
      amount: data.amount.present ? data.amount.value : this.amount,
      category: data.category.present ? data.category.value : this.category,
      date: data.date.present ? data.date.value : this.date,
      description: data.description.present
          ? data.description.value
          : this.description,
      source: data.source.present ? data.source.value : this.source,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IncomeRecord(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('category: $category, ')
          ..write('date: $date, ')
          ..write('description: $description, ')
          ..write('source: $source, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    amount,
    category,
    date,
    description,
    source,
    notes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IncomeRecord &&
          other.id == this.id &&
          other.amount == this.amount &&
          other.category == this.category &&
          other.date == this.date &&
          other.description == this.description &&
          other.source == this.source &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class IncomeRecordsCompanion extends UpdateCompanion<IncomeRecord> {
  final Value<int> id;
  final Value<double> amount;
  final Value<String> category;
  final Value<DateTime> date;
  final Value<String?> description;
  final Value<String?> source;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const IncomeRecordsCompanion({
    this.id = const Value.absent(),
    this.amount = const Value.absent(),
    this.category = const Value.absent(),
    this.date = const Value.absent(),
    this.description = const Value.absent(),
    this.source = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  IncomeRecordsCompanion.insert({
    this.id = const Value.absent(),
    required double amount,
    required String category,
    required DateTime date,
    this.description = const Value.absent(),
    this.source = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : amount = Value(amount),
       category = Value(category),
       date = Value(date);
  static Insertable<IncomeRecord> custom({
    Expression<int>? id,
    Expression<double>? amount,
    Expression<String>? category,
    Expression<DateTime>? date,
    Expression<String>? description,
    Expression<String>? source,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amount != null) 'amount': amount,
      if (category != null) 'category': category,
      if (date != null) 'date': date,
      if (description != null) 'description': description,
      if (source != null) 'source': source,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  IncomeRecordsCompanion copyWith({
    Value<int>? id,
    Value<double>? amount,
    Value<String>? category,
    Value<DateTime>? date,
    Value<String?>? description,
    Value<String?>? source,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return IncomeRecordsCompanion(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      description: description ?? this.description,
      source: source ?? this.source,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IncomeRecordsCompanion(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('category: $category, ')
          ..write('date: $date, ')
          ..write('description: $description, ')
          ..write('source: $source, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ExpenseRecordsTable extends ExpenseRecords
    with TableInfo<$ExpenseRecordsTable, ExpenseRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpenseRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _paymentMethodMeta = const VerificationMeta(
    'paymentMethod',
  );
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
    'payment_method',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _receiptImagePathMeta = const VerificationMeta(
    'receiptImagePath',
  );
  @override
  late final GeneratedColumn<String> receiptImagePath = GeneratedColumn<String>(
    'receipt_image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    amount,
    category,
    date,
    description,
    paymentMethod,
    notes,
    receiptImagePath,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expense_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExpenseRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('payment_method')) {
      context.handle(
        _paymentMethodMeta,
        paymentMethod.isAcceptableOrUnknown(
          data['payment_method']!,
          _paymentMethodMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('receipt_image_path')) {
      context.handle(
        _receiptImagePathMeta,
        receiptImagePath.isAcceptableOrUnknown(
          data['receipt_image_path']!,
          _receiptImagePathMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExpenseRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpenseRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      paymentMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_method'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      receiptImagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receipt_image_path'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ExpenseRecordsTable createAlias(String alias) {
    return $ExpenseRecordsTable(attachedDatabase, alias);
  }
}

class ExpenseRecord extends DataClass implements Insertable<ExpenseRecord> {
  final int id;
  final double amount;
  final String category;
  final DateTime date;
  final String? description;
  final String? paymentMethod;
  final String? notes;
  final String? receiptImagePath;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ExpenseRecord({
    required this.id,
    required this.amount,
    required this.category,
    required this.date,
    this.description,
    this.paymentMethod,
    this.notes,
    this.receiptImagePath,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['amount'] = Variable<double>(amount);
    map['category'] = Variable<String>(category);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || paymentMethod != null) {
      map['payment_method'] = Variable<String>(paymentMethod);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || receiptImagePath != null) {
      map['receipt_image_path'] = Variable<String>(receiptImagePath);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ExpenseRecordsCompanion toCompanion(bool nullToAbsent) {
    return ExpenseRecordsCompanion(
      id: Value(id),
      amount: Value(amount),
      category: Value(category),
      date: Value(date),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      paymentMethod: paymentMethod == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentMethod),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      receiptImagePath: receiptImagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(receiptImagePath),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ExpenseRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpenseRecord(
      id: serializer.fromJson<int>(json['id']),
      amount: serializer.fromJson<double>(json['amount']),
      category: serializer.fromJson<String>(json['category']),
      date: serializer.fromJson<DateTime>(json['date']),
      description: serializer.fromJson<String?>(json['description']),
      paymentMethod: serializer.fromJson<String?>(json['paymentMethod']),
      notes: serializer.fromJson<String?>(json['notes']),
      receiptImagePath: serializer.fromJson<String?>(json['receiptImagePath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'amount': serializer.toJson<double>(amount),
      'category': serializer.toJson<String>(category),
      'date': serializer.toJson<DateTime>(date),
      'description': serializer.toJson<String?>(description),
      'paymentMethod': serializer.toJson<String?>(paymentMethod),
      'notes': serializer.toJson<String?>(notes),
      'receiptImagePath': serializer.toJson<String?>(receiptImagePath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ExpenseRecord copyWith({
    int? id,
    double? amount,
    String? category,
    DateTime? date,
    Value<String?> description = const Value.absent(),
    Value<String?> paymentMethod = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<String?> receiptImagePath = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ExpenseRecord(
    id: id ?? this.id,
    amount: amount ?? this.amount,
    category: category ?? this.category,
    date: date ?? this.date,
    description: description.present ? description.value : this.description,
    paymentMethod: paymentMethod.present
        ? paymentMethod.value
        : this.paymentMethod,
    notes: notes.present ? notes.value : this.notes,
    receiptImagePath: receiptImagePath.present
        ? receiptImagePath.value
        : this.receiptImagePath,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ExpenseRecord copyWithCompanion(ExpenseRecordsCompanion data) {
    return ExpenseRecord(
      id: data.id.present ? data.id.value : this.id,
      amount: data.amount.present ? data.amount.value : this.amount,
      category: data.category.present ? data.category.value : this.category,
      date: data.date.present ? data.date.value : this.date,
      description: data.description.present
          ? data.description.value
          : this.description,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      notes: data.notes.present ? data.notes.value : this.notes,
      receiptImagePath: data.receiptImagePath.present
          ? data.receiptImagePath.value
          : this.receiptImagePath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseRecord(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('category: $category, ')
          ..write('date: $date, ')
          ..write('description: $description, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('notes: $notes, ')
          ..write('receiptImagePath: $receiptImagePath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    amount,
    category,
    date,
    description,
    paymentMethod,
    notes,
    receiptImagePath,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpenseRecord &&
          other.id == this.id &&
          other.amount == this.amount &&
          other.category == this.category &&
          other.date == this.date &&
          other.description == this.description &&
          other.paymentMethod == this.paymentMethod &&
          other.notes == this.notes &&
          other.receiptImagePath == this.receiptImagePath &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ExpenseRecordsCompanion extends UpdateCompanion<ExpenseRecord> {
  final Value<int> id;
  final Value<double> amount;
  final Value<String> category;
  final Value<DateTime> date;
  final Value<String?> description;
  final Value<String?> paymentMethod;
  final Value<String?> notes;
  final Value<String?> receiptImagePath;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ExpenseRecordsCompanion({
    this.id = const Value.absent(),
    this.amount = const Value.absent(),
    this.category = const Value.absent(),
    this.date = const Value.absent(),
    this.description = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.notes = const Value.absent(),
    this.receiptImagePath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ExpenseRecordsCompanion.insert({
    this.id = const Value.absent(),
    required double amount,
    required String category,
    required DateTime date,
    this.description = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.notes = const Value.absent(),
    this.receiptImagePath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : amount = Value(amount),
       category = Value(category),
       date = Value(date);
  static Insertable<ExpenseRecord> custom({
    Expression<int>? id,
    Expression<double>? amount,
    Expression<String>? category,
    Expression<DateTime>? date,
    Expression<String>? description,
    Expression<String>? paymentMethod,
    Expression<String>? notes,
    Expression<String>? receiptImagePath,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amount != null) 'amount': amount,
      if (category != null) 'category': category,
      if (date != null) 'date': date,
      if (description != null) 'description': description,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (notes != null) 'notes': notes,
      if (receiptImagePath != null) 'receipt_image_path': receiptImagePath,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ExpenseRecordsCompanion copyWith({
    Value<int>? id,
    Value<double>? amount,
    Value<String>? category,
    Value<DateTime>? date,
    Value<String?>? description,
    Value<String?>? paymentMethod,
    Value<String?>? notes,
    Value<String?>? receiptImagePath,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return ExpenseRecordsCompanion(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      description: description ?? this.description,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      notes: notes ?? this.notes,
      receiptImagePath: receiptImagePath ?? this.receiptImagePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (receiptImagePath.present) {
      map['receipt_image_path'] = Variable<String>(receiptImagePath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseRecordsCompanion(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('category: $category, ')
          ..write('date: $date, ')
          ..write('description: $description, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('notes: $notes, ')
          ..write('receiptImagePath: $receiptImagePath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $RentRecordsTable extends RentRecords
    with TableInfo<$RentRecordsTable, RentRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RentRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paidDateMeta = const VerificationMeta(
    'paidDate',
  );
  @override
  late final GeneratedColumn<DateTime> paidDate = GeneratedColumn<DateTime>(
    'paid_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isPaidMeta = const VerificationMeta('isPaid');
  @override
  late final GeneratedColumn<bool> isPaid = GeneratedColumn<bool>(
    'is_paid',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_paid" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _landlordNotesMeta = const VerificationMeta(
    'landlordNotes',
  );
  @override
  late final GeneratedColumn<String> landlordNotes = GeneratedColumn<String>(
    'landlord_notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<int> month = GeneratedColumn<int>(
    'month',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    amount,
    dueDate,
    paidDate,
    isPaid,
    notes,
    landlordNotes,
    month,
    year,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rent_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<RentRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('paid_date')) {
      context.handle(
        _paidDateMeta,
        paidDate.isAcceptableOrUnknown(data['paid_date']!, _paidDateMeta),
      );
    }
    if (data.containsKey('is_paid')) {
      context.handle(
        _isPaidMeta,
        isPaid.isAcceptableOrUnknown(data['is_paid']!, _isPaidMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('landlord_notes')) {
      context.handle(
        _landlordNotesMeta,
        landlordNotes.isAcceptableOrUnknown(
          data['landlord_notes']!,
          _landlordNotesMeta,
        ),
      );
    }
    if (data.containsKey('month')) {
      context.handle(
        _monthMeta,
        month.isAcceptableOrUnknown(data['month']!, _monthMeta),
      );
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RentRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RentRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      )!,
      paidDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}paid_date'],
      ),
      isPaid: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_paid'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      landlordNotes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}landlord_notes'],
      ),
      month: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}month'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RentRecordsTable createAlias(String alias) {
    return $RentRecordsTable(attachedDatabase, alias);
  }
}

class RentRecord extends DataClass implements Insertable<RentRecord> {
  final int id;
  final double amount;
  final DateTime dueDate;
  final DateTime? paidDate;
  final bool isPaid;
  final String? notes;
  final String? landlordNotes;
  final int month;
  final int year;
  final DateTime createdAt;
  const RentRecord({
    required this.id,
    required this.amount,
    required this.dueDate,
    this.paidDate,
    required this.isPaid,
    this.notes,
    this.landlordNotes,
    required this.month,
    required this.year,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['amount'] = Variable<double>(amount);
    map['due_date'] = Variable<DateTime>(dueDate);
    if (!nullToAbsent || paidDate != null) {
      map['paid_date'] = Variable<DateTime>(paidDate);
    }
    map['is_paid'] = Variable<bool>(isPaid);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || landlordNotes != null) {
      map['landlord_notes'] = Variable<String>(landlordNotes);
    }
    map['month'] = Variable<int>(month);
    map['year'] = Variable<int>(year);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RentRecordsCompanion toCompanion(bool nullToAbsent) {
    return RentRecordsCompanion(
      id: Value(id),
      amount: Value(amount),
      dueDate: Value(dueDate),
      paidDate: paidDate == null && nullToAbsent
          ? const Value.absent()
          : Value(paidDate),
      isPaid: Value(isPaid),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      landlordNotes: landlordNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(landlordNotes),
      month: Value(month),
      year: Value(year),
      createdAt: Value(createdAt),
    );
  }

  factory RentRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RentRecord(
      id: serializer.fromJson<int>(json['id']),
      amount: serializer.fromJson<double>(json['amount']),
      dueDate: serializer.fromJson<DateTime>(json['dueDate']),
      paidDate: serializer.fromJson<DateTime?>(json['paidDate']),
      isPaid: serializer.fromJson<bool>(json['isPaid']),
      notes: serializer.fromJson<String?>(json['notes']),
      landlordNotes: serializer.fromJson<String?>(json['landlordNotes']),
      month: serializer.fromJson<int>(json['month']),
      year: serializer.fromJson<int>(json['year']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'amount': serializer.toJson<double>(amount),
      'dueDate': serializer.toJson<DateTime>(dueDate),
      'paidDate': serializer.toJson<DateTime?>(paidDate),
      'isPaid': serializer.toJson<bool>(isPaid),
      'notes': serializer.toJson<String?>(notes),
      'landlordNotes': serializer.toJson<String?>(landlordNotes),
      'month': serializer.toJson<int>(month),
      'year': serializer.toJson<int>(year),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RentRecord copyWith({
    int? id,
    double? amount,
    DateTime? dueDate,
    Value<DateTime?> paidDate = const Value.absent(),
    bool? isPaid,
    Value<String?> notes = const Value.absent(),
    Value<String?> landlordNotes = const Value.absent(),
    int? month,
    int? year,
    DateTime? createdAt,
  }) => RentRecord(
    id: id ?? this.id,
    amount: amount ?? this.amount,
    dueDate: dueDate ?? this.dueDate,
    paidDate: paidDate.present ? paidDate.value : this.paidDate,
    isPaid: isPaid ?? this.isPaid,
    notes: notes.present ? notes.value : this.notes,
    landlordNotes: landlordNotes.present
        ? landlordNotes.value
        : this.landlordNotes,
    month: month ?? this.month,
    year: year ?? this.year,
    createdAt: createdAt ?? this.createdAt,
  );
  RentRecord copyWithCompanion(RentRecordsCompanion data) {
    return RentRecord(
      id: data.id.present ? data.id.value : this.id,
      amount: data.amount.present ? data.amount.value : this.amount,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      paidDate: data.paidDate.present ? data.paidDate.value : this.paidDate,
      isPaid: data.isPaid.present ? data.isPaid.value : this.isPaid,
      notes: data.notes.present ? data.notes.value : this.notes,
      landlordNotes: data.landlordNotes.present
          ? data.landlordNotes.value
          : this.landlordNotes,
      month: data.month.present ? data.month.value : this.month,
      year: data.year.present ? data.year.value : this.year,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RentRecord(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('dueDate: $dueDate, ')
          ..write('paidDate: $paidDate, ')
          ..write('isPaid: $isPaid, ')
          ..write('notes: $notes, ')
          ..write('landlordNotes: $landlordNotes, ')
          ..write('month: $month, ')
          ..write('year: $year, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    amount,
    dueDate,
    paidDate,
    isPaid,
    notes,
    landlordNotes,
    month,
    year,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RentRecord &&
          other.id == this.id &&
          other.amount == this.amount &&
          other.dueDate == this.dueDate &&
          other.paidDate == this.paidDate &&
          other.isPaid == this.isPaid &&
          other.notes == this.notes &&
          other.landlordNotes == this.landlordNotes &&
          other.month == this.month &&
          other.year == this.year &&
          other.createdAt == this.createdAt);
}

class RentRecordsCompanion extends UpdateCompanion<RentRecord> {
  final Value<int> id;
  final Value<double> amount;
  final Value<DateTime> dueDate;
  final Value<DateTime?> paidDate;
  final Value<bool> isPaid;
  final Value<String?> notes;
  final Value<String?> landlordNotes;
  final Value<int> month;
  final Value<int> year;
  final Value<DateTime> createdAt;
  const RentRecordsCompanion({
    this.id = const Value.absent(),
    this.amount = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.paidDate = const Value.absent(),
    this.isPaid = const Value.absent(),
    this.notes = const Value.absent(),
    this.landlordNotes = const Value.absent(),
    this.month = const Value.absent(),
    this.year = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  RentRecordsCompanion.insert({
    this.id = const Value.absent(),
    required double amount,
    required DateTime dueDate,
    this.paidDate = const Value.absent(),
    this.isPaid = const Value.absent(),
    this.notes = const Value.absent(),
    this.landlordNotes = const Value.absent(),
    required int month,
    required int year,
    this.createdAt = const Value.absent(),
  }) : amount = Value(amount),
       dueDate = Value(dueDate),
       month = Value(month),
       year = Value(year);
  static Insertable<RentRecord> custom({
    Expression<int>? id,
    Expression<double>? amount,
    Expression<DateTime>? dueDate,
    Expression<DateTime>? paidDate,
    Expression<bool>? isPaid,
    Expression<String>? notes,
    Expression<String>? landlordNotes,
    Expression<int>? month,
    Expression<int>? year,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amount != null) 'amount': amount,
      if (dueDate != null) 'due_date': dueDate,
      if (paidDate != null) 'paid_date': paidDate,
      if (isPaid != null) 'is_paid': isPaid,
      if (notes != null) 'notes': notes,
      if (landlordNotes != null) 'landlord_notes': landlordNotes,
      if (month != null) 'month': month,
      if (year != null) 'year': year,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  RentRecordsCompanion copyWith({
    Value<int>? id,
    Value<double>? amount,
    Value<DateTime>? dueDate,
    Value<DateTime?>? paidDate,
    Value<bool>? isPaid,
    Value<String?>? notes,
    Value<String?>? landlordNotes,
    Value<int>? month,
    Value<int>? year,
    Value<DateTime>? createdAt,
  }) {
    return RentRecordsCompanion(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      dueDate: dueDate ?? this.dueDate,
      paidDate: paidDate ?? this.paidDate,
      isPaid: isPaid ?? this.isPaid,
      notes: notes ?? this.notes,
      landlordNotes: landlordNotes ?? this.landlordNotes,
      month: month ?? this.month,
      year: year ?? this.year,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (paidDate.present) {
      map['paid_date'] = Variable<DateTime>(paidDate.value);
    }
    if (isPaid.present) {
      map['is_paid'] = Variable<bool>(isPaid.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (landlordNotes.present) {
      map['landlord_notes'] = Variable<String>(landlordNotes.value);
    }
    if (month.present) {
      map['month'] = Variable<int>(month.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RentRecordsCompanion(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('dueDate: $dueDate, ')
          ..write('paidDate: $paidDate, ')
          ..write('isPaid: $isPaid, ')
          ..write('notes: $notes, ')
          ..write('landlordNotes: $landlordNotes, ')
          ..write('month: $month, ')
          ..write('year: $year, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SavingsGoalsTable extends SavingsGoals
    with TableInfo<$SavingsGoalsTable, SavingsGoal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavingsGoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetAmountMeta = const VerificationMeta(
    'targetAmount',
  );
  @override
  late final GeneratedColumn<double> targetAmount = GeneratedColumn<double>(
    'target_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentAmountMeta = const VerificationMeta(
    'currentAmount',
  );
  @override
  late final GeneratedColumn<double> currentAmount = GeneratedColumn<double>(
    'current_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _targetDateMeta = const VerificationMeta(
    'targetDate',
  );
  @override
  late final GeneratedColumn<DateTime> targetDate = GeneratedColumn<DateTime>(
    'target_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorHexMeta = const VerificationMeta(
    'colorHex',
  );
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
    'color_hex',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    targetAmount,
    currentAmount,
    targetDate,
    notes,
    colorHex,
    isCompleted,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'savings_goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavingsGoal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('target_amount')) {
      context.handle(
        _targetAmountMeta,
        targetAmount.isAcceptableOrUnknown(
          data['target_amount']!,
          _targetAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetAmountMeta);
    }
    if (data.containsKey('current_amount')) {
      context.handle(
        _currentAmountMeta,
        currentAmount.isAcceptableOrUnknown(
          data['current_amount']!,
          _currentAmountMeta,
        ),
      );
    }
    if (data.containsKey('target_date')) {
      context.handle(
        _targetDateMeta,
        targetDate.isAcceptableOrUnknown(data['target_date']!, _targetDateMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('color_hex')) {
      context.handle(
        _colorHexMeta,
        colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta),
      );
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavingsGoal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavingsGoal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      targetAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target_amount'],
      )!,
      currentAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}current_amount'],
      )!,
      targetDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}target_date'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      colorHex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_hex'],
      ),
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SavingsGoalsTable createAlias(String alias) {
    return $SavingsGoalsTable(attachedDatabase, alias);
  }
}

class SavingsGoal extends DataClass implements Insertable<SavingsGoal> {
  final int id;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final DateTime? targetDate;
  final String? notes;
  final String? colorHex;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SavingsGoal({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    this.targetDate,
    this.notes,
    this.colorHex,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['target_amount'] = Variable<double>(targetAmount);
    map['current_amount'] = Variable<double>(currentAmount);
    if (!nullToAbsent || targetDate != null) {
      map['target_date'] = Variable<DateTime>(targetDate);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || colorHex != null) {
      map['color_hex'] = Variable<String>(colorHex);
    }
    map['is_completed'] = Variable<bool>(isCompleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SavingsGoalsCompanion toCompanion(bool nullToAbsent) {
    return SavingsGoalsCompanion(
      id: Value(id),
      name: Value(name),
      targetAmount: Value(targetAmount),
      currentAmount: Value(currentAmount),
      targetDate: targetDate == null && nullToAbsent
          ? const Value.absent()
          : Value(targetDate),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      colorHex: colorHex == null && nullToAbsent
          ? const Value.absent()
          : Value(colorHex),
      isCompleted: Value(isCompleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SavingsGoal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavingsGoal(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      targetAmount: serializer.fromJson<double>(json['targetAmount']),
      currentAmount: serializer.fromJson<double>(json['currentAmount']),
      targetDate: serializer.fromJson<DateTime?>(json['targetDate']),
      notes: serializer.fromJson<String?>(json['notes']),
      colorHex: serializer.fromJson<String?>(json['colorHex']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'targetAmount': serializer.toJson<double>(targetAmount),
      'currentAmount': serializer.toJson<double>(currentAmount),
      'targetDate': serializer.toJson<DateTime?>(targetDate),
      'notes': serializer.toJson<String?>(notes),
      'colorHex': serializer.toJson<String?>(colorHex),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SavingsGoal copyWith({
    int? id,
    String? name,
    double? targetAmount,
    double? currentAmount,
    Value<DateTime?> targetDate = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<String?> colorHex = const Value.absent(),
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => SavingsGoal(
    id: id ?? this.id,
    name: name ?? this.name,
    targetAmount: targetAmount ?? this.targetAmount,
    currentAmount: currentAmount ?? this.currentAmount,
    targetDate: targetDate.present ? targetDate.value : this.targetDate,
    notes: notes.present ? notes.value : this.notes,
    colorHex: colorHex.present ? colorHex.value : this.colorHex,
    isCompleted: isCompleted ?? this.isCompleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SavingsGoal copyWithCompanion(SavingsGoalsCompanion data) {
    return SavingsGoal(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      targetAmount: data.targetAmount.present
          ? data.targetAmount.value
          : this.targetAmount,
      currentAmount: data.currentAmount.present
          ? data.currentAmount.value
          : this.currentAmount,
      targetDate: data.targetDate.present
          ? data.targetDate.value
          : this.targetDate,
      notes: data.notes.present ? data.notes.value : this.notes,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavingsGoal(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('targetAmount: $targetAmount, ')
          ..write('currentAmount: $currentAmount, ')
          ..write('targetDate: $targetDate, ')
          ..write('notes: $notes, ')
          ..write('colorHex: $colorHex, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    targetAmount,
    currentAmount,
    targetDate,
    notes,
    colorHex,
    isCompleted,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavingsGoal &&
          other.id == this.id &&
          other.name == this.name &&
          other.targetAmount == this.targetAmount &&
          other.currentAmount == this.currentAmount &&
          other.targetDate == this.targetDate &&
          other.notes == this.notes &&
          other.colorHex == this.colorHex &&
          other.isCompleted == this.isCompleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SavingsGoalsCompanion extends UpdateCompanion<SavingsGoal> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> targetAmount;
  final Value<double> currentAmount;
  final Value<DateTime?> targetDate;
  final Value<String?> notes;
  final Value<String?> colorHex;
  final Value<bool> isCompleted;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const SavingsGoalsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.targetAmount = const Value.absent(),
    this.currentAmount = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  SavingsGoalsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required double targetAmount,
    this.currentAmount = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name),
       targetAmount = Value(targetAmount);
  static Insertable<SavingsGoal> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? targetAmount,
    Expression<double>? currentAmount,
    Expression<DateTime>? targetDate,
    Expression<String>? notes,
    Expression<String>? colorHex,
    Expression<bool>? isCompleted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (targetAmount != null) 'target_amount': targetAmount,
      if (currentAmount != null) 'current_amount': currentAmount,
      if (targetDate != null) 'target_date': targetDate,
      if (notes != null) 'notes': notes,
      if (colorHex != null) 'color_hex': colorHex,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  SavingsGoalsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<double>? targetAmount,
    Value<double>? currentAmount,
    Value<DateTime?>? targetDate,
    Value<String?>? notes,
    Value<String?>? colorHex,
    Value<bool>? isCompleted,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return SavingsGoalsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      targetDate: targetDate ?? this.targetDate,
      notes: notes ?? this.notes,
      colorHex: colorHex ?? this.colorHex,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (targetAmount.present) {
      map['target_amount'] = Variable<double>(targetAmount.value);
    }
    if (currentAmount.present) {
      map['current_amount'] = Variable<double>(currentAmount.value);
    }
    if (targetDate.present) {
      map['target_date'] = Variable<DateTime>(targetDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavingsGoalsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('targetAmount: $targetAmount, ')
          ..write('currentAmount: $currentAmount, ')
          ..write('targetDate: $targetDate, ')
          ..write('notes: $notes, ')
          ..write('colorHex: $colorHex, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $SavingsTransactionsTable extends SavingsTransactions
    with TableInfo<$SavingsTransactionsTable, SavingsTransaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavingsTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<int> goalId = GeneratedColumn<int>(
    'goal_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES savings_goals (id)',
    ),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    goalId,
    amount,
    type,
    date,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'savings_transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavingsTransaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('goal_id')) {
      context.handle(
        _goalIdMeta,
        goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_goalIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavingsTransaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavingsTransaction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      goalId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}goal_id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SavingsTransactionsTable createAlias(String alias) {
    return $SavingsTransactionsTable(attachedDatabase, alias);
  }
}

class SavingsTransaction extends DataClass
    implements Insertable<SavingsTransaction> {
  final int id;
  final int goalId;
  final double amount;
  final String type;
  final DateTime date;
  final String? notes;
  final DateTime createdAt;
  const SavingsTransaction({
    required this.id,
    required this.goalId,
    required this.amount,
    required this.type,
    required this.date,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['goal_id'] = Variable<int>(goalId);
    map['amount'] = Variable<double>(amount);
    map['type'] = Variable<String>(type);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SavingsTransactionsCompanion toCompanion(bool nullToAbsent) {
    return SavingsTransactionsCompanion(
      id: Value(id),
      goalId: Value(goalId),
      amount: Value(amount),
      type: Value(type),
      date: Value(date),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory SavingsTransaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavingsTransaction(
      id: serializer.fromJson<int>(json['id']),
      goalId: serializer.fromJson<int>(json['goalId']),
      amount: serializer.fromJson<double>(json['amount']),
      type: serializer.fromJson<String>(json['type']),
      date: serializer.fromJson<DateTime>(json['date']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'goalId': serializer.toJson<int>(goalId),
      'amount': serializer.toJson<double>(amount),
      'type': serializer.toJson<String>(type),
      'date': serializer.toJson<DateTime>(date),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SavingsTransaction copyWith({
    int? id,
    int? goalId,
    double? amount,
    String? type,
    DateTime? date,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
  }) => SavingsTransaction(
    id: id ?? this.id,
    goalId: goalId ?? this.goalId,
    amount: amount ?? this.amount,
    type: type ?? this.type,
    date: date ?? this.date,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  SavingsTransaction copyWithCompanion(SavingsTransactionsCompanion data) {
    return SavingsTransaction(
      id: data.id.present ? data.id.value : this.id,
      goalId: data.goalId.present ? data.goalId.value : this.goalId,
      amount: data.amount.present ? data.amount.value : this.amount,
      type: data.type.present ? data.type.value : this.type,
      date: data.date.present ? data.date.value : this.date,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavingsTransaction(')
          ..write('id: $id, ')
          ..write('goalId: $goalId, ')
          ..write('amount: $amount, ')
          ..write('type: $type, ')
          ..write('date: $date, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, goalId, amount, type, date, notes, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavingsTransaction &&
          other.id == this.id &&
          other.goalId == this.goalId &&
          other.amount == this.amount &&
          other.type == this.type &&
          other.date == this.date &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class SavingsTransactionsCompanion extends UpdateCompanion<SavingsTransaction> {
  final Value<int> id;
  final Value<int> goalId;
  final Value<double> amount;
  final Value<String> type;
  final Value<DateTime> date;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  const SavingsTransactionsCompanion({
    this.id = const Value.absent(),
    this.goalId = const Value.absent(),
    this.amount = const Value.absent(),
    this.type = const Value.absent(),
    this.date = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SavingsTransactionsCompanion.insert({
    this.id = const Value.absent(),
    required int goalId,
    required double amount,
    required String type,
    required DateTime date,
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : goalId = Value(goalId),
       amount = Value(amount),
       type = Value(type),
       date = Value(date);
  static Insertable<SavingsTransaction> custom({
    Expression<int>? id,
    Expression<int>? goalId,
    Expression<double>? amount,
    Expression<String>? type,
    Expression<DateTime>? date,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (goalId != null) 'goal_id': goalId,
      if (amount != null) 'amount': amount,
      if (type != null) 'type': type,
      if (date != null) 'date': date,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SavingsTransactionsCompanion copyWith({
    Value<int>? id,
    Value<int>? goalId,
    Value<double>? amount,
    Value<String>? type,
    Value<DateTime>? date,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
  }) {
    return SavingsTransactionsCompanion(
      id: id ?? this.id,
      goalId: goalId ?? this.goalId,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (goalId.present) {
      map['goal_id'] = Variable<int>(goalId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavingsTransactionsCompanion(')
          ..write('id: $id, ')
          ..write('goalId: $goalId, ')
          ..write('amount: $amount, ')
          ..write('type: $type, ')
          ..write('date: $date, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $MonthlyReflectionsTable extends MonthlyReflections
    with TableInfo<$MonthlyReflectionsTable, MonthlyReflection> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MonthlyReflectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<int> month = GeneratedColumn<int>(
    'month',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wentWellMeta = const VerificationMeta(
    'wentWell',
  );
  @override
  late final GeneratedColumn<String> wentWell = GeneratedColumn<String>(
    'went_well',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _canImproveMeta = const VerificationMeta(
    'canImprove',
  );
  @override
  late final GeneratedColumn<String> canImprove = GeneratedColumn<String>(
    'can_improve',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _biggestExpenseMeta = const VerificationMeta(
    'biggestExpense',
  );
  @override
  late final GeneratedColumn<String> biggestExpense = GeneratedColumn<String>(
    'biggest_expense',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bestDecisionMeta = const VerificationMeta(
    'bestDecision',
  );
  @override
  late final GeneratedColumn<String> bestDecision = GeneratedColumn<String>(
    'best_decision',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalIncomeMeta = const VerificationMeta(
    'totalIncome',
  );
  @override
  late final GeneratedColumn<double> totalIncome = GeneratedColumn<double>(
    'total_income',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalExpensesMeta = const VerificationMeta(
    'totalExpenses',
  );
  @override
  late final GeneratedColumn<double> totalExpenses = GeneratedColumn<double>(
    'total_expenses',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalSavingsMeta = const VerificationMeta(
    'totalSavings',
  );
  @override
  late final GeneratedColumn<double> totalSavings = GeneratedColumn<double>(
    'total_savings',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    month,
    year,
    wentWell,
    canImprove,
    biggestExpense,
    bestDecision,
    totalIncome,
    totalExpenses,
    totalSavings,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'monthly_reflections';
  @override
  VerificationContext validateIntegrity(
    Insertable<MonthlyReflection> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('month')) {
      context.handle(
        _monthMeta,
        month.isAcceptableOrUnknown(data['month']!, _monthMeta),
      );
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('went_well')) {
      context.handle(
        _wentWellMeta,
        wentWell.isAcceptableOrUnknown(data['went_well']!, _wentWellMeta),
      );
    }
    if (data.containsKey('can_improve')) {
      context.handle(
        _canImproveMeta,
        canImprove.isAcceptableOrUnknown(data['can_improve']!, _canImproveMeta),
      );
    }
    if (data.containsKey('biggest_expense')) {
      context.handle(
        _biggestExpenseMeta,
        biggestExpense.isAcceptableOrUnknown(
          data['biggest_expense']!,
          _biggestExpenseMeta,
        ),
      );
    }
    if (data.containsKey('best_decision')) {
      context.handle(
        _bestDecisionMeta,
        bestDecision.isAcceptableOrUnknown(
          data['best_decision']!,
          _bestDecisionMeta,
        ),
      );
    }
    if (data.containsKey('total_income')) {
      context.handle(
        _totalIncomeMeta,
        totalIncome.isAcceptableOrUnknown(
          data['total_income']!,
          _totalIncomeMeta,
        ),
      );
    }
    if (data.containsKey('total_expenses')) {
      context.handle(
        _totalExpensesMeta,
        totalExpenses.isAcceptableOrUnknown(
          data['total_expenses']!,
          _totalExpensesMeta,
        ),
      );
    }
    if (data.containsKey('total_savings')) {
      context.handle(
        _totalSavingsMeta,
        totalSavings.isAcceptableOrUnknown(
          data['total_savings']!,
          _totalSavingsMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MonthlyReflection map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MonthlyReflection(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      month: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}month'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      )!,
      wentWell: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}went_well'],
      ),
      canImprove: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}can_improve'],
      ),
      biggestExpense: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}biggest_expense'],
      ),
      bestDecision: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}best_decision'],
      ),
      totalIncome: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_income'],
      ),
      totalExpenses: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_expenses'],
      ),
      totalSavings: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_savings'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MonthlyReflectionsTable createAlias(String alias) {
    return $MonthlyReflectionsTable(attachedDatabase, alias);
  }
}

class MonthlyReflection extends DataClass
    implements Insertable<MonthlyReflection> {
  final int id;
  final int month;
  final int year;
  final String? wentWell;
  final String? canImprove;
  final String? biggestExpense;
  final String? bestDecision;
  final double? totalIncome;
  final double? totalExpenses;
  final double? totalSavings;
  final DateTime createdAt;
  const MonthlyReflection({
    required this.id,
    required this.month,
    required this.year,
    this.wentWell,
    this.canImprove,
    this.biggestExpense,
    this.bestDecision,
    this.totalIncome,
    this.totalExpenses,
    this.totalSavings,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['month'] = Variable<int>(month);
    map['year'] = Variable<int>(year);
    if (!nullToAbsent || wentWell != null) {
      map['went_well'] = Variable<String>(wentWell);
    }
    if (!nullToAbsent || canImprove != null) {
      map['can_improve'] = Variable<String>(canImprove);
    }
    if (!nullToAbsent || biggestExpense != null) {
      map['biggest_expense'] = Variable<String>(biggestExpense);
    }
    if (!nullToAbsent || bestDecision != null) {
      map['best_decision'] = Variable<String>(bestDecision);
    }
    if (!nullToAbsent || totalIncome != null) {
      map['total_income'] = Variable<double>(totalIncome);
    }
    if (!nullToAbsent || totalExpenses != null) {
      map['total_expenses'] = Variable<double>(totalExpenses);
    }
    if (!nullToAbsent || totalSavings != null) {
      map['total_savings'] = Variable<double>(totalSavings);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MonthlyReflectionsCompanion toCompanion(bool nullToAbsent) {
    return MonthlyReflectionsCompanion(
      id: Value(id),
      month: Value(month),
      year: Value(year),
      wentWell: wentWell == null && nullToAbsent
          ? const Value.absent()
          : Value(wentWell),
      canImprove: canImprove == null && nullToAbsent
          ? const Value.absent()
          : Value(canImprove),
      biggestExpense: biggestExpense == null && nullToAbsent
          ? const Value.absent()
          : Value(biggestExpense),
      bestDecision: bestDecision == null && nullToAbsent
          ? const Value.absent()
          : Value(bestDecision),
      totalIncome: totalIncome == null && nullToAbsent
          ? const Value.absent()
          : Value(totalIncome),
      totalExpenses: totalExpenses == null && nullToAbsent
          ? const Value.absent()
          : Value(totalExpenses),
      totalSavings: totalSavings == null && nullToAbsent
          ? const Value.absent()
          : Value(totalSavings),
      createdAt: Value(createdAt),
    );
  }

  factory MonthlyReflection.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MonthlyReflection(
      id: serializer.fromJson<int>(json['id']),
      month: serializer.fromJson<int>(json['month']),
      year: serializer.fromJson<int>(json['year']),
      wentWell: serializer.fromJson<String?>(json['wentWell']),
      canImprove: serializer.fromJson<String?>(json['canImprove']),
      biggestExpense: serializer.fromJson<String?>(json['biggestExpense']),
      bestDecision: serializer.fromJson<String?>(json['bestDecision']),
      totalIncome: serializer.fromJson<double?>(json['totalIncome']),
      totalExpenses: serializer.fromJson<double?>(json['totalExpenses']),
      totalSavings: serializer.fromJson<double?>(json['totalSavings']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'month': serializer.toJson<int>(month),
      'year': serializer.toJson<int>(year),
      'wentWell': serializer.toJson<String?>(wentWell),
      'canImprove': serializer.toJson<String?>(canImprove),
      'biggestExpense': serializer.toJson<String?>(biggestExpense),
      'bestDecision': serializer.toJson<String?>(bestDecision),
      'totalIncome': serializer.toJson<double?>(totalIncome),
      'totalExpenses': serializer.toJson<double?>(totalExpenses),
      'totalSavings': serializer.toJson<double?>(totalSavings),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MonthlyReflection copyWith({
    int? id,
    int? month,
    int? year,
    Value<String?> wentWell = const Value.absent(),
    Value<String?> canImprove = const Value.absent(),
    Value<String?> biggestExpense = const Value.absent(),
    Value<String?> bestDecision = const Value.absent(),
    Value<double?> totalIncome = const Value.absent(),
    Value<double?> totalExpenses = const Value.absent(),
    Value<double?> totalSavings = const Value.absent(),
    DateTime? createdAt,
  }) => MonthlyReflection(
    id: id ?? this.id,
    month: month ?? this.month,
    year: year ?? this.year,
    wentWell: wentWell.present ? wentWell.value : this.wentWell,
    canImprove: canImprove.present ? canImprove.value : this.canImprove,
    biggestExpense: biggestExpense.present
        ? biggestExpense.value
        : this.biggestExpense,
    bestDecision: bestDecision.present ? bestDecision.value : this.bestDecision,
    totalIncome: totalIncome.present ? totalIncome.value : this.totalIncome,
    totalExpenses: totalExpenses.present
        ? totalExpenses.value
        : this.totalExpenses,
    totalSavings: totalSavings.present ? totalSavings.value : this.totalSavings,
    createdAt: createdAt ?? this.createdAt,
  );
  MonthlyReflection copyWithCompanion(MonthlyReflectionsCompanion data) {
    return MonthlyReflection(
      id: data.id.present ? data.id.value : this.id,
      month: data.month.present ? data.month.value : this.month,
      year: data.year.present ? data.year.value : this.year,
      wentWell: data.wentWell.present ? data.wentWell.value : this.wentWell,
      canImprove: data.canImprove.present
          ? data.canImprove.value
          : this.canImprove,
      biggestExpense: data.biggestExpense.present
          ? data.biggestExpense.value
          : this.biggestExpense,
      bestDecision: data.bestDecision.present
          ? data.bestDecision.value
          : this.bestDecision,
      totalIncome: data.totalIncome.present
          ? data.totalIncome.value
          : this.totalIncome,
      totalExpenses: data.totalExpenses.present
          ? data.totalExpenses.value
          : this.totalExpenses,
      totalSavings: data.totalSavings.present
          ? data.totalSavings.value
          : this.totalSavings,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MonthlyReflection(')
          ..write('id: $id, ')
          ..write('month: $month, ')
          ..write('year: $year, ')
          ..write('wentWell: $wentWell, ')
          ..write('canImprove: $canImprove, ')
          ..write('biggestExpense: $biggestExpense, ')
          ..write('bestDecision: $bestDecision, ')
          ..write('totalIncome: $totalIncome, ')
          ..write('totalExpenses: $totalExpenses, ')
          ..write('totalSavings: $totalSavings, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    month,
    year,
    wentWell,
    canImprove,
    biggestExpense,
    bestDecision,
    totalIncome,
    totalExpenses,
    totalSavings,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MonthlyReflection &&
          other.id == this.id &&
          other.month == this.month &&
          other.year == this.year &&
          other.wentWell == this.wentWell &&
          other.canImprove == this.canImprove &&
          other.biggestExpense == this.biggestExpense &&
          other.bestDecision == this.bestDecision &&
          other.totalIncome == this.totalIncome &&
          other.totalExpenses == this.totalExpenses &&
          other.totalSavings == this.totalSavings &&
          other.createdAt == this.createdAt);
}

class MonthlyReflectionsCompanion extends UpdateCompanion<MonthlyReflection> {
  final Value<int> id;
  final Value<int> month;
  final Value<int> year;
  final Value<String?> wentWell;
  final Value<String?> canImprove;
  final Value<String?> biggestExpense;
  final Value<String?> bestDecision;
  final Value<double?> totalIncome;
  final Value<double?> totalExpenses;
  final Value<double?> totalSavings;
  final Value<DateTime> createdAt;
  const MonthlyReflectionsCompanion({
    this.id = const Value.absent(),
    this.month = const Value.absent(),
    this.year = const Value.absent(),
    this.wentWell = const Value.absent(),
    this.canImprove = const Value.absent(),
    this.biggestExpense = const Value.absent(),
    this.bestDecision = const Value.absent(),
    this.totalIncome = const Value.absent(),
    this.totalExpenses = const Value.absent(),
    this.totalSavings = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  MonthlyReflectionsCompanion.insert({
    this.id = const Value.absent(),
    required int month,
    required int year,
    this.wentWell = const Value.absent(),
    this.canImprove = const Value.absent(),
    this.biggestExpense = const Value.absent(),
    this.bestDecision = const Value.absent(),
    this.totalIncome = const Value.absent(),
    this.totalExpenses = const Value.absent(),
    this.totalSavings = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : month = Value(month),
       year = Value(year);
  static Insertable<MonthlyReflection> custom({
    Expression<int>? id,
    Expression<int>? month,
    Expression<int>? year,
    Expression<String>? wentWell,
    Expression<String>? canImprove,
    Expression<String>? biggestExpense,
    Expression<String>? bestDecision,
    Expression<double>? totalIncome,
    Expression<double>? totalExpenses,
    Expression<double>? totalSavings,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (month != null) 'month': month,
      if (year != null) 'year': year,
      if (wentWell != null) 'went_well': wentWell,
      if (canImprove != null) 'can_improve': canImprove,
      if (biggestExpense != null) 'biggest_expense': biggestExpense,
      if (bestDecision != null) 'best_decision': bestDecision,
      if (totalIncome != null) 'total_income': totalIncome,
      if (totalExpenses != null) 'total_expenses': totalExpenses,
      if (totalSavings != null) 'total_savings': totalSavings,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  MonthlyReflectionsCompanion copyWith({
    Value<int>? id,
    Value<int>? month,
    Value<int>? year,
    Value<String?>? wentWell,
    Value<String?>? canImprove,
    Value<String?>? biggestExpense,
    Value<String?>? bestDecision,
    Value<double?>? totalIncome,
    Value<double?>? totalExpenses,
    Value<double?>? totalSavings,
    Value<DateTime>? createdAt,
  }) {
    return MonthlyReflectionsCompanion(
      id: id ?? this.id,
      month: month ?? this.month,
      year: year ?? this.year,
      wentWell: wentWell ?? this.wentWell,
      canImprove: canImprove ?? this.canImprove,
      biggestExpense: biggestExpense ?? this.biggestExpense,
      bestDecision: bestDecision ?? this.bestDecision,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpenses: totalExpenses ?? this.totalExpenses,
      totalSavings: totalSavings ?? this.totalSavings,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (month.present) {
      map['month'] = Variable<int>(month.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (wentWell.present) {
      map['went_well'] = Variable<String>(wentWell.value);
    }
    if (canImprove.present) {
      map['can_improve'] = Variable<String>(canImprove.value);
    }
    if (biggestExpense.present) {
      map['biggest_expense'] = Variable<String>(biggestExpense.value);
    }
    if (bestDecision.present) {
      map['best_decision'] = Variable<String>(bestDecision.value);
    }
    if (totalIncome.present) {
      map['total_income'] = Variable<double>(totalIncome.value);
    }
    if (totalExpenses.present) {
      map['total_expenses'] = Variable<double>(totalExpenses.value);
    }
    if (totalSavings.present) {
      map['total_savings'] = Variable<double>(totalSavings.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MonthlyReflectionsCompanion(')
          ..write('id: $id, ')
          ..write('month: $month, ')
          ..write('year: $year, ')
          ..write('wentWell: $wentWell, ')
          ..write('canImprove: $canImprove, ')
          ..write('biggestExpense: $biggestExpense, ')
          ..write('bestDecision: $bestDecision, ')
          ..write('totalIncome: $totalIncome, ')
          ..write('totalExpenses: $totalExpenses, ')
          ..write('totalSavings: $totalSavings, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String value;
  final DateTime updatedAt;
  const AppSetting({
    required this.key,
    required this.value,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AppSetting copyWith({String? key, String? value, DateTime? updatedAt}) =>
      AppSetting(
        key: key ?? this.key,
        value: value ?? this.value,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppNotificationsTable extends AppNotifications
    with TableInfo<$AppNotificationsTable, AppNotification> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppNotificationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isReadMeta = const VerificationMeta('isRead');
  @override
  late final GeneratedColumn<bool> isRead = GeneratedColumn<bool>(
    'is_read',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_read" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    body,
    type,
    isRead,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_notifications';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppNotification> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('is_read')) {
      context.handle(
        _isReadMeta,
        isRead.isAcceptableOrUnknown(data['is_read']!, _isReadMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppNotification map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppNotification(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      isRead: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_read'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AppNotificationsTable createAlias(String alias) {
    return $AppNotificationsTable(attachedDatabase, alias);
  }
}

class AppNotification extends DataClass implements Insertable<AppNotification> {
  final int id;
  final String title;
  final String body;
  final String type;
  final bool isRead;
  final DateTime createdAt;
  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.isRead,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    map['type'] = Variable<String>(type);
    map['is_read'] = Variable<bool>(isRead);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AppNotificationsCompanion toCompanion(bool nullToAbsent) {
    return AppNotificationsCompanion(
      id: Value(id),
      title: Value(title),
      body: Value(body),
      type: Value(type),
      isRead: Value(isRead),
      createdAt: Value(createdAt),
    );
  }

  factory AppNotification.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppNotification(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      type: serializer.fromJson<String>(json['type']),
      isRead: serializer.fromJson<bool>(json['isRead']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'type': serializer.toJson<String>(type),
      'isRead': serializer.toJson<bool>(isRead),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AppNotification copyWith({
    int? id,
    String? title,
    String? body,
    String? type,
    bool? isRead,
    DateTime? createdAt,
  }) => AppNotification(
    id: id ?? this.id,
    title: title ?? this.title,
    body: body ?? this.body,
    type: type ?? this.type,
    isRead: isRead ?? this.isRead,
    createdAt: createdAt ?? this.createdAt,
  );
  AppNotification copyWithCompanion(AppNotificationsCompanion data) {
    return AppNotification(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      type: data.type.present ? data.type.value : this.type,
      isRead: data.isRead.present ? data.isRead.value : this.isRead,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppNotification(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('type: $type, ')
          ..write('isRead: $isRead, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, body, type, isRead, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppNotification &&
          other.id == this.id &&
          other.title == this.title &&
          other.body == this.body &&
          other.type == this.type &&
          other.isRead == this.isRead &&
          other.createdAt == this.createdAt);
}

class AppNotificationsCompanion extends UpdateCompanion<AppNotification> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> body;
  final Value<String> type;
  final Value<bool> isRead;
  final Value<DateTime> createdAt;
  const AppNotificationsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.type = const Value.absent(),
    this.isRead = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  AppNotificationsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String body,
    required String type,
    this.isRead = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : title = Value(title),
       body = Value(body),
       type = Value(type);
  static Insertable<AppNotification> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? body,
    Expression<String>? type,
    Expression<bool>? isRead,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (type != null) 'type': type,
      if (isRead != null) 'is_read': isRead,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  AppNotificationsCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? body,
    Value<String>? type,
    Value<bool>? isRead,
    Value<DateTime>? createdAt,
  }) {
    return AppNotificationsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (isRead.present) {
      map['is_read'] = Variable<bool>(isRead.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppNotificationsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('type: $type, ')
          ..write('isRead: $isRead, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $IncomeRecordsTable incomeRecords = $IncomeRecordsTable(this);
  late final $ExpenseRecordsTable expenseRecords = $ExpenseRecordsTable(this);
  late final $RentRecordsTable rentRecords = $RentRecordsTable(this);
  late final $SavingsGoalsTable savingsGoals = $SavingsGoalsTable(this);
  late final $SavingsTransactionsTable savingsTransactions =
      $SavingsTransactionsTable(this);
  late final $MonthlyReflectionsTable monthlyReflections =
      $MonthlyReflectionsTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $AppNotificationsTable appNotifications = $AppNotificationsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    incomeRecords,
    expenseRecords,
    rentRecords,
    savingsGoals,
    savingsTransactions,
    monthlyReflections,
    appSettings,
    appNotifications,
  ];
}

typedef $$IncomeRecordsTableCreateCompanionBuilder =
    IncomeRecordsCompanion Function({
      Value<int> id,
      required double amount,
      required String category,
      required DateTime date,
      Value<String?> description,
      Value<String?> source,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$IncomeRecordsTableUpdateCompanionBuilder =
    IncomeRecordsCompanion Function({
      Value<int> id,
      Value<double> amount,
      Value<String> category,
      Value<DateTime> date,
      Value<String?> description,
      Value<String?> source,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$IncomeRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $IncomeRecordsTable> {
  $$IncomeRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$IncomeRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $IncomeRecordsTable> {
  $$IncomeRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$IncomeRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $IncomeRecordsTable> {
  $$IncomeRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$IncomeRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IncomeRecordsTable,
          IncomeRecord,
          $$IncomeRecordsTableFilterComposer,
          $$IncomeRecordsTableOrderingComposer,
          $$IncomeRecordsTableAnnotationComposer,
          $$IncomeRecordsTableCreateCompanionBuilder,
          $$IncomeRecordsTableUpdateCompanionBuilder,
          (
            IncomeRecord,
            BaseReferences<_$AppDatabase, $IncomeRecordsTable, IncomeRecord>,
          ),
          IncomeRecord,
          PrefetchHooks Function()
        > {
  $$IncomeRecordsTableTableManager(_$AppDatabase db, $IncomeRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IncomeRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IncomeRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IncomeRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> source = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => IncomeRecordsCompanion(
                id: id,
                amount: amount,
                category: category,
                date: date,
                description: description,
                source: source,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required double amount,
                required String category,
                required DateTime date,
                Value<String?> description = const Value.absent(),
                Value<String?> source = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => IncomeRecordsCompanion.insert(
                id: id,
                amount: amount,
                category: category,
                date: date,
                description: description,
                source: source,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$IncomeRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IncomeRecordsTable,
      IncomeRecord,
      $$IncomeRecordsTableFilterComposer,
      $$IncomeRecordsTableOrderingComposer,
      $$IncomeRecordsTableAnnotationComposer,
      $$IncomeRecordsTableCreateCompanionBuilder,
      $$IncomeRecordsTableUpdateCompanionBuilder,
      (
        IncomeRecord,
        BaseReferences<_$AppDatabase, $IncomeRecordsTable, IncomeRecord>,
      ),
      IncomeRecord,
      PrefetchHooks Function()
    >;
typedef $$ExpenseRecordsTableCreateCompanionBuilder =
    ExpenseRecordsCompanion Function({
      Value<int> id,
      required double amount,
      required String category,
      required DateTime date,
      Value<String?> description,
      Value<String?> paymentMethod,
      Value<String?> notes,
      Value<String?> receiptImagePath,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$ExpenseRecordsTableUpdateCompanionBuilder =
    ExpenseRecordsCompanion Function({
      Value<int> id,
      Value<double> amount,
      Value<String> category,
      Value<DateTime> date,
      Value<String?> description,
      Value<String?> paymentMethod,
      Value<String?> notes,
      Value<String?> receiptImagePath,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$ExpenseRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $ExpenseRecordsTable> {
  $$ExpenseRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get receiptImagePath => $composableBuilder(
    column: $table.receiptImagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExpenseRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpenseRecordsTable> {
  $$ExpenseRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receiptImagePath => $composableBuilder(
    column: $table.receiptImagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExpenseRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpenseRecordsTable> {
  $$ExpenseRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get receiptImagePath => $composableBuilder(
    column: $table.receiptImagePath,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ExpenseRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpenseRecordsTable,
          ExpenseRecord,
          $$ExpenseRecordsTableFilterComposer,
          $$ExpenseRecordsTableOrderingComposer,
          $$ExpenseRecordsTableAnnotationComposer,
          $$ExpenseRecordsTableCreateCompanionBuilder,
          $$ExpenseRecordsTableUpdateCompanionBuilder,
          (
            ExpenseRecord,
            BaseReferences<_$AppDatabase, $ExpenseRecordsTable, ExpenseRecord>,
          ),
          ExpenseRecord,
          PrefetchHooks Function()
        > {
  $$ExpenseRecordsTableTableManager(
    _$AppDatabase db,
    $ExpenseRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpenseRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpenseRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpenseRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> paymentMethod = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> receiptImagePath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ExpenseRecordsCompanion(
                id: id,
                amount: amount,
                category: category,
                date: date,
                description: description,
                paymentMethod: paymentMethod,
                notes: notes,
                receiptImagePath: receiptImagePath,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required double amount,
                required String category,
                required DateTime date,
                Value<String?> description = const Value.absent(),
                Value<String?> paymentMethod = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> receiptImagePath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ExpenseRecordsCompanion.insert(
                id: id,
                amount: amount,
                category: category,
                date: date,
                description: description,
                paymentMethod: paymentMethod,
                notes: notes,
                receiptImagePath: receiptImagePath,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExpenseRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpenseRecordsTable,
      ExpenseRecord,
      $$ExpenseRecordsTableFilterComposer,
      $$ExpenseRecordsTableOrderingComposer,
      $$ExpenseRecordsTableAnnotationComposer,
      $$ExpenseRecordsTableCreateCompanionBuilder,
      $$ExpenseRecordsTableUpdateCompanionBuilder,
      (
        ExpenseRecord,
        BaseReferences<_$AppDatabase, $ExpenseRecordsTable, ExpenseRecord>,
      ),
      ExpenseRecord,
      PrefetchHooks Function()
    >;
typedef $$RentRecordsTableCreateCompanionBuilder =
    RentRecordsCompanion Function({
      Value<int> id,
      required double amount,
      required DateTime dueDate,
      Value<DateTime?> paidDate,
      Value<bool> isPaid,
      Value<String?> notes,
      Value<String?> landlordNotes,
      required int month,
      required int year,
      Value<DateTime> createdAt,
    });
typedef $$RentRecordsTableUpdateCompanionBuilder =
    RentRecordsCompanion Function({
      Value<int> id,
      Value<double> amount,
      Value<DateTime> dueDate,
      Value<DateTime?> paidDate,
      Value<bool> isPaid,
      Value<String?> notes,
      Value<String?> landlordNotes,
      Value<int> month,
      Value<int> year,
      Value<DateTime> createdAt,
    });

class $$RentRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $RentRecordsTable> {
  $$RentRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get paidDate => $composableBuilder(
    column: $table.paidDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPaid => $composableBuilder(
    column: $table.isPaid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get landlordNotes => $composableBuilder(
    column: $table.landlordNotes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RentRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $RentRecordsTable> {
  $$RentRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get paidDate => $composableBuilder(
    column: $table.paidDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPaid => $composableBuilder(
    column: $table.isPaid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get landlordNotes => $composableBuilder(
    column: $table.landlordNotes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RentRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RentRecordsTable> {
  $$RentRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<DateTime> get paidDate =>
      $composableBuilder(column: $table.paidDate, builder: (column) => column);

  GeneratedColumn<bool> get isPaid =>
      $composableBuilder(column: $table.isPaid, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get landlordNotes => $composableBuilder(
    column: $table.landlordNotes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$RentRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RentRecordsTable,
          RentRecord,
          $$RentRecordsTableFilterComposer,
          $$RentRecordsTableOrderingComposer,
          $$RentRecordsTableAnnotationComposer,
          $$RentRecordsTableCreateCompanionBuilder,
          $$RentRecordsTableUpdateCompanionBuilder,
          (
            RentRecord,
            BaseReferences<_$AppDatabase, $RentRecordsTable, RentRecord>,
          ),
          RentRecord,
          PrefetchHooks Function()
        > {
  $$RentRecordsTableTableManager(_$AppDatabase db, $RentRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RentRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RentRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RentRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<DateTime> dueDate = const Value.absent(),
                Value<DateTime?> paidDate = const Value.absent(),
                Value<bool> isPaid = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> landlordNotes = const Value.absent(),
                Value<int> month = const Value.absent(),
                Value<int> year = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => RentRecordsCompanion(
                id: id,
                amount: amount,
                dueDate: dueDate,
                paidDate: paidDate,
                isPaid: isPaid,
                notes: notes,
                landlordNotes: landlordNotes,
                month: month,
                year: year,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required double amount,
                required DateTime dueDate,
                Value<DateTime?> paidDate = const Value.absent(),
                Value<bool> isPaid = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> landlordNotes = const Value.absent(),
                required int month,
                required int year,
                Value<DateTime> createdAt = const Value.absent(),
              }) => RentRecordsCompanion.insert(
                id: id,
                amount: amount,
                dueDate: dueDate,
                paidDate: paidDate,
                isPaid: isPaid,
                notes: notes,
                landlordNotes: landlordNotes,
                month: month,
                year: year,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RentRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RentRecordsTable,
      RentRecord,
      $$RentRecordsTableFilterComposer,
      $$RentRecordsTableOrderingComposer,
      $$RentRecordsTableAnnotationComposer,
      $$RentRecordsTableCreateCompanionBuilder,
      $$RentRecordsTableUpdateCompanionBuilder,
      (
        RentRecord,
        BaseReferences<_$AppDatabase, $RentRecordsTable, RentRecord>,
      ),
      RentRecord,
      PrefetchHooks Function()
    >;
typedef $$SavingsGoalsTableCreateCompanionBuilder =
    SavingsGoalsCompanion Function({
      Value<int> id,
      required String name,
      required double targetAmount,
      Value<double> currentAmount,
      Value<DateTime?> targetDate,
      Value<String?> notes,
      Value<String?> colorHex,
      Value<bool> isCompleted,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$SavingsGoalsTableUpdateCompanionBuilder =
    SavingsGoalsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<double> targetAmount,
      Value<double> currentAmount,
      Value<DateTime?> targetDate,
      Value<String?> notes,
      Value<String?> colorHex,
      Value<bool> isCompleted,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$SavingsGoalsTableReferences
    extends BaseReferences<_$AppDatabase, $SavingsGoalsTable, SavingsGoal> {
  $$SavingsGoalsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $SavingsTransactionsTable,
    List<SavingsTransaction>
  >
  _savingsTransactionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.savingsTransactions,
        aliasName: $_aliasNameGenerator(
          db.savingsGoals.id,
          db.savingsTransactions.goalId,
        ),
      );

  $$SavingsTransactionsTableProcessedTableManager get savingsTransactionsRefs {
    final manager = $$SavingsTransactionsTableTableManager(
      $_db,
      $_db.savingsTransactions,
    ).filter((f) => f.goalId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _savingsTransactionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SavingsGoalsTableFilterComposer
    extends Composer<_$AppDatabase, $SavingsGoalsTable> {
  $$SavingsGoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get targetAmount => $composableBuilder(
    column: $table.targetAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get currentAmount => $composableBuilder(
    column: $table.currentAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> savingsTransactionsRefs(
    Expression<bool> Function($$SavingsTransactionsTableFilterComposer f) f,
  ) {
    final $$SavingsTransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.savingsTransactions,
      getReferencedColumn: (t) => t.goalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SavingsTransactionsTableFilterComposer(
            $db: $db,
            $table: $db.savingsTransactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SavingsGoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $SavingsGoalsTable> {
  $$SavingsGoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get targetAmount => $composableBuilder(
    column: $table.targetAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get currentAmount => $composableBuilder(
    column: $table.currentAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SavingsGoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavingsGoalsTable> {
  $$SavingsGoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get targetAmount => $composableBuilder(
    column: $table.targetAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get currentAmount => $composableBuilder(
    column: $table.currentAmount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> savingsTransactionsRefs<T extends Object>(
    Expression<T> Function($$SavingsTransactionsTableAnnotationComposer a) f,
  ) {
    final $$SavingsTransactionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.savingsTransactions,
          getReferencedColumn: (t) => t.goalId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SavingsTransactionsTableAnnotationComposer(
                $db: $db,
                $table: $db.savingsTransactions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$SavingsGoalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SavingsGoalsTable,
          SavingsGoal,
          $$SavingsGoalsTableFilterComposer,
          $$SavingsGoalsTableOrderingComposer,
          $$SavingsGoalsTableAnnotationComposer,
          $$SavingsGoalsTableCreateCompanionBuilder,
          $$SavingsGoalsTableUpdateCompanionBuilder,
          (SavingsGoal, $$SavingsGoalsTableReferences),
          SavingsGoal,
          PrefetchHooks Function({bool savingsTransactionsRefs})
        > {
  $$SavingsGoalsTableTableManager(_$AppDatabase db, $SavingsGoalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavingsGoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavingsGoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavingsGoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> targetAmount = const Value.absent(),
                Value<double> currentAmount = const Value.absent(),
                Value<DateTime?> targetDate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> colorHex = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => SavingsGoalsCompanion(
                id: id,
                name: name,
                targetAmount: targetAmount,
                currentAmount: currentAmount,
                targetDate: targetDate,
                notes: notes,
                colorHex: colorHex,
                isCompleted: isCompleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required double targetAmount,
                Value<double> currentAmount = const Value.absent(),
                Value<DateTime?> targetDate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> colorHex = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => SavingsGoalsCompanion.insert(
                id: id,
                name: name,
                targetAmount: targetAmount,
                currentAmount: currentAmount,
                targetDate: targetDate,
                notes: notes,
                colorHex: colorHex,
                isCompleted: isCompleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SavingsGoalsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({savingsTransactionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (savingsTransactionsRefs) db.savingsTransactions,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (savingsTransactionsRefs)
                    await $_getPrefetchedData<
                      SavingsGoal,
                      $SavingsGoalsTable,
                      SavingsTransaction
                    >(
                      currentTable: table,
                      referencedTable: $$SavingsGoalsTableReferences
                          ._savingsTransactionsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SavingsGoalsTableReferences(
                            db,
                            table,
                            p0,
                          ).savingsTransactionsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.goalId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SavingsGoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SavingsGoalsTable,
      SavingsGoal,
      $$SavingsGoalsTableFilterComposer,
      $$SavingsGoalsTableOrderingComposer,
      $$SavingsGoalsTableAnnotationComposer,
      $$SavingsGoalsTableCreateCompanionBuilder,
      $$SavingsGoalsTableUpdateCompanionBuilder,
      (SavingsGoal, $$SavingsGoalsTableReferences),
      SavingsGoal,
      PrefetchHooks Function({bool savingsTransactionsRefs})
    >;
typedef $$SavingsTransactionsTableCreateCompanionBuilder =
    SavingsTransactionsCompanion Function({
      Value<int> id,
      required int goalId,
      required double amount,
      required String type,
      required DateTime date,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });
typedef $$SavingsTransactionsTableUpdateCompanionBuilder =
    SavingsTransactionsCompanion Function({
      Value<int> id,
      Value<int> goalId,
      Value<double> amount,
      Value<String> type,
      Value<DateTime> date,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });

final class $$SavingsTransactionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $SavingsTransactionsTable,
          SavingsTransaction
        > {
  $$SavingsTransactionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SavingsGoalsTable _goalIdTable(_$AppDatabase db) =>
      db.savingsGoals.createAlias(
        $_aliasNameGenerator(db.savingsTransactions.goalId, db.savingsGoals.id),
      );

  $$SavingsGoalsTableProcessedTableManager get goalId {
    final $_column = $_itemColumn<int>('goal_id')!;

    final manager = $$SavingsGoalsTableTableManager(
      $_db,
      $_db.savingsGoals,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_goalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SavingsTransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $SavingsTransactionsTable> {
  $$SavingsTransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SavingsGoalsTableFilterComposer get goalId {
    final $$SavingsGoalsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.savingsGoals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SavingsGoalsTableFilterComposer(
            $db: $db,
            $table: $db.savingsGoals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SavingsTransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SavingsTransactionsTable> {
  $$SavingsTransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SavingsGoalsTableOrderingComposer get goalId {
    final $$SavingsGoalsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.savingsGoals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SavingsGoalsTableOrderingComposer(
            $db: $db,
            $table: $db.savingsGoals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SavingsTransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavingsTransactionsTable> {
  $$SavingsTransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$SavingsGoalsTableAnnotationComposer get goalId {
    final $$SavingsGoalsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.savingsGoals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SavingsGoalsTableAnnotationComposer(
            $db: $db,
            $table: $db.savingsGoals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SavingsTransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SavingsTransactionsTable,
          SavingsTransaction,
          $$SavingsTransactionsTableFilterComposer,
          $$SavingsTransactionsTableOrderingComposer,
          $$SavingsTransactionsTableAnnotationComposer,
          $$SavingsTransactionsTableCreateCompanionBuilder,
          $$SavingsTransactionsTableUpdateCompanionBuilder,
          (SavingsTransaction, $$SavingsTransactionsTableReferences),
          SavingsTransaction,
          PrefetchHooks Function({bool goalId})
        > {
  $$SavingsTransactionsTableTableManager(
    _$AppDatabase db,
    $SavingsTransactionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavingsTransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavingsTransactionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$SavingsTransactionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> goalId = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SavingsTransactionsCompanion(
                id: id,
                goalId: goalId,
                amount: amount,
                type: type,
                date: date,
                notes: notes,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int goalId,
                required double amount,
                required String type,
                required DateTime date,
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SavingsTransactionsCompanion.insert(
                id: id,
                goalId: goalId,
                amount: amount,
                type: type,
                date: date,
                notes: notes,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SavingsTransactionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({goalId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (goalId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.goalId,
                                referencedTable:
                                    $$SavingsTransactionsTableReferences
                                        ._goalIdTable(db),
                                referencedColumn:
                                    $$SavingsTransactionsTableReferences
                                        ._goalIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SavingsTransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SavingsTransactionsTable,
      SavingsTransaction,
      $$SavingsTransactionsTableFilterComposer,
      $$SavingsTransactionsTableOrderingComposer,
      $$SavingsTransactionsTableAnnotationComposer,
      $$SavingsTransactionsTableCreateCompanionBuilder,
      $$SavingsTransactionsTableUpdateCompanionBuilder,
      (SavingsTransaction, $$SavingsTransactionsTableReferences),
      SavingsTransaction,
      PrefetchHooks Function({bool goalId})
    >;
typedef $$MonthlyReflectionsTableCreateCompanionBuilder =
    MonthlyReflectionsCompanion Function({
      Value<int> id,
      required int month,
      required int year,
      Value<String?> wentWell,
      Value<String?> canImprove,
      Value<String?> biggestExpense,
      Value<String?> bestDecision,
      Value<double?> totalIncome,
      Value<double?> totalExpenses,
      Value<double?> totalSavings,
      Value<DateTime> createdAt,
    });
typedef $$MonthlyReflectionsTableUpdateCompanionBuilder =
    MonthlyReflectionsCompanion Function({
      Value<int> id,
      Value<int> month,
      Value<int> year,
      Value<String?> wentWell,
      Value<String?> canImprove,
      Value<String?> biggestExpense,
      Value<String?> bestDecision,
      Value<double?> totalIncome,
      Value<double?> totalExpenses,
      Value<double?> totalSavings,
      Value<DateTime> createdAt,
    });

class $$MonthlyReflectionsTableFilterComposer
    extends Composer<_$AppDatabase, $MonthlyReflectionsTable> {
  $$MonthlyReflectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get wentWell => $composableBuilder(
    column: $table.wentWell,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get canImprove => $composableBuilder(
    column: $table.canImprove,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get biggestExpense => $composableBuilder(
    column: $table.biggestExpense,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bestDecision => $composableBuilder(
    column: $table.bestDecision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalIncome => $composableBuilder(
    column: $table.totalIncome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalExpenses => $composableBuilder(
    column: $table.totalExpenses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalSavings => $composableBuilder(
    column: $table.totalSavings,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MonthlyReflectionsTableOrderingComposer
    extends Composer<_$AppDatabase, $MonthlyReflectionsTable> {
  $$MonthlyReflectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get wentWell => $composableBuilder(
    column: $table.wentWell,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get canImprove => $composableBuilder(
    column: $table.canImprove,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get biggestExpense => $composableBuilder(
    column: $table.biggestExpense,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bestDecision => $composableBuilder(
    column: $table.bestDecision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalIncome => $composableBuilder(
    column: $table.totalIncome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalExpenses => $composableBuilder(
    column: $table.totalExpenses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalSavings => $composableBuilder(
    column: $table.totalSavings,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MonthlyReflectionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MonthlyReflectionsTable> {
  $$MonthlyReflectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<String> get wentWell =>
      $composableBuilder(column: $table.wentWell, builder: (column) => column);

  GeneratedColumn<String> get canImprove => $composableBuilder(
    column: $table.canImprove,
    builder: (column) => column,
  );

  GeneratedColumn<String> get biggestExpense => $composableBuilder(
    column: $table.biggestExpense,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bestDecision => $composableBuilder(
    column: $table.bestDecision,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalIncome => $composableBuilder(
    column: $table.totalIncome,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalExpenses => $composableBuilder(
    column: $table.totalExpenses,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalSavings => $composableBuilder(
    column: $table.totalSavings,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$MonthlyReflectionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MonthlyReflectionsTable,
          MonthlyReflection,
          $$MonthlyReflectionsTableFilterComposer,
          $$MonthlyReflectionsTableOrderingComposer,
          $$MonthlyReflectionsTableAnnotationComposer,
          $$MonthlyReflectionsTableCreateCompanionBuilder,
          $$MonthlyReflectionsTableUpdateCompanionBuilder,
          (
            MonthlyReflection,
            BaseReferences<
              _$AppDatabase,
              $MonthlyReflectionsTable,
              MonthlyReflection
            >,
          ),
          MonthlyReflection,
          PrefetchHooks Function()
        > {
  $$MonthlyReflectionsTableTableManager(
    _$AppDatabase db,
    $MonthlyReflectionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MonthlyReflectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MonthlyReflectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MonthlyReflectionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> month = const Value.absent(),
                Value<int> year = const Value.absent(),
                Value<String?> wentWell = const Value.absent(),
                Value<String?> canImprove = const Value.absent(),
                Value<String?> biggestExpense = const Value.absent(),
                Value<String?> bestDecision = const Value.absent(),
                Value<double?> totalIncome = const Value.absent(),
                Value<double?> totalExpenses = const Value.absent(),
                Value<double?> totalSavings = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MonthlyReflectionsCompanion(
                id: id,
                month: month,
                year: year,
                wentWell: wentWell,
                canImprove: canImprove,
                biggestExpense: biggestExpense,
                bestDecision: bestDecision,
                totalIncome: totalIncome,
                totalExpenses: totalExpenses,
                totalSavings: totalSavings,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int month,
                required int year,
                Value<String?> wentWell = const Value.absent(),
                Value<String?> canImprove = const Value.absent(),
                Value<String?> biggestExpense = const Value.absent(),
                Value<String?> bestDecision = const Value.absent(),
                Value<double?> totalIncome = const Value.absent(),
                Value<double?> totalExpenses = const Value.absent(),
                Value<double?> totalSavings = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MonthlyReflectionsCompanion.insert(
                id: id,
                month: month,
                year: year,
                wentWell: wentWell,
                canImprove: canImprove,
                biggestExpense: biggestExpense,
                bestDecision: bestDecision,
                totalIncome: totalIncome,
                totalExpenses: totalExpenses,
                totalSavings: totalSavings,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MonthlyReflectionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MonthlyReflectionsTable,
      MonthlyReflection,
      $$MonthlyReflectionsTableFilterComposer,
      $$MonthlyReflectionsTableOrderingComposer,
      $$MonthlyReflectionsTableAnnotationComposer,
      $$MonthlyReflectionsTableCreateCompanionBuilder,
      $$MonthlyReflectionsTableUpdateCompanionBuilder,
      (
        MonthlyReflection,
        BaseReferences<
          _$AppDatabase,
          $MonthlyReflectionsTable,
          MonthlyReflection
        >,
      ),
      MonthlyReflection,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String value,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;
typedef $$AppNotificationsTableCreateCompanionBuilder =
    AppNotificationsCompanion Function({
      Value<int> id,
      required String title,
      required String body,
      required String type,
      Value<bool> isRead,
      Value<DateTime> createdAt,
    });
typedef $$AppNotificationsTableUpdateCompanionBuilder =
    AppNotificationsCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String> body,
      Value<String> type,
      Value<bool> isRead,
      Value<DateTime> createdAt,
    });

class $$AppNotificationsTableFilterComposer
    extends Composer<_$AppDatabase, $AppNotificationsTable> {
  $$AppNotificationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRead => $composableBuilder(
    column: $table.isRead,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppNotificationsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppNotificationsTable> {
  $$AppNotificationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRead => $composableBuilder(
    column: $table.isRead,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppNotificationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppNotificationsTable> {
  $$AppNotificationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<bool> get isRead =>
      $composableBuilder(column: $table.isRead, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AppNotificationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppNotificationsTable,
          AppNotification,
          $$AppNotificationsTableFilterComposer,
          $$AppNotificationsTableOrderingComposer,
          $$AppNotificationsTableAnnotationComposer,
          $$AppNotificationsTableCreateCompanionBuilder,
          $$AppNotificationsTableUpdateCompanionBuilder,
          (
            AppNotification,
            BaseReferences<
              _$AppDatabase,
              $AppNotificationsTable,
              AppNotification
            >,
          ),
          AppNotification,
          PrefetchHooks Function()
        > {
  $$AppNotificationsTableTableManager(
    _$AppDatabase db,
    $AppNotificationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppNotificationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppNotificationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppNotificationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<bool> isRead = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AppNotificationsCompanion(
                id: id,
                title: title,
                body: body,
                type: type,
                isRead: isRead,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required String body,
                required String type,
                Value<bool> isRead = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AppNotificationsCompanion.insert(
                id: id,
                title: title,
                body: body,
                type: type,
                isRead: isRead,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppNotificationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppNotificationsTable,
      AppNotification,
      $$AppNotificationsTableFilterComposer,
      $$AppNotificationsTableOrderingComposer,
      $$AppNotificationsTableAnnotationComposer,
      $$AppNotificationsTableCreateCompanionBuilder,
      $$AppNotificationsTableUpdateCompanionBuilder,
      (
        AppNotification,
        BaseReferences<_$AppDatabase, $AppNotificationsTable, AppNotification>,
      ),
      AppNotification,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$IncomeRecordsTableTableManager get incomeRecords =>
      $$IncomeRecordsTableTableManager(_db, _db.incomeRecords);
  $$ExpenseRecordsTableTableManager get expenseRecords =>
      $$ExpenseRecordsTableTableManager(_db, _db.expenseRecords);
  $$RentRecordsTableTableManager get rentRecords =>
      $$RentRecordsTableTableManager(_db, _db.rentRecords);
  $$SavingsGoalsTableTableManager get savingsGoals =>
      $$SavingsGoalsTableTableManager(_db, _db.savingsGoals);
  $$SavingsTransactionsTableTableManager get savingsTransactions =>
      $$SavingsTransactionsTableTableManager(_db, _db.savingsTransactions);
  $$MonthlyReflectionsTableTableManager get monthlyReflections =>
      $$MonthlyReflectionsTableTableManager(_db, _db.monthlyReflections);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$AppNotificationsTableTableManager get appNotifications =>
      $$AppNotificationsTableTableManager(_db, _db.appNotifications);
}
