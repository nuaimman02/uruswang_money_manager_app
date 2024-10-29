import 'package:drift/drift.dart';
import 'package:uruswang_money_manager_app/models/category.dart';

class Budgets extends Table{
  IntColumn get budgetId => integer().autoIncrement()();
  TextColumn get budgetName => text()();
  RealColumn get budgetedValue => real()();
  DateTimeColumn get dateUpdated => dateTime()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  IntColumn get categoryId => integer().references(Categories, #categoryId, onUpdate: KeyAction.cascade, onDelete: KeyAction.cascade)();
  //IntColumn get categoryId => integer().customConstraint("REFERENCES categories(category_id) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL")();
}