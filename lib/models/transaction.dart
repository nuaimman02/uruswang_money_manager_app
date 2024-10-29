import 'package:drift/drift.dart';
import 'package:uruswang_money_manager_app/models/category.dart';
import 'package:uruswang_money_manager_app/models/debt.dart';

enum TransactionType {
  income,
  expense;
}

class Transactions extends Table{
  IntColumn get transactionId => integer().autoIncrement()();
  TextColumn get transactionName => text()();
  RealColumn get value => real()();
  DateTimeColumn get transactionDate => dateTime()();
  TextColumn get transactionType => textEnum<TransactionType>()();
  TextColumn get description => text().nullable()();
  IntColumn get categoryId => integer().references(Categories, #categoryId, onUpdate: KeyAction.cascade, onDelete: KeyAction.cascade)();
  IntColumn get debtId => integer().nullable().references(Debts, #debtId, onUpdate: KeyAction.cascade, onDelete: KeyAction.cascade)();
}