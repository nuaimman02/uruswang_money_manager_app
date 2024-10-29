import 'package:drift/drift.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uruswang_money_manager_app/models/category.dart';
import 'package:uruswang_money_manager_app/models/transactions_with_categories_and_debts.dart';
import 'package:uruswang_money_manager_app/services/database_service/app_database.dart';
import 'package:uruswang_money_manager_app/services/model_service/debt_service.dart';
import 'dart:developer' as developer;

class TransactionsWithCategoriesAndDebtsService {
  final GetIt _getIt = GetIt.instance;
  late AppDatabase _appDatabase;
  late final DebtService _debtService = _getIt.get<DebtService>();

  TransactionsWithCategoriesAndDebtsService() {
    _appDatabase = _getIt.get<AppDatabase>();
  }

  JoinedSelectStatement<HasResultSet, dynamic>
      _createTransactionAndDebtJoinQuery() {
    return _appDatabase.select(_appDatabase.transactions).join([
      // Join with Categories on categoryId
      innerJoin(
          _appDatabase.categories,
          _appDatabase.categories.categoryId
              .equalsExp(_appDatabase.transactions.categoryId)),

      // Left join with Debts on debtId (nullable)
      leftOuterJoin(
          _appDatabase.debts,
          _appDatabase.debts.debtId
              .equalsExp(_appDatabase.transactions.debtId)),
    ]);
  }

  Stream<List<TransactionsWithCategoriesAndDebts>>
      getTransactionsWithCategoriesAndDebts() {
    final query = _createTransactionAndDebtJoinQuery();

    return query.watch().map((rows) {
      return rows.map((row) {
        return TransactionsWithCategoriesAndDebts(
            row.readTable(_appDatabase.transactions),
            row.readTable(_appDatabase.categories),
            row.readTableOrNull(_appDatabase.debts));
      }).toList();
    });
  }

  // TRANSACTION PAGE SECTION

  Stream<List<TransactionsWithCategoriesAndDebts>>
      getTransactionsWithCategoriesAndDebtsOnCurrentMonth(
          DateTime currentDate) {
    final firstDayOfMonth = DateTime(currentDate.year, currentDate.month, 1);
    final firstDayOfNextMonth = currentDate.month == 12
        ? DateTime(currentDate.year + 1, 1, 1)
        : DateTime(currentDate.year, currentDate.month + 1, 1);

    final query = _createTransactionAndDebtJoinQuery();

    // Tapis untuk mendapatkan transaksi bulan semasa
    query.where(_appDatabase.transactions.transactionDate
        .isBetweenValues(firstDayOfMonth, firstDayOfNextMonth));

    return query.watch().map((rows) {
      return rows.map((row) {
        return TransactionsWithCategoriesAndDebts(
            row.readTable(_appDatabase.transactions),
            row.readTable(_appDatabase.categories),
            row.readTableOrNull(_appDatabase.debts));
      }).toList();
    }); // Kembalikan sebagai senarai
  }

  Stream<List<TransactionsWithCategoriesAndDebts>>
      getTransactionsWithCategoriesAndDebtsOnSelectedDate(
          DateTime selectedDate) {
    // Define the start and end of the selected date
    final startOfDay = DateTime(
        selectedDate.year, selectedDate.month, selectedDate.day, 0, 0, 0);
    final endOfDay = DateTime(
        selectedDate.year, selectedDate.month, selectedDate.day, 23, 59, 59);

    final query = _createTransactionAndDebtJoinQuery()
      ..where(_appDatabase.transactions.transactionDate
          .isBetweenValues(startOfDay, endOfDay));

    return query.watch().map((rows) {
      return rows.map((row) {
        return TransactionsWithCategoriesAndDebts(
            row.readTable(_appDatabase.transactions),
            row.readTable(_appDatabase.categories),
            row.readTableOrNull(_appDatabase.debts));
      }).toList();
    });
  }

  Stream<double> getTotalIncomeForCurrentMonth(DateTime currentDate) {
    // Dapatkan hari pertama dan hari pertama bulan seterusnya
    final firstDayOfMonth = DateTime(currentDate.year, currentDate.month, 1);
    final firstDayOfNextMonth = currentDate.month == 12
        ? DateTime(currentDate.year + 1, 1, 1)
        : DateTime(currentDate.year, currentDate.month + 1, 1);

    // Kueri Drift untuk mendapatkan jumlah pendapatan bulan semasa
    final query = _createTransactionAndDebtJoinQuery()
      ..addColumns([_appDatabase.transactions.value.sum()])
      ..where(_appDatabase.transactions.transactionDate
          .isBetweenValues(firstDayOfMonth, firstDayOfNextMonth))
      ..where(_appDatabase.transactions.transactionType.equals('income'));

    // Ambil hasil dan jumlahkan
    final result = query
        .map((row) => row.read(_appDatabase.transactions.value.sum()) ?? 0.0)
        .watchSingle();
    return result;
  }

  Stream<double> getTotalExpenseForCurrentMonth(DateTime currentDate) {
    // Dapatkan hari pertama dan hari pertama bulan seterusnya
    final firstDayOfMonth = DateTime(currentDate.year, currentDate.month, 1);
    final firstDayOfNextMonth = currentDate.month == 12
        ? DateTime(currentDate.year + 1, 1, 1)
        : DateTime(currentDate.year, currentDate.month + 1, 1);

    // Kueri Drift untuk mendapatkan jumlah pendapatan bulan semasa
    final query = _createTransactionAndDebtJoinQuery()
      ..addColumns([_appDatabase.transactions.value.sum()])
      ..where(_appDatabase.transactions.transactionDate
          .isBetweenValues(firstDayOfMonth, firstDayOfNextMonth))
      ..where(_appDatabase.transactions.transactionType.equals('expense'));

    // Ambil hasil dan jumlahkan
    final result = query
        .map((row) => row.read(_appDatabase.transactions.value.sum()) ?? 0.0)
        .watchSingle();
    return result;
  }

  Stream<double> getTotalBalanceForCurrentMonth(DateTime currentDate) {
    Stream<double> currentMonthTotalIncome =
        getTotalIncomeForCurrentMonth(currentDate);
    Stream<double> currentMonthTotalExpense =
        getTotalExpenseForCurrentMonth(currentDate);

    // Use Rx.combineLatest2 to combine the two streams
    Stream<double> result = Rx.combineLatest2<double, double, double>(
      currentMonthTotalIncome,
      currentMonthTotalExpense,
      (income, expense) => income - expense, // Subtract expenses from income
    );

    return result;
  }

  // Future<TransactionsWithCategoriesAndDebts>
  //     getTransactionWithCategoryAndDebtByTransactionId(int transactionIdToGet) async {
  //   // Create the query using the join method you already defined
  //   final query = _createTransactionAndDebtJoinQuery()
  //     ..where(
  //         _appDatabase.transactions.transactionId.equals(transactionIdToGet));

  //   // Get the result from the query
  //   final result = await query.getSingle();

  //   // Read the transaction, category, and debt from the result
  //   final transaction = result.readTable(_appDatabase.transactions);
  //   final category = result.readTable(_appDatabase.categories);
  //   final debt = result.readTableOrNull(_appDatabase.debts); // debt can be null

  //   // Return the combined data as a TransactionsWithCategoriesAndDebts object
  //   return TransactionsWithCategoriesAndDebts(transaction, category, debt);
  // }

  Stream<TransactionsWithCategoriesAndDebts>
      getTransactionWithCategoryAndDebtByTransactionId(int transactionIdToGet) {
    // Create the query using the join method you already defined
    final query = _createTransactionAndDebtJoinQuery()
      ..where(
          _appDatabase.transactions.transactionId.equals(transactionIdToGet));

  // Watch a single result, not multiple rows
  return query.watchSingle().map((row) {
    return TransactionsWithCategoriesAndDebts(
      row.readTable(_appDatabase.transactions),
      row.readTable(_appDatabase.categories),
      row.readTableOrNull(_appDatabase.debts),
    );
  });
  }

  // DEBTS PAGE SECTION
  Stream<double> getTotalBorrowingForCurrentMonth(DateTime currentDate) {
    // Dapatkan hari pertama dan hari pertama bulan seterusnya
    final firstDayOfMonth = DateTime(currentDate.year, currentDate.month, 1);
    final firstDayOfNextMonth = currentDate.month == 12
        ? DateTime(currentDate.year + 1, 1, 1)
        : DateTime(currentDate.year, currentDate.month + 1, 1);

    // Kueri Drift untuk mendapatkan jumlah pendapatan bulan semasa
    final query = _createTransactionAndDebtJoinQuery()
      ..addColumns([_appDatabase.transactions.value.sum()])
      ..where(_appDatabase.transactions.transactionDate
          .isBetweenValues(firstDayOfMonth, firstDayOfNextMonth))
      ..where(_appDatabase.categories.categoryName.equals('Borrowing'));

    // Ambil hasil dan jumlahkan
    final result = query
        .map((row) => row.read(_appDatabase.transactions.value.sum()) ?? 0.0)
        .watchSingle();
    return result;
  }

  Stream<double> getTotalBorrowingPaidForCurrentMonth(DateTime currentDate) {
    // Dapatkan hari pertama dan hari pertama bulan seterusnya
    final firstDayOfMonth = DateTime(currentDate.year, currentDate.month, 1);
    final firstDayOfNextMonth = currentDate.month == 12
        ? DateTime(currentDate.year + 1, 1, 1)
        : DateTime(currentDate.year, currentDate.month + 1, 1);

    // Kueri Drift untuk mendapatkan jumlah pendapatan bulan semasa
    final query = _createTransactionAndDebtJoinQuery()
      ..addColumns([_appDatabase.transactions.value.sum()])
      ..where(_appDatabase.transactions.transactionDate
          .isBetweenValues(firstDayOfMonth, firstDayOfNextMonth))
      ..where(_appDatabase.categories.categoryName.equals('Paying Debt'));

    // Ambil hasil dan jumlahkan
    final result = query
        .map((row) => row.read(_appDatabase.transactions.value.sum()) ?? 0.0)
        .watchSingle();
    return result;
  }

  Stream<double> getTotalBorrowingBalanceForCurrentMonth(DateTime currentDate) {
    Stream<double> currentMonthTotalBorrowing =
        getTotalBorrowingForCurrentMonth(currentDate);
    Stream<double> currentMonthTotalBorrowingPaid =
        getTotalBorrowingPaidForCurrentMonth(currentDate);

    // Use Rx.combineLatest2 to combine the two streams
    Stream<double> result = Rx.combineLatest2<double, double, double>(
      currentMonthTotalBorrowing,
      currentMonthTotalBorrowingPaid,
      (borrow, borrowPaid) => borrow - borrowPaid,
    );

    return result;
  }

  Stream<double> getTotalLendingForCurrentMonth(DateTime currentDate) {
    // Dapatkan hari pertama dan hari pertama bulan seterusnya
    final firstDayOfMonth = DateTime(currentDate.year, currentDate.month, 1);
    final firstDayOfNextMonth = currentDate.month == 12
        ? DateTime(currentDate.year + 1, 1, 1)
        : DateTime(currentDate.year, currentDate.month + 1, 1);

    // Kueri Drift untuk mendapatkan jumlah pendapatan bulan semasa
    final query = _createTransactionAndDebtJoinQuery()
      ..addColumns([_appDatabase.transactions.value.sum()])
      ..where(_appDatabase.transactions.transactionDate
          .isBetweenValues(firstDayOfMonth, firstDayOfNextMonth))
      ..where(_appDatabase.categories.categoryName.equals('Lending'));

    // Ambil hasil dan jumlahkan
    final result = query
        .map((row) => row.read(_appDatabase.transactions.value.sum()) ?? 0.0)
        .watchSingle();
    return result;
  }

  Stream<double> getTotalLendingPaidForCurrentMonth(DateTime currentDate) {
    // Dapatkan hari pertama dan hari pertama bulan seterusnya
    final firstDayOfMonth = DateTime(currentDate.year, currentDate.month, 1);
    final firstDayOfNextMonth = currentDate.month == 12
        ? DateTime(currentDate.year + 1, 1, 1)
        : DateTime(currentDate.year, currentDate.month + 1, 1);

    // Kueri Drift untuk mendapatkan jumlah pendapatan bulan semasa
    final query = _createTransactionAndDebtJoinQuery()
      ..addColumns([_appDatabase.transactions.value.sum()])
      ..where(_appDatabase.transactions.transactionDate
          .isBetweenValues(firstDayOfMonth, firstDayOfNextMonth))
      ..where(_appDatabase.categories.categoryName.equals('Receive Debt'));

    // Ambil hasil dan jumlahkan
    final result = query
        .map((row) => row.read(_appDatabase.transactions.value.sum()) ?? 0.0)
        .watchSingle();
    return result;
  }

  Stream<double> getTotalLendingBalanceForCurrentMonth(DateTime currentDate) {
    Stream<double> currentMonthTotalLending =
        getTotalLendingForCurrentMonth(currentDate);
    Stream<double> currentMonthTotalLendingPaid =
        getTotalLendingPaidForCurrentMonth(currentDate);

    // Use Rx.combineLatest2 to combine the two streams
    Stream<double> result = Rx.combineLatest2<double, double, double>(
      currentMonthTotalLending,
      currentMonthTotalLendingPaid,
      (lending, lendingPaid) =>
          lending - lendingPaid, // Subtract expenses from income
    );

    return result;
  }

  Stream<List<TransactionsWithCategoriesAndDebts>>
      getTransactionsWithCategoriesAndDebtsOnCurrentMonthForSpecificCategory(
          DateTime currentDate, String specificCategory) {
    final firstDayOfMonth = DateTime(currentDate.year, currentDate.month, 1);
    final firstDayOfNextMonth = currentDate.month == 12
        ? DateTime(currentDate.year + 1, 1, 1)
        : DateTime(currentDate.year, currentDate.month + 1, 1);

    // Create the join query to combine transactions, categories, and debts
    final query = _createTransactionAndDebtJoinQuery();

    // Filter transactions by date range (current month) and the specific category name
    query
      ..where(_appDatabase.transactions.transactionDate
          .isBetweenValues(firstDayOfMonth, firstDayOfNextMonth))
      ..where(_appDatabase.categories.categoryName
          .equals(specificCategory)); // Filter by category

    // Watch the query and map the results to the `TransactionsWithCategoriesAndDebts` model
    return query.watch().map((rows) {
      return rows.map((row) {
        return TransactionsWithCategoriesAndDebts(
          row.readTable(_appDatabase.transactions),
          row.readTable(_appDatabase.categories),
          row.readTableOrNull(_appDatabase.debts),
        );
      }).toList();
    });
  }

  Stream<TransactionsWithCategoriesAndDebts> getDebtTransactionInitiator(int debtId) {
    final query = _createTransactionAndDebtJoinQuery();

    query
      ..where(_appDatabase.debts.debtId.equals(debtId))
      ..where( _appDatabase.categories.categoryName.equals('Borrowing') | _appDatabase.categories.categoryName.equals('Lending'));

     return query.watchSingle().map((row) {
    return TransactionsWithCategoriesAndDebts(
      row.readTable(_appDatabase.transactions),
      row.readTable(_appDatabase.categories),
      row.readTableOrNull(_appDatabase.debts),
      );
    }); 
  }

  Stream<TransactionsWithCategoriesAndDebts?> getDebtTransactionSettlement(int debtId) {
    final query = _createTransactionAndDebtJoinQuery();

    query
      ..where(_appDatabase.debts.debtId.equals(debtId))
      ..where( _appDatabase.categories.categoryName.equals('Receive Debt') | _appDatabase.categories.categoryName.equals('Paying Debt'));

  return query.map((row) {
    return TransactionsWithCategoriesAndDebts(
      row.readTable(_appDatabase.transactions),
      row.readTable(_appDatabase.categories),
      row.readTableOrNull(_appDatabase.debts),
      );
    }).watchSingleOrNull(); 
  }

  //BUDGETS SECTION
  Stream<double> watchTotalSpentForCategoryInCurrentMonth(int categoryId, DateTime currentDate) {
      final firstDayOfMonth = DateTime(currentDate.year, currentDate.month, 1);
      final firstDayOfNextMonth = currentDate.month == 12
          ? DateTime(currentDate.year + 1, 1, 1)
          : DateTime(currentDate.year, currentDate.month + 1, 1);

      final query = _createTransactionAndDebtJoinQuery()
        ..where(_appDatabase.transactions.categoryId.equals(categoryId) &
            _appDatabase.transactions.transactionDate.isBiggerOrEqualValue(firstDayOfMonth) &
            _appDatabase.transactions.transactionDate.isSmallerThanValue(firstDayOfNextMonth));

      return query.watch().map((rows) {
        return rows.fold<double>(0, (total, row) {
          final transaction = row.readTable(_appDatabase.transactions);
          return total + transaction.value; // Assuming `amount` is the field name for the transaction value
        });
    });
  }

  Stream<List<TransactionsWithCategoriesAndDebts>>
      getTransactionsWithCategoriesAndDebtsOnDateRangeByCategoryId(
          DateTime startDate, DateTime endDate, int categoryId) {
    // final firstDayOfMonth = DateTime(currentDate.year, currentDate.month, 1);
    // final firstDayOfNextMonth = currentDate.month == 12
    //     ? DateTime(currentDate.year + 1, 1, 1)
    //     : DateTime(currentDate.year, currentDate.month + 1, 1);

    final query = _createTransactionAndDebtJoinQuery();

    // Tapis untuk mendapatkan transaksi bulan semasa
    query.where
        (_appDatabase.transactions.transactionDate
        .isBetweenValues(startDate, endDate) &
        (_appDatabase.transactions.categoryId
        .equals(categoryId)));

    return query.watch().map((rows) {
      return rows.map((row) {
        return TransactionsWithCategoriesAndDebts(
            row.readTable(_appDatabase.transactions),
            row.readTable(_appDatabase.categories),
            row.readTableOrNull(_appDatabase.debts));
      }).toList();
    }); // Kembalikan sebagai senarai
  }

  //STATISTICS PAGE
  // Method to get daily expense for the month
  Stream<Map<DateTime, double>> getDailyIncomeForMonth(DateTime selectedDate) {
    final firstDayOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);
    final lastDayOfMonth = DateTime(selectedDate.year, selectedDate.month + 1, 1).subtract(const Duration(days: 1)); // Last day of the current month

    // Create the query
    final query = _createTransactionAndDebtJoinQuery()
      ..addColumns([_appDatabase.transactions.transactionDate, _appDatabase.transactions.value.sum()])
      ..where(_appDatabase.transactions.transactionDate.isBetweenValues(firstDayOfMonth, lastDayOfMonth))
      ..where(_appDatabase.transactions.transactionType.equals('income'))
      ..groupBy([_appDatabase.transactions.transactionDate]);

    return query.watch().map((rows) {
      final Map<DateTime, double> dailyIncome = {};

      for (final row in rows) {
        // Directly read DateTime from the database and enforce local time
        final DateTime? transactionDate = row.read(_appDatabase.transactions.transactionDate);

        if (transactionDate != null) {
          // No splitting the date! Use the full DateTime, but ensure it's local
          final DateTime dateOnly = DateTime(
            transactionDate.year,
            transactionDate.month,
            transactionDate.day,
          ).toLocal(); // Make sure the final date is local
          // TODO: PENGAJARAN KALAU ASINGKAN KOMPONEN TARIKH DENGAN MASA, KENE PANGGIL toLocal()

          // Read the sum of income
          final double income = row.read<double>(_appDatabase.transactions.value.sum()) ?? 0;

          // Update the daily expense map with the local date and expense sum
          dailyIncome.update(dateOnly, (value) => value + income, ifAbsent: () => income);

        }
      }
      return dailyIncome;
    });
  }

  Stream<Map<DateTime, double>> getDailyExpenseForMonth(DateTime selectedDate) {
    // Start and end dates in the local timezone
    final DateTime firstDayOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);
    final DateTime lastDayOfMonth = DateTime(selectedDate.year, selectedDate.month + 1, 1).subtract(const Duration(days: 1));

    // Query to get expenses for the month
    final query = _createTransactionAndDebtJoinQuery()
      ..addColumns([_appDatabase.transactions.transactionDate, _appDatabase.transactions.value.sum()])
      ..where(_appDatabase.transactions.transactionDate.isBetweenValues(firstDayOfMonth, lastDayOfMonth))
      ..where(_appDatabase.transactions.transactionType.equals('expense'))
      ..groupBy([_appDatabase.transactions.transactionDate]);

    return query.watch().map((rows) {
      final Map<DateTime, double> dailyExpense = {};

      for (final row in rows) {
        // Directly read DateTime from the database and enforce local time
        final DateTime? transactionDate = row.read(_appDatabase.transactions.transactionDate);

        if (transactionDate != null) {
          // No splitting the date! Use the full DateTime, but ensure it's local
          final DateTime dateOnly = DateTime(
            transactionDate.year,
            transactionDate.month,
            transactionDate.day,
          ).toLocal(); // Make sure the final date is local
          // TODO: PENGAJARAN KALAU ASINGKAN KOMPONEN TARIKH DENGAN MASA, KENE PANGGIL toLocal()

          // Read the sum of expenses
          final double expense = row.read<double>(_appDatabase.transactions.value.sum()) ?? 0;

          // Update the daily expense map with the local date and expense sum
          dailyExpense.update(dateOnly, (value) => value + expense, ifAbsent: () => expense);

        }
      }
      return dailyExpense;
    });
  }

  Stream<Map<DateTime, double>> getDailyTotalBalanceForMonth(DateTime selectedDate) {
    // Fetch daily income and expense streams for the month
    final dailyIncomeStream = getDailyIncomeForMonth(selectedDate);
    final dailyExpenseStream = getDailyExpenseForMonth(selectedDate);

    // Combine both streams to calculate the total balance
    return Rx.combineLatest2<Map<DateTime, double>, Map<DateTime, double>, Map<DateTime, double>>(
      dailyIncomeStream,
      dailyExpenseStream,
      (dailyIncome, dailyExpense) {
        final Map<DateTime, double> dailyTotalBalance = {};

        // Create a set of all dates present in either dailyIncome or dailyExpense
        final allDates = {...dailyIncome.keys, ...dailyExpense.keys};

        // Iterate over each date to calculate the total balance
        for (final date in allDates) {
          final income = dailyIncome[date] ?? 0.0;
          final expense = dailyExpense[date] ?? 0.0;
          final totalBalance = income - expense;

          dailyTotalBalance[date] = totalBalance;
        }

        return dailyTotalBalance;
      },
    );
  }

  Stream<Map<String, double>> getTransactionsByCategoryForMonth(DateTime selectedDate, CategoryType categoryType) {
    final firstDayOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);
    final lastDayOfMonth = DateTime(selectedDate.year, selectedDate.month + 1, 1).subtract(const Duration(days: 1)); // Last day of the current month

    // Query to get transaction totals by category for the selected month
    final query = _createTransactionAndDebtJoinQuery()
      ..addColumns([_appDatabase.transactions.value.sum()])
      ..where(_appDatabase.transactions.transactionDate.isBetweenValues(firstDayOfMonth, lastDayOfMonth))
      ..where(_appDatabase.categories.categoryType.equals(categoryType.name))
      ..groupBy([_appDatabase.categories.categoryName]);

    // Map the result to a Map<String, double> containing category name and total transaction values
    return query.watch().map((rows) {
      final Map<String, double> categoryData = {};
      for (final row in rows) {
        final categoryName = row.read<String>(_appDatabase.categories.categoryName);
        final totalValue = row.read<double>(_appDatabase.transactions.value.sum()) ?? 0.0;
        categoryData[categoryName!] = totalValue;
      }
      return categoryData;
    });
  }

  // DEBT NOTIFICATIONS FOR PRE-POPULATED DATA
  /// Schedule notifications for debts from pre-populated data
  Future<void> schedulePrePopulatedDebtNotifications() async {
    try {
      // Fetch all debts with expectedSettlementDate
      final allDebts = await (_createTransactionAndDebtJoinQuery()
        //..where(_appDatabase.debts.expectedToBeSettledDate.isNotNull()))
        ..where(_appDatabase.debts.debtId.isNotNull()))
        .get();

      for (var row in allDebts) {
        final transaction = row.readTable(_appDatabase.transactions);
        final debt = row.readTable(_appDatabase.debts);
        final category = row.readTable(_appDatabase.categories);

        if(debt.expectedToBeSettledDate != null) {
          await _debtService.scheduleDebtNotification(debt.debtId, transaction.transactionName, debt.peopleName, category.categoryName, transaction.value, debt.expectedToBeSettledDate!);
        }
      }
    } catch (e) {
      developer.log("Error scheduling notifications for pre-populated debts: $e");
    }
  }
}
