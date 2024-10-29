
import 'package:drift/drift.dart';

enum CategoryType {
  income,
  expense;
  
}

class Categories extends Table {
  @override
  List<Set<Column>> get uniqueKeys => [{categoryName, categoryType}];

  IntColumn get categoryId => integer().autoIncrement()();
  TextColumn get categoryName => text()();
  TextColumn get categoryType => textEnum<CategoryType>()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  BoolColumn get isProtected => boolean().withDefault(const Constant(false))();
  TextColumn get additionalInformation => text().nullable()();
}