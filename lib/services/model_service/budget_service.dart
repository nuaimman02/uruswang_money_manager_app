import 'package:drift/drift.dart';
import 'package:get_it/get_it.dart';
import 'package:uruswang_money_manager_app/services/database_service/app_database.dart';

class BudgetService {

  final GetIt _getIt = GetIt.instance;
  late AppDatabase _appDatabase;

  BudgetService() {
    _appDatabase = _getIt.get<AppDatabase>();
  }
  
  Stream<List<Budget>> watchAllBudgetsForCurrentMonth(DateTime currentDate) {
    final firstDayOfMonth = DateTime(currentDate.year, currentDate.month, 1);
    final firstDayOfNextMonth = currentDate.month == 12 ? DateTime(currentDate.year + 1, 1, 1) : DateTime(currentDate.year, currentDate.month + 1, 1);
  
    return (_appDatabase.select(_appDatabase.budgets)
        ..where((budget) =>
            budget.startDate.isSmallerThanValue(firstDayOfNextMonth) &
            budget.startDate.isBiggerOrEqualValue(firstDayOfMonth)))
      .watch(); 
  }

  Stream<Budget> getBudgetById(int budgetIdToGet) {
    final query = _appDatabase.select(_appDatabase.budgets)
      ..where((tbl) => tbl.budgetId.equals(budgetIdToGet));
      
    // return query.watchSingle().map((budgetRecord) {
    //   if (budgetRecord != null) {
    //     return Budget(
    //       budgetId: budgetRecord.budgetId,
    //       budgetedValue: budgetRecord.budgetedValue,
    //       startDate: budgetRecord.startDate,
    //       categoryId: budgetRecord.categoryId,
    //       // Include any other fields you need
    //     );
    //   } else {
    //     throw Exception('Budget not found');
    //   }
    // });

    return query.watchSingle();
  }

  Future<int> insertBudget(BudgetsCompanion newBudgetCompanion) async {
    return _appDatabase.into(_appDatabase.budgets).insert(newBudgetCompanion);
  }

  Future<int> updateBudget(int budgetId, BudgetsCompanion updatedBudgetCompanion) async {
    return (_appDatabase.update(_appDatabase.budgets)
      ..where((tbl) => tbl.budgetId.equals(budgetId)))
      .write(updatedBudgetCompanion);
  }

  Future<void> deleteBudget(int budgetId) async {
    await (_appDatabase.delete(_appDatabase.budgets)
      ..where((tbl) => tbl.budgetId.equals(budgetId))
    ).go();
  }
}