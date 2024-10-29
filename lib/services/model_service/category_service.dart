import 'package:drift/drift.dart';
import 'package:get_it/get_it.dart';
import 'package:uruswang_money_manager_app/models/category.dart';
import 'package:uruswang_money_manager_app/services/database_service/app_database.dart';
import 'dart:developer' as developer;

class CategoryService {
  final GetIt _getIt = GetIt.instance;
  late AppDatabase _appDatabase;

  CategoryService() {
    _appDatabase = _getIt.get<AppDatabase>();
  }

  Future<void> initializeCategories() async {
    // A category service
    final existingCategories = await _appDatabase.managers.categories.get();

    if (existingCategories.isEmpty) {
      await _appDatabase.transaction(() async {
        final expenseCategories = [
          {"name": "Food"},
          {"name": "Social Life"},
          {"name": "Self-development"},
          {"name": "Transportation"},
          {"name": "Entertainment"},
          {"name": "Household"},
          {"name": "Apparel"},
          {"name": "Beauty"},
          {"name": "Health"},
          {"name": "Education"},
          {"name": "Gift"},
          {"name": "Emergency"},
        ];

        final protectedExpenseCategories = [
          {"name": "Lending", "additionalinformation": "This category represents a transaction where you give money to someone else, creating a debt where the other person owes you money."},
          {"name": "Paying Debt", "additionalinformation": "This category represents a transaction where you settle a debt that you borrow from other person."},
        ];

        final incomeCategories = [
          {"name": "Allowance"},
          {"name": "Salary"},
          {"name": "Bonus"},
          {"name": "Dividend"},
        ];

        final protectedIncomeCategories = [
          {"name": "Borrowing", "additionalinformation": "This category represents a transaction where you receive money from someone, and now you owe them money, creating a debt."},
          {"name": "Receive Debt", "additionalinformation": "This category represents a transaction where other person settle a debt that they borrow from you."},
        ];

        try {
          await _appDatabase.batch((batch) {
            for (var category in expenseCategories) {
              batch.insert(
                  _appDatabase.categories,
                  CategoriesCompanion.insert(
                    categoryName: category['name']!,
                    categoryType: CategoryType.expense,
                    createdAt: DateTime.now(),
                  ));

              developer.log('All expense categories inserted');
            }
          });
        } catch (e) {
          developer.log('Error in inserting expense categories');
        }

        try {
          await _appDatabase.batch((batch) {
            for (var category in protectedExpenseCategories) {
              batch.insert(
                  _appDatabase.categories,
                  CategoriesCompanion.insert(
                      categoryName: category['name']!,
                      categoryType: CategoryType.expense,
                      createdAt: DateTime.now(),
                      isProtected: const Value(true),
                      additionalInformation: Value(category['additionalinformation'])));
            }
          });
        } catch (e) {
          developer.log('Error in inserting protected expense categories');
        }

        try {
          await _appDatabase.batch((batch) {
            for (var category in incomeCategories) {
              batch.insert(
                  _appDatabase.categories,
                  CategoriesCompanion.insert(
                    categoryName: category['name']!,
                    categoryType: CategoryType.income,
                    createdAt: DateTime.now(),
                  ));
            }
          });
        } catch (e) {
          developer.log('Error in inserting income categories');
        }

        try {
          await _appDatabase.batch((batch) {
            for (var category in protectedIncomeCategories) {
              batch.insert(
                  _appDatabase.categories,
                  CategoriesCompanion.insert(
                      categoryName: category['name']!,
                      categoryType: CategoryType.income,
                      createdAt: DateTime.now(),
                      isProtected: const Value(true),
                      additionalInformation: Value(category['additionalinformation'])));
            }
          });
        } catch (e) {
          developer.log('Error in inserting protected income categories');
        }
      });
    }
  }

  Stream<List<Category>> watchAllCategories() {
    // Category Service
    return _appDatabase.select(_appDatabase.categories).watch();
  }

  Stream<List<Category>> watchAllUnprotectedCategories() {
    return (_appDatabase.select(_appDatabase.categories)
    ..where((tbl) => tbl.isProtected.equals(false))
    ).watch();
  }

Stream<int?> watchCategoryId(String categoryName) {
  final query = _appDatabase.select(_appDatabase.categories)
    ..where((tbl) => tbl.categoryName.equals(categoryName));

  // Watch the query for real-time updates
  return query.watchSingleOrNull().map((row) {
    return row?.categoryId; // Return categoryId if the row exists
  });
}

  Future<int> getCategoryId(String categoryNameToSearch) async {
    final query = _appDatabase.select(_appDatabase.categories)
      ..where((tbl) => tbl.categoryName.equals(categoryNameToSearch));
    final category = await query.getSingle();
    return category.categoryId;
  }

  CategoryType parseCategoryType(String type) {
    return CategoryType.values.firstWhere((e) => e.name == type);
  }

  Future<String?> insertNewCategory(String newCategoryName,
      String newCategoryTypeString, DateTime newCategoryCreatedDate) async {
    try {
      CategoryType newCategoryType = parseCategoryType(newCategoryTypeString);
      final ableToInsert = await _validateCategoryUniqueness(newCategoryName, newCategoryType);
      
      if(ableToInsert == null) {
        await _appDatabase
          .into(_appDatabase.categories)
          .insert(CategoriesCompanion(
            categoryName: Value(newCategoryName),
            categoryType: Value(newCategoryType),
            createdAt: Value(newCategoryCreatedDate),
        ));
      } else {
        return ableToInsert;
      }
    } catch (e) {
      developer.log('$e');
    }
    return null;
  }

  Future<String?> updateCategoryInDatabase(int categoryIdToUpdate,
      String categoryNameToUpdate, CategoryType categoryTypeToUpdate,DateTime updatedDate) async {
    try {
      final ableToUpdate = await _validateCategoryUniqueness(categoryNameToUpdate, categoryTypeToUpdate);

      if(ableToUpdate == null) {
        await (_appDatabase.update(_appDatabase.categories)
            ..where(
                (category) => category.categoryId.equals(categoryIdToUpdate)))
          .write(
        CategoriesCompanion(
            categoryName: Value(categoryNameToUpdate),
            updatedAt: Value(updatedDate)),
      );
      developer.log('Category updated successfully');
      } else {
        return ableToUpdate;
      }
    } catch (e) {
      developer.log('Error updating category: $e');
    }
    return null;
  }

  Future<String?> _validateCategoryUniqueness(String categoryName, CategoryType categoryType) async {
  // Semak jika kategori dengan nama dan jenis yang sama wujud, termasuk yang soft delete
  final existingCategory = await (_appDatabase.select(_appDatabase.categories)
    ..where((category) => category.categoryName.equals(categoryName))
    ..where((category) => category.categoryType.equals(categoryType.name))
  ).getSingleOrNull();

  if (existingCategory != null) {
    return 'Category with this name for this income or expense type already exists, even if deleted. Try restore it at Restore Category Settings';
  }

  return null; // Kategori boleh dimasukkan jika tiada yang wujud
}

  Future<void> softDeleteCategory(int categoryIdToDelete) async {
    await (_appDatabase.update(_appDatabase.categories)
          ..where((category) => category.categoryId.equals(categoryIdToDelete)))
        .write(
      CategoriesCompanion(
        deletedAt:
            Value(DateTime.now()), // Tandakan kategori ini sebagai "deleted"
      ),
    );
  }

  Future<void> restoreCategory(int categoryIdToBeRestored) async {
    await (_appDatabase.update(_appDatabase.categories)
          ..where(
              (category) => category.categoryId.equals(categoryIdToBeRestored)))
        .write(
      const CategoriesCompanion(
        deletedAt: Value(null), // Set semula kepada null untuk aktifkan semula kategori
      ),
    );
  }

  Future<void> deleteCategory(int categoryIdToBeDeleted) async {
    await (_appDatabase.delete(_appDatabase.categories)
    ..where((category) => category.categoryId.equals(categoryIdToBeDeleted))
    ).go();
  }
}
