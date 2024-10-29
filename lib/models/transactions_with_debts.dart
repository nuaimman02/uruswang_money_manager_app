import 'package:uruswang_money_manager_app/services/database_service/app_database.dart';

class TransactionsWithDebts {
  TransactionsWithDebts(this.transactions, this.debts);

  final Transaction transactions;
  final Debt? debts;
}