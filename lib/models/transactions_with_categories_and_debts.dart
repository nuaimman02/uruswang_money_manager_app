import 'package:uruswang_money_manager_app/services/database_service/app_database.dart';

class TransactionsWithCategoriesAndDebts{
  
  TransactionsWithCategoriesAndDebts(this.transactions, this.categories, this.debts);

  final Transaction transactions;
  final Category categories;
  final Debt? debts;

}