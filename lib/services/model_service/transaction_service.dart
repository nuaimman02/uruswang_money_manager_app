import 'package:drift/drift.dart';
import 'package:get_it/get_it.dart';
import 'package:uruswang_money_manager_app/services/database_service/app_database.dart';

class TransactionService {
  final GetIt _getIt = GetIt.instance;
  late AppDatabase _appDatabase;

  TransactionService() {
    _appDatabase = _getIt.get<AppDatabase>();
  }

  Future<int> updateTransaction(int transactionId, TransactionsCompanion updatedTransactionCompanion) async {
    return (_appDatabase.update(_appDatabase.transactions)
      ..where((tbl) => tbl.transactionId.equals(transactionId)))
      .write(updatedTransactionCompanion);
  }

  Future<int> insertTransaction(TransactionsCompanion newTransactionCompanion) async {
    return _appDatabase.into(_appDatabase.transactions).insert(newTransactionCompanion);
  }

  Future<void> deleteDebtTransactionSettlement(int debtId, int categoryId) async {
    await (_appDatabase.delete(_appDatabase.transactions)
      ..where((tbl) => tbl.debtId.equals(debtId) & tbl.categoryId.equals(categoryId))
    ).go();
  } 

  Future<void> deleteTransaction(int transactionId) async {
    await (_appDatabase.delete(_appDatabase.transactions)
      ..where((tbl) => tbl.transactionId.equals(transactionId))
    ).go();
  }

  Future<void> deleteDebtTransactions(int debtId) async {
    await (_appDatabase.delete(_appDatabase.transactions)
      ..where((tbl) => tbl.debtId.equals(debtId))
    ).go();
  }

}