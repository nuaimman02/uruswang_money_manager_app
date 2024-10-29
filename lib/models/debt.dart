import 'package:drift/drift.dart';

class Debts extends Table {
  IntColumn get debtId => integer().autoIncrement()();
  TextColumn get peopleName => text()();
  DateTimeColumn get expectedToBeSettledDate => dateTime().nullable()();
  DateTimeColumn get settledDate => dateTime().nullable()();
  //BoolColumn get isNeedToNotify => boolean().withDefault(const Constant(true))();
}