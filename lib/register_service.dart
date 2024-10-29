import 'package:get_it/get_it.dart';
import 'package:uruswang_money_manager_app/services/database_service/app_database.dart';
import 'package:uruswang_money_manager_app/services/model_service/budget_service.dart';
import 'package:uruswang_money_manager_app/services/model_service/category_service.dart';
import 'package:uruswang_money_manager_app/services/model_service/date_and_time_formatter_service.dart';
import 'package:uruswang_money_manager_app/services/model_service/debt_service.dart';
import 'package:uruswang_money_manager_app/services/model_service/transaction_service.dart';
import 'package:uruswang_money_manager_app/services/model_service/transactions_with_categories_and_debts_service.dart';
import 'package:uruswang_money_manager_app/services/navigation_service.dart';

Future<void> registerServices() async {
  final GetIt getIt = GetIt.instance;
  getIt.registerSingleton<NavigationService>(NavigationService());
  getIt.registerSingleton<AppDatabase>(AppDatabase());
  getIt.registerSingleton<DateAndTimeFormatterService>(DateAndTimeFormatterService());
  getIt.registerSingleton<CategoryService>(CategoryService());
  getIt.registerSingleton<TransactionService>(TransactionService());
  getIt.registerSingleton<TransactionsWithCategoriesAndDebtsService>(TransactionsWithCategoriesAndDebtsService());
  getIt.registerSingleton<DebtService>(DebtService());
  getIt.registerSingleton<BudgetService>(BudgetService());
}