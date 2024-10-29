import 'dart:async';

import 'package:drift/drift.dart';

import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:uruswang_money_manager_app/models/budget.dart';
import 'package:uruswang_money_manager_app/models/category.dart';
import 'package:uruswang_money_manager_app/models/debt.dart';
import 'package:uruswang_money_manager_app/models/transaction.dart';
import 'dart:developer' as developer;

import 'package:uruswang_money_manager_app/services/model_service/category_service.dart';
import 'package:uruswang_money_manager_app/services/model_service/transactions_with_categories_and_debts_service.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Categories, Budgets, Transactions, Debts])
class AppDatabase extends _$AppDatabase {
  // After generating code, this class needs to define a `schemaVersion` getter
  // and a constructor telling drift where the database should be stored.
  // These are described in the getting started guide: https://drift.simonbinder.eu/getting-started/#ope
  AppDatabase() : super(_openConnection());

  final GetIt _getIt = GetIt.instance;
  late final CategoryService _categoryService = _getIt.get<CategoryService>();
  late final TransactionsWithCategoriesAndDebtsService _transactionsWithCategoriesAndDebtService = _getIt.get<TransactionsWithCategoriesAndDebtsService>();

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {  /// NAK SAMBUNG LEPAS NI KENA CHECK DATABASE ADA KE TAK BILA DEBUG
    return MigrationStrategy(
      onCreate: (m) async {
        if(!kDebugMode) {
          //Enabled when app is function correctly
          await m.createAll();
          await _categoryService.initializeCategories();
        }
      },
      beforeOpen: (details) async {
        if(kDebugMode) { // Include code in this if statement if you want to develop app
          final m = Migrator(this);
          
          for(final table in allTables) {
            await m.deleteTable(table.actualTableName);
            await m.createTable(table);
          }

          await initializeDatabaseForDevelopingV1(this);

            // After pre-populating, schedule notifications
          await  _transactionsWithCategoriesAndDebtService.schedulePrePopulatedDebtNotifications();
        }
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }

  static QueryExecutor _openConnection() {
    // `driftDatabase` from `package:drift_flutter` stores the database in
    // `getApplicationDocumentsDirectory()`.
    return driftDatabase(name: 'my_database').interceptWith(LogInterceptor());
  }
  
  /// Initialize the database with pre-populated data for development
  Future<void> initializeDatabaseForDevelopingV1(AppDatabase db) async {
    try {
      // Load the SQL file from assets
      final sql = await rootBundle.loadString('assets/populate_database_for_developing_v1.sql');
      
      for (final sqlStatement in splitSQLStatements(sql)) {
        await customStatement(sqlStatement);
      }

      developer.log("Database initialized with developer data.");
    } catch (e) {
      developer.log("Error during database initialization: $e");
    }
  }
}

List<String> splitSQLStatements(String sqliteStr) {
  return sqliteStr
      .split(RegExp(r';\s'))
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();
}

class LogInterceptor extends QueryInterceptor {
  Future<T> _run<T>(
      String description, FutureOr<T> Function() operation) async {
    final stopwatch = Stopwatch()..start();
    developer.log('Running $description');

    try {
      final result = await operation();
      developer.log(' => succeeded after ${stopwatch.elapsedMilliseconds}ms');
      return result;
    } on Object catch (e) {
      developer.log(' => failed after ${stopwatch.elapsedMilliseconds}ms ($e)');
      rethrow;
    }
  }

  @override
  TransactionExecutor beginTransaction(QueryExecutor parent) {
    developer.log('begin');
    return super.beginTransaction(parent);
  }

  @override
  Future<void> commitTransaction(TransactionExecutor inner) {
    return _run('commit', () => inner.send());
  }

  @override
  Future<void> rollbackTransaction(TransactionExecutor inner) {
    return _run('rollback', () => inner.rollback());
  }

  @override
  Future<void> runBatched(
      QueryExecutor executor, BatchedStatements statements) {
    return _run(
        'batch with $statements', () => executor.runBatched(statements));
  }

  @override
  Future<int> runInsert(
      QueryExecutor executor, String statement, List<Object?> args) {
    return _run(
        '$statement with $args', () => executor.runInsert(statement, args));
  }

  @override
  Future<int> runUpdate(
      QueryExecutor executor, String statement, List<Object?> args) {
    return _run(
        '$statement with $args', () => executor.runUpdate(statement, args));
  }

  @override
  Future<int> runDelete(
      QueryExecutor executor, String statement, List<Object?> args) {
    return _run(
        '$statement with $args', () => executor.runDelete(statement, args));
  }

  @override
  Future<void> runCustom(
      QueryExecutor executor, String statement, List<Object?> args) {
    return _run(
        '$statement with $args', () => executor.runCustom(statement, args));
  }

  @override
  Future<List<Map<String, Object?>>> runSelect(
      QueryExecutor executor, String statement, List<Object?> args) {
    return _run(
        '$statement with $args', () => executor.runSelect(statement, args));
  }
}