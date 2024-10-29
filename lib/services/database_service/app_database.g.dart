// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      'category_id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _categoryNameMeta =
      const VerificationMeta('categoryName');
  @override
  late final GeneratedColumn<String> categoryName = GeneratedColumn<String>(
      'category_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryTypeMeta =
      const VerificationMeta('categoryType');
  @override
  late final GeneratedColumnWithTypeConverter<CategoryType, String>
      categoryType = GeneratedColumn<String>(
              'category_type', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<CategoryType>($CategoriesTable.$convertercategoryType);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isProtectedMeta =
      const VerificationMeta('isProtected');
  @override
  late final GeneratedColumn<bool> isProtected = GeneratedColumn<bool>(
      'is_protected', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_protected" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _additionalInformationMeta =
      const VerificationMeta('additionalInformation');
  @override
  late final GeneratedColumn<String> additionalInformation =
      GeneratedColumn<String>('additional_information', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        categoryId,
        categoryName,
        categoryType,
        createdAt,
        updatedAt,
        deletedAt,
        isProtected,
        additionalInformation
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(Insertable<Category> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    }
    if (data.containsKey('category_name')) {
      context.handle(
          _categoryNameMeta,
          categoryName.isAcceptableOrUnknown(
              data['category_name']!, _categoryNameMeta));
    } else if (isInserting) {
      context.missing(_categoryNameMeta);
    }
    context.handle(_categoryTypeMeta, const VerificationResult.success());
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('is_protected')) {
      context.handle(
          _isProtectedMeta,
          isProtected.isAcceptableOrUnknown(
              data['is_protected']!, _isProtectedMeta));
    }
    if (data.containsKey('additional_information')) {
      context.handle(
          _additionalInformationMeta,
          additionalInformation.isAcceptableOrUnknown(
              data['additional_information']!, _additionalInformationMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {categoryId};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {categoryName, categoryType},
      ];
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category_id'])!,
      categoryName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_name'])!,
      categoryType: $CategoriesTable.$convertercategoryType.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}category_type'])!),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      isProtected: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_protected'])!,
      additionalInformation: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}additional_information']),
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<CategoryType, String, String>
      $convertercategoryType =
      const EnumNameConverter<CategoryType>(CategoryType.values);
}

class Category extends DataClass implements Insertable<Category> {
  final int categoryId;
  final String categoryName;
  final CategoryType categoryType;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final bool isProtected;
  final String? additionalInformation;
  const Category(
      {required this.categoryId,
      required this.categoryName,
      required this.categoryType,
      required this.createdAt,
      this.updatedAt,
      this.deletedAt,
      required this.isProtected,
      this.additionalInformation});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['category_id'] = Variable<int>(categoryId);
    map['category_name'] = Variable<String>(categoryName);
    {
      map['category_type'] = Variable<String>(
          $CategoriesTable.$convertercategoryType.toSql(categoryType));
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['is_protected'] = Variable<bool>(isProtected);
    if (!nullToAbsent || additionalInformation != null) {
      map['additional_information'] = Variable<String>(additionalInformation);
    }
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      categoryId: Value(categoryId),
      categoryName: Value(categoryName),
      categoryType: Value(categoryType),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      isProtected: Value(isProtected),
      additionalInformation: additionalInformation == null && nullToAbsent
          ? const Value.absent()
          : Value(additionalInformation),
    );
  }

  factory Category.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      categoryId: serializer.fromJson<int>(json['categoryId']),
      categoryName: serializer.fromJson<String>(json['categoryName']),
      categoryType: $CategoriesTable.$convertercategoryType
          .fromJson(serializer.fromJson<String>(json['categoryType'])),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      isProtected: serializer.fromJson<bool>(json['isProtected']),
      additionalInformation:
          serializer.fromJson<String?>(json['additionalInformation']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'categoryId': serializer.toJson<int>(categoryId),
      'categoryName': serializer.toJson<String>(categoryName),
      'categoryType': serializer.toJson<String>(
          $CategoriesTable.$convertercategoryType.toJson(categoryType)),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'isProtected': serializer.toJson<bool>(isProtected),
      'additionalInformation':
          serializer.toJson<String?>(additionalInformation),
    };
  }

  Category copyWith(
          {int? categoryId,
          String? categoryName,
          CategoryType? categoryType,
          DateTime? createdAt,
          Value<DateTime?> updatedAt = const Value.absent(),
          Value<DateTime?> deletedAt = const Value.absent(),
          bool? isProtected,
          Value<String?> additionalInformation = const Value.absent()}) =>
      Category(
        categoryId: categoryId ?? this.categoryId,
        categoryName: categoryName ?? this.categoryName,
        categoryType: categoryType ?? this.categoryType,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        isProtected: isProtected ?? this.isProtected,
        additionalInformation: additionalInformation.present
            ? additionalInformation.value
            : this.additionalInformation,
      );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      categoryName: data.categoryName.present
          ? data.categoryName.value
          : this.categoryName,
      categoryType: data.categoryType.present
          ? data.categoryType.value
          : this.categoryType,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      isProtected:
          data.isProtected.present ? data.isProtected.value : this.isProtected,
      additionalInformation: data.additionalInformation.present
          ? data.additionalInformation.value
          : this.additionalInformation,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('categoryId: $categoryId, ')
          ..write('categoryName: $categoryName, ')
          ..write('categoryType: $categoryType, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('isProtected: $isProtected, ')
          ..write('additionalInformation: $additionalInformation')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(categoryId, categoryName, categoryType,
      createdAt, updatedAt, deletedAt, isProtected, additionalInformation);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.categoryId == this.categoryId &&
          other.categoryName == this.categoryName &&
          other.categoryType == this.categoryType &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.isProtected == this.isProtected &&
          other.additionalInformation == this.additionalInformation);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> categoryId;
  final Value<String> categoryName;
  final Value<CategoryType> categoryType;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<bool> isProtected;
  final Value<String?> additionalInformation;
  const CategoriesCompanion({
    this.categoryId = const Value.absent(),
    this.categoryName = const Value.absent(),
    this.categoryType = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.isProtected = const Value.absent(),
    this.additionalInformation = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.categoryId = const Value.absent(),
    required String categoryName,
    required CategoryType categoryType,
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.isProtected = const Value.absent(),
    this.additionalInformation = const Value.absent(),
  })  : categoryName = Value(categoryName),
        categoryType = Value(categoryType),
        createdAt = Value(createdAt);
  static Insertable<Category> custom({
    Expression<int>? categoryId,
    Expression<String>? categoryName,
    Expression<String>? categoryType,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<bool>? isProtected,
    Expression<String>? additionalInformation,
  }) {
    return RawValuesInsertable({
      if (categoryId != null) 'category_id': categoryId,
      if (categoryName != null) 'category_name': categoryName,
      if (categoryType != null) 'category_type': categoryType,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (isProtected != null) 'is_protected': isProtected,
      if (additionalInformation != null)
        'additional_information': additionalInformation,
    });
  }

  CategoriesCompanion copyWith(
      {Value<int>? categoryId,
      Value<String>? categoryName,
      Value<CategoryType>? categoryType,
      Value<DateTime>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<DateTime?>? deletedAt,
      Value<bool>? isProtected,
      Value<String?>? additionalInformation}) {
    return CategoriesCompanion(
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      categoryType: categoryType ?? this.categoryType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isProtected: isProtected ?? this.isProtected,
      additionalInformation:
          additionalInformation ?? this.additionalInformation,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (categoryName.present) {
      map['category_name'] = Variable<String>(categoryName.value);
    }
    if (categoryType.present) {
      map['category_type'] = Variable<String>(
          $CategoriesTable.$convertercategoryType.toSql(categoryType.value));
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (isProtected.present) {
      map['is_protected'] = Variable<bool>(isProtected.value);
    }
    if (additionalInformation.present) {
      map['additional_information'] =
          Variable<String>(additionalInformation.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('categoryId: $categoryId, ')
          ..write('categoryName: $categoryName, ')
          ..write('categoryType: $categoryType, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('isProtected: $isProtected, ')
          ..write('additionalInformation: $additionalInformation')
          ..write(')'))
        .toString();
  }
}

class $BudgetsTable extends Budgets with TableInfo<$BudgetsTable, Budget> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _budgetIdMeta =
      const VerificationMeta('budgetId');
  @override
  late final GeneratedColumn<int> budgetId = GeneratedColumn<int>(
      'budget_id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _budgetNameMeta =
      const VerificationMeta('budgetName');
  @override
  late final GeneratedColumn<String> budgetName = GeneratedColumn<String>(
      'budget_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _budgetedValueMeta =
      const VerificationMeta('budgetedValue');
  @override
  late final GeneratedColumn<double> budgetedValue = GeneratedColumn<double>(
      'budgeted_value', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _dateCreatedMeta =
      const VerificationMeta('dateCreated');
  @override
  late final GeneratedColumn<DateTime> dateCreated = GeneratedColumn<DateTime>(
      'date_created', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _dateUpdatedMeta =
      const VerificationMeta('dateUpdated');
  @override
  late final GeneratedColumn<DateTime> dateUpdated = GeneratedColumn<DateTime>(
      'date_updated', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endDateMeta =
      const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
      'end_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      'category_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES categories (category_id) ON UPDATE CASCADE ON DELETE CASCADE'));
  @override
  List<GeneratedColumn> get $columns => [
        budgetId,
        budgetName,
        budgetedValue,
        dateCreated,
        dateUpdated,
        startDate,
        endDate,
        categoryId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budgets';
  @override
  VerificationContext validateIntegrity(Insertable<Budget> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('budget_id')) {
      context.handle(_budgetIdMeta,
          budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta));
    }
    if (data.containsKey('budget_name')) {
      context.handle(
          _budgetNameMeta,
          budgetName.isAcceptableOrUnknown(
              data['budget_name']!, _budgetNameMeta));
    } else if (isInserting) {
      context.missing(_budgetNameMeta);
    }
    if (data.containsKey('budgeted_value')) {
      context.handle(
          _budgetedValueMeta,
          budgetedValue.isAcceptableOrUnknown(
              data['budgeted_value']!, _budgetedValueMeta));
    } else if (isInserting) {
      context.missing(_budgetedValueMeta);
    }
    if (data.containsKey('date_created')) {
      context.handle(
          _dateCreatedMeta,
          dateCreated.isAcceptableOrUnknown(
              data['date_created']!, _dateCreatedMeta));
    } else if (isInserting) {
      context.missing(_dateCreatedMeta);
    }
    if (data.containsKey('date_updated')) {
      context.handle(
          _dateUpdatedMeta,
          dateUpdated.isAcceptableOrUnknown(
              data['date_updated']!, _dateUpdatedMeta));
    } else if (isInserting) {
      context.missing(_dateUpdatedMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {budgetId};
  @override
  Budget map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Budget(
      budgetId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}budget_id'])!,
      budgetName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}budget_name'])!,
      budgetedValue: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}budgeted_value'])!,
      dateCreated: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_created'])!,
      dateUpdated: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_updated'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date'])!,
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_date'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category_id'])!,
    );
  }

  @override
  $BudgetsTable createAlias(String alias) {
    return $BudgetsTable(attachedDatabase, alias);
  }
}

class Budget extends DataClass implements Insertable<Budget> {
  final int budgetId;
  final String budgetName;
  final double budgetedValue;
  final DateTime dateCreated;
  final DateTime dateUpdated;
  final DateTime startDate;
  final DateTime endDate;
  final int categoryId;
  const Budget(
      {required this.budgetId,
      required this.budgetName,
      required this.budgetedValue,
      required this.dateCreated,
      required this.dateUpdated,
      required this.startDate,
      required this.endDate,
      required this.categoryId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['budget_id'] = Variable<int>(budgetId);
    map['budget_name'] = Variable<String>(budgetName);
    map['budgeted_value'] = Variable<double>(budgetedValue);
    map['date_created'] = Variable<DateTime>(dateCreated);
    map['date_updated'] = Variable<DateTime>(dateUpdated);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    map['category_id'] = Variable<int>(categoryId);
    return map;
  }

  BudgetsCompanion toCompanion(bool nullToAbsent) {
    return BudgetsCompanion(
      budgetId: Value(budgetId),
      budgetName: Value(budgetName),
      budgetedValue: Value(budgetedValue),
      dateCreated: Value(dateCreated),
      dateUpdated: Value(dateUpdated),
      startDate: Value(startDate),
      endDate: Value(endDate),
      categoryId: Value(categoryId),
    );
  }

  factory Budget.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Budget(
      budgetId: serializer.fromJson<int>(json['budgetId']),
      budgetName: serializer.fromJson<String>(json['budgetName']),
      budgetedValue: serializer.fromJson<double>(json['budgetedValue']),
      dateCreated: serializer.fromJson<DateTime>(json['dateCreated']),
      dateUpdated: serializer.fromJson<DateTime>(json['dateUpdated']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'budgetId': serializer.toJson<int>(budgetId),
      'budgetName': serializer.toJson<String>(budgetName),
      'budgetedValue': serializer.toJson<double>(budgetedValue),
      'dateCreated': serializer.toJson<DateTime>(dateCreated),
      'dateUpdated': serializer.toJson<DateTime>(dateUpdated),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'categoryId': serializer.toJson<int>(categoryId),
    };
  }

  Budget copyWith(
          {int? budgetId,
          String? budgetName,
          double? budgetedValue,
          DateTime? dateCreated,
          DateTime? dateUpdated,
          DateTime? startDate,
          DateTime? endDate,
          int? categoryId}) =>
      Budget(
        budgetId: budgetId ?? this.budgetId,
        budgetName: budgetName ?? this.budgetName,
        budgetedValue: budgetedValue ?? this.budgetedValue,
        dateCreated: dateCreated ?? this.dateCreated,
        dateUpdated: dateUpdated ?? this.dateUpdated,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        categoryId: categoryId ?? this.categoryId,
      );
  Budget copyWithCompanion(BudgetsCompanion data) {
    return Budget(
      budgetId: data.budgetId.present ? data.budgetId.value : this.budgetId,
      budgetName:
          data.budgetName.present ? data.budgetName.value : this.budgetName,
      budgetedValue: data.budgetedValue.present
          ? data.budgetedValue.value
          : this.budgetedValue,
      dateCreated:
          data.dateCreated.present ? data.dateCreated.value : this.dateCreated,
      dateUpdated:
          data.dateUpdated.present ? data.dateUpdated.value : this.dateUpdated,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Budget(')
          ..write('budgetId: $budgetId, ')
          ..write('budgetName: $budgetName, ')
          ..write('budgetedValue: $budgetedValue, ')
          ..write('dateCreated: $dateCreated, ')
          ..write('dateUpdated: $dateUpdated, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('categoryId: $categoryId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(budgetId, budgetName, budgetedValue,
      dateCreated, dateUpdated, startDate, endDate, categoryId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Budget &&
          other.budgetId == this.budgetId &&
          other.budgetName == this.budgetName &&
          other.budgetedValue == this.budgetedValue &&
          other.dateCreated == this.dateCreated &&
          other.dateUpdated == this.dateUpdated &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.categoryId == this.categoryId);
}

class BudgetsCompanion extends UpdateCompanion<Budget> {
  final Value<int> budgetId;
  final Value<String> budgetName;
  final Value<double> budgetedValue;
  final Value<DateTime> dateCreated;
  final Value<DateTime> dateUpdated;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<int> categoryId;
  const BudgetsCompanion({
    this.budgetId = const Value.absent(),
    this.budgetName = const Value.absent(),
    this.budgetedValue = const Value.absent(),
    this.dateCreated = const Value.absent(),
    this.dateUpdated = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.categoryId = const Value.absent(),
  });
  BudgetsCompanion.insert({
    this.budgetId = const Value.absent(),
    required String budgetName,
    required double budgetedValue,
    required DateTime dateCreated,
    required DateTime dateUpdated,
    required DateTime startDate,
    required DateTime endDate,
    required int categoryId,
  })  : budgetName = Value(budgetName),
        budgetedValue = Value(budgetedValue),
        dateCreated = Value(dateCreated),
        dateUpdated = Value(dateUpdated),
        startDate = Value(startDate),
        endDate = Value(endDate),
        categoryId = Value(categoryId);
  static Insertable<Budget> custom({
    Expression<int>? budgetId,
    Expression<String>? budgetName,
    Expression<double>? budgetedValue,
    Expression<DateTime>? dateCreated,
    Expression<DateTime>? dateUpdated,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<int>? categoryId,
  }) {
    return RawValuesInsertable({
      if (budgetId != null) 'budget_id': budgetId,
      if (budgetName != null) 'budget_name': budgetName,
      if (budgetedValue != null) 'budgeted_value': budgetedValue,
      if (dateCreated != null) 'date_created': dateCreated,
      if (dateUpdated != null) 'date_updated': dateUpdated,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (categoryId != null) 'category_id': categoryId,
    });
  }

  BudgetsCompanion copyWith(
      {Value<int>? budgetId,
      Value<String>? budgetName,
      Value<double>? budgetedValue,
      Value<DateTime>? dateCreated,
      Value<DateTime>? dateUpdated,
      Value<DateTime>? startDate,
      Value<DateTime>? endDate,
      Value<int>? categoryId}) {
    return BudgetsCompanion(
      budgetId: budgetId ?? this.budgetId,
      budgetName: budgetName ?? this.budgetName,
      budgetedValue: budgetedValue ?? this.budgetedValue,
      dateCreated: dateCreated ?? this.dateCreated,
      dateUpdated: dateUpdated ?? this.dateUpdated,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (budgetId.present) {
      map['budget_id'] = Variable<int>(budgetId.value);
    }
    if (budgetName.present) {
      map['budget_name'] = Variable<String>(budgetName.value);
    }
    if (budgetedValue.present) {
      map['budgeted_value'] = Variable<double>(budgetedValue.value);
    }
    if (dateCreated.present) {
      map['date_created'] = Variable<DateTime>(dateCreated.value);
    }
    if (dateUpdated.present) {
      map['date_updated'] = Variable<DateTime>(dateUpdated.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetsCompanion(')
          ..write('budgetId: $budgetId, ')
          ..write('budgetName: $budgetName, ')
          ..write('budgetedValue: $budgetedValue, ')
          ..write('dateCreated: $dateCreated, ')
          ..write('dateUpdated: $dateUpdated, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('categoryId: $categoryId')
          ..write(')'))
        .toString();
  }
}

class $DebtsTable extends Debts with TableInfo<$DebtsTable, Debt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DebtsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _debtIdMeta = const VerificationMeta('debtId');
  @override
  late final GeneratedColumn<int> debtId = GeneratedColumn<int>(
      'debt_id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _peopleNameMeta =
      const VerificationMeta('peopleName');
  @override
  late final GeneratedColumn<String> peopleName = GeneratedColumn<String>(
      'people_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _expectedToBeSettledDateMeta =
      const VerificationMeta('expectedToBeSettledDate');
  @override
  late final GeneratedColumn<DateTime> expectedToBeSettledDate =
      GeneratedColumn<DateTime>(
          'expected_to_be_settled_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _settledDateMeta =
      const VerificationMeta('settledDate');
  @override
  late final GeneratedColumn<DateTime> settledDate = GeneratedColumn<DateTime>(
      'settled_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [debtId, peopleName, expectedToBeSettledDate, settledDate];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'debts';
  @override
  VerificationContext validateIntegrity(Insertable<Debt> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('debt_id')) {
      context.handle(_debtIdMeta,
          debtId.isAcceptableOrUnknown(data['debt_id']!, _debtIdMeta));
    }
    if (data.containsKey('people_name')) {
      context.handle(
          _peopleNameMeta,
          peopleName.isAcceptableOrUnknown(
              data['people_name']!, _peopleNameMeta));
    } else if (isInserting) {
      context.missing(_peopleNameMeta);
    }
    if (data.containsKey('expected_to_be_settled_date')) {
      context.handle(
          _expectedToBeSettledDateMeta,
          expectedToBeSettledDate.isAcceptableOrUnknown(
              data['expected_to_be_settled_date']!,
              _expectedToBeSettledDateMeta));
    }
    if (data.containsKey('settled_date')) {
      context.handle(
          _settledDateMeta,
          settledDate.isAcceptableOrUnknown(
              data['settled_date']!, _settledDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {debtId};
  @override
  Debt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Debt(
      debtId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}debt_id'])!,
      peopleName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}people_name'])!,
      expectedToBeSettledDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}expected_to_be_settled_date']),
      settledDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}settled_date']),
    );
  }

  @override
  $DebtsTable createAlias(String alias) {
    return $DebtsTable(attachedDatabase, alias);
  }
}

class Debt extends DataClass implements Insertable<Debt> {
  final int debtId;
  final String peopleName;
  final DateTime? expectedToBeSettledDate;
  final DateTime? settledDate;
  const Debt(
      {required this.debtId,
      required this.peopleName,
      this.expectedToBeSettledDate,
      this.settledDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['debt_id'] = Variable<int>(debtId);
    map['people_name'] = Variable<String>(peopleName);
    if (!nullToAbsent || expectedToBeSettledDate != null) {
      map['expected_to_be_settled_date'] =
          Variable<DateTime>(expectedToBeSettledDate);
    }
    if (!nullToAbsent || settledDate != null) {
      map['settled_date'] = Variable<DateTime>(settledDate);
    }
    return map;
  }

  DebtsCompanion toCompanion(bool nullToAbsent) {
    return DebtsCompanion(
      debtId: Value(debtId),
      peopleName: Value(peopleName),
      expectedToBeSettledDate: expectedToBeSettledDate == null && nullToAbsent
          ? const Value.absent()
          : Value(expectedToBeSettledDate),
      settledDate: settledDate == null && nullToAbsent
          ? const Value.absent()
          : Value(settledDate),
    );
  }

  factory Debt.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Debt(
      debtId: serializer.fromJson<int>(json['debtId']),
      peopleName: serializer.fromJson<String>(json['peopleName']),
      expectedToBeSettledDate:
          serializer.fromJson<DateTime?>(json['expectedToBeSettledDate']),
      settledDate: serializer.fromJson<DateTime?>(json['settledDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'debtId': serializer.toJson<int>(debtId),
      'peopleName': serializer.toJson<String>(peopleName),
      'expectedToBeSettledDate':
          serializer.toJson<DateTime?>(expectedToBeSettledDate),
      'settledDate': serializer.toJson<DateTime?>(settledDate),
    };
  }

  Debt copyWith(
          {int? debtId,
          String? peopleName,
          Value<DateTime?> expectedToBeSettledDate = const Value.absent(),
          Value<DateTime?> settledDate = const Value.absent()}) =>
      Debt(
        debtId: debtId ?? this.debtId,
        peopleName: peopleName ?? this.peopleName,
        expectedToBeSettledDate: expectedToBeSettledDate.present
            ? expectedToBeSettledDate.value
            : this.expectedToBeSettledDate,
        settledDate: settledDate.present ? settledDate.value : this.settledDate,
      );
  Debt copyWithCompanion(DebtsCompanion data) {
    return Debt(
      debtId: data.debtId.present ? data.debtId.value : this.debtId,
      peopleName:
          data.peopleName.present ? data.peopleName.value : this.peopleName,
      expectedToBeSettledDate: data.expectedToBeSettledDate.present
          ? data.expectedToBeSettledDate.value
          : this.expectedToBeSettledDate,
      settledDate:
          data.settledDate.present ? data.settledDate.value : this.settledDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Debt(')
          ..write('debtId: $debtId, ')
          ..write('peopleName: $peopleName, ')
          ..write('expectedToBeSettledDate: $expectedToBeSettledDate, ')
          ..write('settledDate: $settledDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(debtId, peopleName, expectedToBeSettledDate, settledDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Debt &&
          other.debtId == this.debtId &&
          other.peopleName == this.peopleName &&
          other.expectedToBeSettledDate == this.expectedToBeSettledDate &&
          other.settledDate == this.settledDate);
}

class DebtsCompanion extends UpdateCompanion<Debt> {
  final Value<int> debtId;
  final Value<String> peopleName;
  final Value<DateTime?> expectedToBeSettledDate;
  final Value<DateTime?> settledDate;
  const DebtsCompanion({
    this.debtId = const Value.absent(),
    this.peopleName = const Value.absent(),
    this.expectedToBeSettledDate = const Value.absent(),
    this.settledDate = const Value.absent(),
  });
  DebtsCompanion.insert({
    this.debtId = const Value.absent(),
    required String peopleName,
    this.expectedToBeSettledDate = const Value.absent(),
    this.settledDate = const Value.absent(),
  }) : peopleName = Value(peopleName);
  static Insertable<Debt> custom({
    Expression<int>? debtId,
    Expression<String>? peopleName,
    Expression<DateTime>? expectedToBeSettledDate,
    Expression<DateTime>? settledDate,
  }) {
    return RawValuesInsertable({
      if (debtId != null) 'debt_id': debtId,
      if (peopleName != null) 'people_name': peopleName,
      if (expectedToBeSettledDate != null)
        'expected_to_be_settled_date': expectedToBeSettledDate,
      if (settledDate != null) 'settled_date': settledDate,
    });
  }

  DebtsCompanion copyWith(
      {Value<int>? debtId,
      Value<String>? peopleName,
      Value<DateTime?>? expectedToBeSettledDate,
      Value<DateTime?>? settledDate}) {
    return DebtsCompanion(
      debtId: debtId ?? this.debtId,
      peopleName: peopleName ?? this.peopleName,
      expectedToBeSettledDate:
          expectedToBeSettledDate ?? this.expectedToBeSettledDate,
      settledDate: settledDate ?? this.settledDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (debtId.present) {
      map['debt_id'] = Variable<int>(debtId.value);
    }
    if (peopleName.present) {
      map['people_name'] = Variable<String>(peopleName.value);
    }
    if (expectedToBeSettledDate.present) {
      map['expected_to_be_settled_date'] =
          Variable<DateTime>(expectedToBeSettledDate.value);
    }
    if (settledDate.present) {
      map['settled_date'] = Variable<DateTime>(settledDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DebtsCompanion(')
          ..write('debtId: $debtId, ')
          ..write('peopleName: $peopleName, ')
          ..write('expectedToBeSettledDate: $expectedToBeSettledDate, ')
          ..write('settledDate: $settledDate')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _transactionIdMeta =
      const VerificationMeta('transactionId');
  @override
  late final GeneratedColumn<int> transactionId = GeneratedColumn<int>(
      'transaction_id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _transactionNameMeta =
      const VerificationMeta('transactionName');
  @override
  late final GeneratedColumn<String> transactionName = GeneratedColumn<String>(
      'transaction_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
      'value', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _transactionDateMeta =
      const VerificationMeta('transactionDate');
  @override
  late final GeneratedColumn<DateTime> transactionDate =
      GeneratedColumn<DateTime>('transaction_date', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _transactionTypeMeta =
      const VerificationMeta('transactionType');
  @override
  late final GeneratedColumnWithTypeConverter<TransactionType, String>
      transactionType = GeneratedColumn<String>(
              'transaction_type', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<TransactionType>(
              $TransactionsTable.$convertertransactionType);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      'category_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES categories (category_id) ON UPDATE CASCADE ON DELETE CASCADE'));
  static const VerificationMeta _debtIdMeta = const VerificationMeta('debtId');
  @override
  late final GeneratedColumn<int> debtId = GeneratedColumn<int>(
      'debt_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES debts (debt_id) ON UPDATE CASCADE ON DELETE CASCADE'));
  @override
  List<GeneratedColumn> get $columns => [
        transactionId,
        transactionName,
        value,
        transactionDate,
        transactionType,
        description,
        categoryId,
        debtId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(Insertable<Transaction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('transaction_id')) {
      context.handle(
          _transactionIdMeta,
          transactionId.isAcceptableOrUnknown(
              data['transaction_id']!, _transactionIdMeta));
    }
    if (data.containsKey('transaction_name')) {
      context.handle(
          _transactionNameMeta,
          transactionName.isAcceptableOrUnknown(
              data['transaction_name']!, _transactionNameMeta));
    } else if (isInserting) {
      context.missing(_transactionNameMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('transaction_date')) {
      context.handle(
          _transactionDateMeta,
          transactionDate.isAcceptableOrUnknown(
              data['transaction_date']!, _transactionDateMeta));
    } else if (isInserting) {
      context.missing(_transactionDateMeta);
    }
    context.handle(_transactionTypeMeta, const VerificationResult.success());
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('debt_id')) {
      context.handle(_debtIdMeta,
          debtId.isAcceptableOrUnknown(data['debt_id']!, _debtIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {transactionId};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      transactionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}transaction_id'])!,
      transactionName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}transaction_name'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}value'])!,
      transactionDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}transaction_date'])!,
      transactionType: $TransactionsTable.$convertertransactionType.fromSql(
          attachedDatabase.typeMapping.read(DriftSqlType.string,
              data['${effectivePrefix}transaction_type'])!),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category_id'])!,
      debtId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}debt_id']),
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TransactionType, String, String>
      $convertertransactionType =
      const EnumNameConverter<TransactionType>(TransactionType.values);
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final int transactionId;
  final String transactionName;
  final double value;
  final DateTime transactionDate;
  final TransactionType transactionType;
  final String? description;
  final int categoryId;
  final int? debtId;
  const Transaction(
      {required this.transactionId,
      required this.transactionName,
      required this.value,
      required this.transactionDate,
      required this.transactionType,
      this.description,
      required this.categoryId,
      this.debtId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['transaction_id'] = Variable<int>(transactionId);
    map['transaction_name'] = Variable<String>(transactionName);
    map['value'] = Variable<double>(value);
    map['transaction_date'] = Variable<DateTime>(transactionDate);
    {
      map['transaction_type'] = Variable<String>(
          $TransactionsTable.$convertertransactionType.toSql(transactionType));
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['category_id'] = Variable<int>(categoryId);
    if (!nullToAbsent || debtId != null) {
      map['debt_id'] = Variable<int>(debtId);
    }
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      transactionId: Value(transactionId),
      transactionName: Value(transactionName),
      value: Value(value),
      transactionDate: Value(transactionDate),
      transactionType: Value(transactionType),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      categoryId: Value(categoryId),
      debtId:
          debtId == null && nullToAbsent ? const Value.absent() : Value(debtId),
    );
  }

  factory Transaction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      transactionId: serializer.fromJson<int>(json['transactionId']),
      transactionName: serializer.fromJson<String>(json['transactionName']),
      value: serializer.fromJson<double>(json['value']),
      transactionDate: serializer.fromJson<DateTime>(json['transactionDate']),
      transactionType: $TransactionsTable.$convertertransactionType
          .fromJson(serializer.fromJson<String>(json['transactionType'])),
      description: serializer.fromJson<String?>(json['description']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      debtId: serializer.fromJson<int?>(json['debtId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'transactionId': serializer.toJson<int>(transactionId),
      'transactionName': serializer.toJson<String>(transactionName),
      'value': serializer.toJson<double>(value),
      'transactionDate': serializer.toJson<DateTime>(transactionDate),
      'transactionType': serializer.toJson<String>(
          $TransactionsTable.$convertertransactionType.toJson(transactionType)),
      'description': serializer.toJson<String?>(description),
      'categoryId': serializer.toJson<int>(categoryId),
      'debtId': serializer.toJson<int?>(debtId),
    };
  }

  Transaction copyWith(
          {int? transactionId,
          String? transactionName,
          double? value,
          DateTime? transactionDate,
          TransactionType? transactionType,
          Value<String?> description = const Value.absent(),
          int? categoryId,
          Value<int?> debtId = const Value.absent()}) =>
      Transaction(
        transactionId: transactionId ?? this.transactionId,
        transactionName: transactionName ?? this.transactionName,
        value: value ?? this.value,
        transactionDate: transactionDate ?? this.transactionDate,
        transactionType: transactionType ?? this.transactionType,
        description: description.present ? description.value : this.description,
        categoryId: categoryId ?? this.categoryId,
        debtId: debtId.present ? debtId.value : this.debtId,
      );
  Transaction copyWithCompanion(TransactionsCompanion data) {
    return Transaction(
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      transactionName: data.transactionName.present
          ? data.transactionName.value
          : this.transactionName,
      value: data.value.present ? data.value.value : this.value,
      transactionDate: data.transactionDate.present
          ? data.transactionDate.value
          : this.transactionDate,
      transactionType: data.transactionType.present
          ? data.transactionType.value
          : this.transactionType,
      description:
          data.description.present ? data.description.value : this.description,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      debtId: data.debtId.present ? data.debtId.value : this.debtId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('transactionId: $transactionId, ')
          ..write('transactionName: $transactionName, ')
          ..write('value: $value, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('transactionType: $transactionType, ')
          ..write('description: $description, ')
          ..write('categoryId: $categoryId, ')
          ..write('debtId: $debtId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(transactionId, transactionName, value,
      transactionDate, transactionType, description, categoryId, debtId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.transactionId == this.transactionId &&
          other.transactionName == this.transactionName &&
          other.value == this.value &&
          other.transactionDate == this.transactionDate &&
          other.transactionType == this.transactionType &&
          other.description == this.description &&
          other.categoryId == this.categoryId &&
          other.debtId == this.debtId);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<int> transactionId;
  final Value<String> transactionName;
  final Value<double> value;
  final Value<DateTime> transactionDate;
  final Value<TransactionType> transactionType;
  final Value<String?> description;
  final Value<int> categoryId;
  final Value<int?> debtId;
  const TransactionsCompanion({
    this.transactionId = const Value.absent(),
    this.transactionName = const Value.absent(),
    this.value = const Value.absent(),
    this.transactionDate = const Value.absent(),
    this.transactionType = const Value.absent(),
    this.description = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.debtId = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.transactionId = const Value.absent(),
    required String transactionName,
    required double value,
    required DateTime transactionDate,
    required TransactionType transactionType,
    this.description = const Value.absent(),
    required int categoryId,
    this.debtId = const Value.absent(),
  })  : transactionName = Value(transactionName),
        value = Value(value),
        transactionDate = Value(transactionDate),
        transactionType = Value(transactionType),
        categoryId = Value(categoryId);
  static Insertable<Transaction> custom({
    Expression<int>? transactionId,
    Expression<String>? transactionName,
    Expression<double>? value,
    Expression<DateTime>? transactionDate,
    Expression<String>? transactionType,
    Expression<String>? description,
    Expression<int>? categoryId,
    Expression<int>? debtId,
  }) {
    return RawValuesInsertable({
      if (transactionId != null) 'transaction_id': transactionId,
      if (transactionName != null) 'transaction_name': transactionName,
      if (value != null) 'value': value,
      if (transactionDate != null) 'transaction_date': transactionDate,
      if (transactionType != null) 'transaction_type': transactionType,
      if (description != null) 'description': description,
      if (categoryId != null) 'category_id': categoryId,
      if (debtId != null) 'debt_id': debtId,
    });
  }

  TransactionsCompanion copyWith(
      {Value<int>? transactionId,
      Value<String>? transactionName,
      Value<double>? value,
      Value<DateTime>? transactionDate,
      Value<TransactionType>? transactionType,
      Value<String?>? description,
      Value<int>? categoryId,
      Value<int?>? debtId}) {
    return TransactionsCompanion(
      transactionId: transactionId ?? this.transactionId,
      transactionName: transactionName ?? this.transactionName,
      value: value ?? this.value,
      transactionDate: transactionDate ?? this.transactionDate,
      transactionType: transactionType ?? this.transactionType,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      debtId: debtId ?? this.debtId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (transactionId.present) {
      map['transaction_id'] = Variable<int>(transactionId.value);
    }
    if (transactionName.present) {
      map['transaction_name'] = Variable<String>(transactionName.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (transactionDate.present) {
      map['transaction_date'] = Variable<DateTime>(transactionDate.value);
    }
    if (transactionType.present) {
      map['transaction_type'] = Variable<String>($TransactionsTable
          .$convertertransactionType
          .toSql(transactionType.value));
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (debtId.present) {
      map['debt_id'] = Variable<int>(debtId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('transactionId: $transactionId, ')
          ..write('transactionName: $transactionName, ')
          ..write('value: $value, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('transactionType: $transactionType, ')
          ..write('description: $description, ')
          ..write('categoryId: $categoryId, ')
          ..write('debtId: $debtId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $BudgetsTable budgets = $BudgetsTable(this);
  late final $DebtsTable debts = $DebtsTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [categories, budgets, debts, transactions];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('categories',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('budgets', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('categories',
                limitUpdateKind: UpdateKind.update),
            result: [
              TableUpdate('budgets', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('categories',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('transactions', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('categories',
                limitUpdateKind: UpdateKind.update),
            result: [
              TableUpdate('transactions', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('debts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('transactions', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('debts',
                limitUpdateKind: UpdateKind.update),
            result: [
              TableUpdate('transactions', kind: UpdateKind.update),
            ],
          ),
        ],
      );
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  Value<int> categoryId,
  required String categoryName,
  required CategoryType categoryType,
  required DateTime createdAt,
  Value<DateTime?> updatedAt,
  Value<DateTime?> deletedAt,
  Value<bool> isProtected,
  Value<String?> additionalInformation,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<int> categoryId,
  Value<String> categoryName,
  Value<CategoryType> categoryType,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
  Value<DateTime?> deletedAt,
  Value<bool> isProtected,
  Value<String?> additionalInformation,
});

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, Category> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BudgetsTable, List<Budget>> _budgetsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.budgets,
          aliasName: $_aliasNameGenerator(
              db.categories.categoryId, db.budgets.categoryId));

  $$BudgetsTableProcessedTableManager get budgetsRefs {
    final manager = $$BudgetsTableTableManager($_db, $_db.budgets)
        .filter((f) => f.categoryId.categoryId($_item.categoryId));

    final cache = $_typedResult.readTableOrNull(_budgetsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
      _transactionsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.transactions,
              aliasName: $_aliasNameGenerator(
                  db.categories.categoryId, db.transactions.categoryId));

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager($_db, $_db.transactions)
        .filter((f) => f.categoryId.categoryId($_item.categoryId));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CategoriesTableFilterComposer
    extends FilterComposer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer(super.$state);
  ColumnFilters<int> get categoryId => $state.composableBuilder(
      column: $state.table.categoryId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get categoryName => $state.composableBuilder(
      column: $state.table.categoryName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<CategoryType, CategoryType, String>
      get categoryType => $state.composableBuilder(
          column: $state.table.categoryType,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get deletedAt => $state.composableBuilder(
      column: $state.table.deletedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isProtected => $state.composableBuilder(
      column: $state.table.isProtected,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get additionalInformation => $state.composableBuilder(
      column: $state.table.additionalInformation,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter budgetsRefs(
      ComposableFilter Function($$BudgetsTableFilterComposer f) f) {
    final $$BudgetsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $state.db.budgets,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder, parentComposers) => $$BudgetsTableFilterComposer(
            ComposerState(
                $state.db, $state.db.budgets, joinBuilder, parentComposers)));
    return f(composer);
  }

  ComposableFilter transactionsRefs(
      ComposableFilter Function($$TransactionsTableFilterComposer f) f) {
    final $$TransactionsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $state.db.transactions,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder, parentComposers) =>
            $$TransactionsTableFilterComposer(ComposerState($state.db,
                $state.db.transactions, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer(super.$state);
  ColumnOrderings<int> get categoryId => $state.composableBuilder(
      column: $state.table.categoryId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get categoryName => $state.composableBuilder(
      column: $state.table.categoryName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get categoryType => $state.composableBuilder(
      column: $state.table.categoryType,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get deletedAt => $state.composableBuilder(
      column: $state.table.deletedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isProtected => $state.composableBuilder(
      column: $state.table.isProtected,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get additionalInformation => $state.composableBuilder(
      column: $state.table.additionalInformation,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $$CategoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CategoriesTable,
    Category,
    $$CategoriesTableFilterComposer,
    $$CategoriesTableOrderingComposer,
    $$CategoriesTableCreateCompanionBuilder,
    $$CategoriesTableUpdateCompanionBuilder,
    (Category, $$CategoriesTableReferences),
    Category,
    PrefetchHooks Function({bool budgetsRefs, bool transactionsRefs})> {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$CategoriesTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$CategoriesTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> categoryId = const Value.absent(),
            Value<String> categoryName = const Value.absent(),
            Value<CategoryType> categoryType = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<bool> isProtected = const Value.absent(),
            Value<String?> additionalInformation = const Value.absent(),
          }) =>
              CategoriesCompanion(
            categoryId: categoryId,
            categoryName: categoryName,
            categoryType: categoryType,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            isProtected: isProtected,
            additionalInformation: additionalInformation,
          ),
          createCompanionCallback: ({
            Value<int> categoryId = const Value.absent(),
            required String categoryName,
            required CategoryType categoryType,
            required DateTime createdAt,
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<bool> isProtected = const Value.absent(),
            Value<String?> additionalInformation = const Value.absent(),
          }) =>
              CategoriesCompanion.insert(
            categoryId: categoryId,
            categoryName: categoryName,
            categoryType: categoryType,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            isProtected: isProtected,
            additionalInformation: additionalInformation,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CategoriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {budgetsRefs = false, transactionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (budgetsRefs) db.budgets,
                if (transactionsRefs) db.transactions
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (budgetsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$CategoriesTableReferences._budgetsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CategoriesTableReferences(db, table, p0)
                                .budgetsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.categoryId == item.categoryId),
                        typedResults: items),
                  if (transactionsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$CategoriesTableReferences
                            ._transactionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CategoriesTableReferences(db, table, p0)
                                .transactionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.categoryId == item.categoryId),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CategoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CategoriesTable,
    Category,
    $$CategoriesTableFilterComposer,
    $$CategoriesTableOrderingComposer,
    $$CategoriesTableCreateCompanionBuilder,
    $$CategoriesTableUpdateCompanionBuilder,
    (Category, $$CategoriesTableReferences),
    Category,
    PrefetchHooks Function({bool budgetsRefs, bool transactionsRefs})>;
typedef $$BudgetsTableCreateCompanionBuilder = BudgetsCompanion Function({
  Value<int> budgetId,
  required String budgetName,
  required double budgetedValue,
  required DateTime dateCreated,
  required DateTime dateUpdated,
  required DateTime startDate,
  required DateTime endDate,
  required int categoryId,
});
typedef $$BudgetsTableUpdateCompanionBuilder = BudgetsCompanion Function({
  Value<int> budgetId,
  Value<String> budgetName,
  Value<double> budgetedValue,
  Value<DateTime> dateCreated,
  Value<DateTime> dateUpdated,
  Value<DateTime> startDate,
  Value<DateTime> endDate,
  Value<int> categoryId,
});

final class $$BudgetsTableReferences
    extends BaseReferences<_$AppDatabase, $BudgetsTable, Budget> {
  $$BudgetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias($_aliasNameGenerator(
          db.budgets.categoryId, db.categories.categoryId));

  $$CategoriesTableProcessedTableManager? get categoryId {
    if ($_item.categoryId == null) return null;
    final manager = $$CategoriesTableTableManager($_db, $_db.categories)
        .filter((f) => f.categoryId($_item.categoryId!));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$BudgetsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableFilterComposer(super.$state);
  ColumnFilters<int> get budgetId => $state.composableBuilder(
      column: $state.table.budgetId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get budgetName => $state.composableBuilder(
      column: $state.table.budgetName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get budgetedValue => $state.composableBuilder(
      column: $state.table.budgetedValue,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get dateCreated => $state.composableBuilder(
      column: $state.table.dateCreated,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get dateUpdated => $state.composableBuilder(
      column: $state.table.dateUpdated,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get startDate => $state.composableBuilder(
      column: $state.table.startDate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get endDate => $state.composableBuilder(
      column: $state.table.endDate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $state.db.categories,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder, parentComposers) =>
            $$CategoriesTableFilterComposer(ComposerState($state.db,
                $state.db.categories, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$BudgetsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get budgetId => $state.composableBuilder(
      column: $state.table.budgetId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get budgetName => $state.composableBuilder(
      column: $state.table.budgetName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get budgetedValue => $state.composableBuilder(
      column: $state.table.budgetedValue,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get dateCreated => $state.composableBuilder(
      column: $state.table.dateCreated,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get dateUpdated => $state.composableBuilder(
      column: $state.table.dateUpdated,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get startDate => $state.composableBuilder(
      column: $state.table.startDate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get endDate => $state.composableBuilder(
      column: $state.table.endDate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $state.db.categories,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder, parentComposers) =>
            $$CategoriesTableOrderingComposer(ComposerState($state.db,
                $state.db.categories, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$BudgetsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BudgetsTable,
    Budget,
    $$BudgetsTableFilterComposer,
    $$BudgetsTableOrderingComposer,
    $$BudgetsTableCreateCompanionBuilder,
    $$BudgetsTableUpdateCompanionBuilder,
    (Budget, $$BudgetsTableReferences),
    Budget,
    PrefetchHooks Function({bool categoryId})> {
  $$BudgetsTableTableManager(_$AppDatabase db, $BudgetsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$BudgetsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$BudgetsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> budgetId = const Value.absent(),
            Value<String> budgetName = const Value.absent(),
            Value<double> budgetedValue = const Value.absent(),
            Value<DateTime> dateCreated = const Value.absent(),
            Value<DateTime> dateUpdated = const Value.absent(),
            Value<DateTime> startDate = const Value.absent(),
            Value<DateTime> endDate = const Value.absent(),
            Value<int> categoryId = const Value.absent(),
          }) =>
              BudgetsCompanion(
            budgetId: budgetId,
            budgetName: budgetName,
            budgetedValue: budgetedValue,
            dateCreated: dateCreated,
            dateUpdated: dateUpdated,
            startDate: startDate,
            endDate: endDate,
            categoryId: categoryId,
          ),
          createCompanionCallback: ({
            Value<int> budgetId = const Value.absent(),
            required String budgetName,
            required double budgetedValue,
            required DateTime dateCreated,
            required DateTime dateUpdated,
            required DateTime startDate,
            required DateTime endDate,
            required int categoryId,
          }) =>
              BudgetsCompanion.insert(
            budgetId: budgetId,
            budgetName: budgetName,
            budgetedValue: budgetedValue,
            dateCreated: dateCreated,
            dateUpdated: dateUpdated,
            startDate: startDate,
            endDate: endDate,
            categoryId: categoryId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$BudgetsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({categoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (categoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.categoryId,
                    referencedTable:
                        $$BudgetsTableReferences._categoryIdTable(db),
                    referencedColumn: $$BudgetsTableReferences
                        ._categoryIdTable(db)
                        .categoryId,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$BudgetsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BudgetsTable,
    Budget,
    $$BudgetsTableFilterComposer,
    $$BudgetsTableOrderingComposer,
    $$BudgetsTableCreateCompanionBuilder,
    $$BudgetsTableUpdateCompanionBuilder,
    (Budget, $$BudgetsTableReferences),
    Budget,
    PrefetchHooks Function({bool categoryId})>;
typedef $$DebtsTableCreateCompanionBuilder = DebtsCompanion Function({
  Value<int> debtId,
  required String peopleName,
  Value<DateTime?> expectedToBeSettledDate,
  Value<DateTime?> settledDate,
});
typedef $$DebtsTableUpdateCompanionBuilder = DebtsCompanion Function({
  Value<int> debtId,
  Value<String> peopleName,
  Value<DateTime?> expectedToBeSettledDate,
  Value<DateTime?> settledDate,
});

final class $$DebtsTableReferences
    extends BaseReferences<_$AppDatabase, $DebtsTable, Debt> {
  $$DebtsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
      _transactionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.transactions,
          aliasName:
              $_aliasNameGenerator(db.debts.debtId, db.transactions.debtId));

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager($_db, $_db.transactions)
        .filter((f) => f.debtId.debtId($_item.debtId));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$DebtsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $DebtsTable> {
  $$DebtsTableFilterComposer(super.$state);
  ColumnFilters<int> get debtId => $state.composableBuilder(
      column: $state.table.debtId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get peopleName => $state.composableBuilder(
      column: $state.table.peopleName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get expectedToBeSettledDate =>
      $state.composableBuilder(
          column: $state.table.expectedToBeSettledDate,
          builder: (column, joinBuilders) =>
              ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get settledDate => $state.composableBuilder(
      column: $state.table.settledDate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter transactionsRefs(
      ComposableFilter Function($$TransactionsTableFilterComposer f) f) {
    final $$TransactionsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.debtId,
        referencedTable: $state.db.transactions,
        getReferencedColumn: (t) => t.debtId,
        builder: (joinBuilder, parentComposers) =>
            $$TransactionsTableFilterComposer(ComposerState($state.db,
                $state.db.transactions, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$DebtsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $DebtsTable> {
  $$DebtsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get debtId => $state.composableBuilder(
      column: $state.table.debtId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get peopleName => $state.composableBuilder(
      column: $state.table.peopleName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get expectedToBeSettledDate => $state
      .composableBuilder(
          column: $state.table.expectedToBeSettledDate,
          builder: (column, joinBuilders) =>
              ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get settledDate => $state.composableBuilder(
      column: $state.table.settledDate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $$DebtsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DebtsTable,
    Debt,
    $$DebtsTableFilterComposer,
    $$DebtsTableOrderingComposer,
    $$DebtsTableCreateCompanionBuilder,
    $$DebtsTableUpdateCompanionBuilder,
    (Debt, $$DebtsTableReferences),
    Debt,
    PrefetchHooks Function({bool transactionsRefs})> {
  $$DebtsTableTableManager(_$AppDatabase db, $DebtsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$DebtsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$DebtsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> debtId = const Value.absent(),
            Value<String> peopleName = const Value.absent(),
            Value<DateTime?> expectedToBeSettledDate = const Value.absent(),
            Value<DateTime?> settledDate = const Value.absent(),
          }) =>
              DebtsCompanion(
            debtId: debtId,
            peopleName: peopleName,
            expectedToBeSettledDate: expectedToBeSettledDate,
            settledDate: settledDate,
          ),
          createCompanionCallback: ({
            Value<int> debtId = const Value.absent(),
            required String peopleName,
            Value<DateTime?> expectedToBeSettledDate = const Value.absent(),
            Value<DateTime?> settledDate = const Value.absent(),
          }) =>
              DebtsCompanion.insert(
            debtId: debtId,
            peopleName: peopleName,
            expectedToBeSettledDate: expectedToBeSettledDate,
            settledDate: settledDate,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$DebtsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({transactionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (transactionsRefs) db.transactions],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transactionsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$DebtsTableReferences._transactionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DebtsTableReferences(db, table, p0)
                                .transactionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.debtId == item.debtId),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$DebtsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DebtsTable,
    Debt,
    $$DebtsTableFilterComposer,
    $$DebtsTableOrderingComposer,
    $$DebtsTableCreateCompanionBuilder,
    $$DebtsTableUpdateCompanionBuilder,
    (Debt, $$DebtsTableReferences),
    Debt,
    PrefetchHooks Function({bool transactionsRefs})>;
typedef $$TransactionsTableCreateCompanionBuilder = TransactionsCompanion
    Function({
  Value<int> transactionId,
  required String transactionName,
  required double value,
  required DateTime transactionDate,
  required TransactionType transactionType,
  Value<String?> description,
  required int categoryId,
  Value<int?> debtId,
});
typedef $$TransactionsTableUpdateCompanionBuilder = TransactionsCompanion
    Function({
  Value<int> transactionId,
  Value<String> transactionName,
  Value<double> value,
  Value<DateTime> transactionDate,
  Value<TransactionType> transactionType,
  Value<String?> description,
  Value<int> categoryId,
  Value<int?> debtId,
});

final class $$TransactionsTableReferences
    extends BaseReferences<_$AppDatabase, $TransactionsTable, Transaction> {
  $$TransactionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias($_aliasNameGenerator(
          db.transactions.categoryId, db.categories.categoryId));

  $$CategoriesTableProcessedTableManager? get categoryId {
    if ($_item.categoryId == null) return null;
    final manager = $$CategoriesTableTableManager($_db, $_db.categories)
        .filter((f) => f.categoryId($_item.categoryId!));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $DebtsTable _debtIdTable(_$AppDatabase db) => db.debts.createAlias(
      $_aliasNameGenerator(db.transactions.debtId, db.debts.debtId));

  $$DebtsTableProcessedTableManager? get debtId {
    if ($_item.debtId == null) return null;
    final manager = $$DebtsTableTableManager($_db, $_db.debts)
        .filter((f) => f.debtId($_item.debtId!));
    final item = $_typedResult.readTableOrNull(_debtIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$TransactionsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer(super.$state);
  ColumnFilters<int> get transactionId => $state.composableBuilder(
      column: $state.table.transactionId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get transactionName => $state.composableBuilder(
      column: $state.table.transactionName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get value => $state.composableBuilder(
      column: $state.table.value,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get transactionDate => $state.composableBuilder(
      column: $state.table.transactionDate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<TransactionType, TransactionType, String>
      get transactionType => $state.composableBuilder(
          column: $state.table.transactionType,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $state.db.categories,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder, parentComposers) =>
            $$CategoriesTableFilterComposer(ComposerState($state.db,
                $state.db.categories, joinBuilder, parentComposers)));
    return composer;
  }

  $$DebtsTableFilterComposer get debtId {
    final $$DebtsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.debtId,
        referencedTable: $state.db.debts,
        getReferencedColumn: (t) => t.debtId,
        builder: (joinBuilder, parentComposers) => $$DebtsTableFilterComposer(
            ComposerState(
                $state.db, $state.db.debts, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$TransactionsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get transactionId => $state.composableBuilder(
      column: $state.table.transactionId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get transactionName => $state.composableBuilder(
      column: $state.table.transactionName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get value => $state.composableBuilder(
      column: $state.table.value,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get transactionDate => $state.composableBuilder(
      column: $state.table.transactionDate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get transactionType => $state.composableBuilder(
      column: $state.table.transactionType,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $state.db.categories,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder, parentComposers) =>
            $$CategoriesTableOrderingComposer(ComposerState($state.db,
                $state.db.categories, joinBuilder, parentComposers)));
    return composer;
  }

  $$DebtsTableOrderingComposer get debtId {
    final $$DebtsTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.debtId,
        referencedTable: $state.db.debts,
        getReferencedColumn: (t) => t.debtId,
        builder: (joinBuilder, parentComposers) => $$DebtsTableOrderingComposer(
            ComposerState(
                $state.db, $state.db.debts, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$TransactionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TransactionsTable,
    Transaction,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (Transaction, $$TransactionsTableReferences),
    Transaction,
    PrefetchHooks Function({bool categoryId, bool debtId})> {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$TransactionsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$TransactionsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> transactionId = const Value.absent(),
            Value<String> transactionName = const Value.absent(),
            Value<double> value = const Value.absent(),
            Value<DateTime> transactionDate = const Value.absent(),
            Value<TransactionType> transactionType = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<int> categoryId = const Value.absent(),
            Value<int?> debtId = const Value.absent(),
          }) =>
              TransactionsCompanion(
            transactionId: transactionId,
            transactionName: transactionName,
            value: value,
            transactionDate: transactionDate,
            transactionType: transactionType,
            description: description,
            categoryId: categoryId,
            debtId: debtId,
          ),
          createCompanionCallback: ({
            Value<int> transactionId = const Value.absent(),
            required String transactionName,
            required double value,
            required DateTime transactionDate,
            required TransactionType transactionType,
            Value<String?> description = const Value.absent(),
            required int categoryId,
            Value<int?> debtId = const Value.absent(),
          }) =>
              TransactionsCompanion.insert(
            transactionId: transactionId,
            transactionName: transactionName,
            value: value,
            transactionDate: transactionDate,
            transactionType: transactionType,
            description: description,
            categoryId: categoryId,
            debtId: debtId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$TransactionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({categoryId = false, debtId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (categoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.categoryId,
                    referencedTable:
                        $$TransactionsTableReferences._categoryIdTable(db),
                    referencedColumn: $$TransactionsTableReferences
                        ._categoryIdTable(db)
                        .categoryId,
                  ) as T;
                }
                if (debtId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.debtId,
                    referencedTable:
                        $$TransactionsTableReferences._debtIdTable(db),
                    referencedColumn:
                        $$TransactionsTableReferences._debtIdTable(db).debtId,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$TransactionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TransactionsTable,
    Transaction,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (Transaction, $$TransactionsTableReferences),
    Transaction,
    PrefetchHooks Function({bool categoryId, bool debtId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$BudgetsTableTableManager get budgets =>
      $$BudgetsTableTableManager(_db, _db.budgets);
  $$DebtsTableTableManager get debts =>
      $$DebtsTableTableManager(_db, _db.debts);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
}
