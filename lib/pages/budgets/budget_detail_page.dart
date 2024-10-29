import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:uruswang_money_manager_app/models/transactions_with_categories_and_debts.dart';
import 'package:uruswang_money_manager_app/pages/budgets/budget_form_page.dart';
import 'package:uruswang_money_manager_app/pages/transactions/transaction_detail_page.dart';
import 'package:uruswang_money_manager_app/services/database_service/app_database.dart';
import 'package:uruswang_money_manager_app/services/model_service/budget_service.dart';
import 'package:uruswang_money_manager_app/services/model_service/date_and_time_formatter_service.dart';
import 'package:uruswang_money_manager_app/services/model_service/transactions_with_categories_and_debts_service.dart';
import 'package:uruswang_money_manager_app/services/navigation_service.dart';

class BudgetDetailPage extends StatefulWidget {
  final int budgetId;

  const BudgetDetailPage({super.key, required this.budgetId});

  @override
  State<BudgetDetailPage> createState() => _BudgetDetailPageState();
}

class _BudgetDetailPageState extends State<BudgetDetailPage> {
  final GetIt _getIt = GetIt.instance;
  late NavigationService _navigationService;
  late BudgetService _budgetService;
  late TransactionsWithCategoriesAndDebtsService _transactionsWithCategoriesAndDebtsService;
  late DateAndTimeFormatterService _dateAndTimeFormatterService;

  double amountSpent = 0.0;
  double budgetedAmount = 0.0;
  double remainingAmount = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    _navigationService = _getIt.get<NavigationService>();
    _budgetService = _getIt.get<BudgetService>();
    _transactionsWithCategoriesAndDebtsService = _getIt.get<TransactionsWithCategoriesAndDebtsService>();
    _dateAndTimeFormatterService = _getIt.get<DateAndTimeFormatterService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Details'),
        backgroundColor: Colors.lightGreen[100],
      ),
      body: StreamBuilder<Budget>(
        stream: _budgetService.getBudgetById(widget.budgetId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No budget found'));
          }

          final budgetItem = snapshot.data!;
          budgetedAmount = budgetItem.budgetedValue;

          // Stream for total spent based on the current budget category and start date
          return StreamBuilder<double>(
            stream: _transactionsWithCategoriesAndDebtsService.watchTotalSpentForCategoryInCurrentMonth(
              budgetItem.categoryId, 
              budgetItem.startDate
            ),
            builder: (context, amountSnapshot) {
              if (amountSnapshot.hasData) {
                amountSpent = amountSnapshot.data!;
                remainingAmount = budgetedAmount - amountSpent;
              }

              return _buildUI(budgetItem);
            },
          );
        },
      ),
    );
  }

  Widget _buildUI(Budget budgetItem) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 15),
            _budgetNameHeader(budgetItem),
            const SizedBox(height: 15),
            _budgetCalculationHeader(),
            const SizedBox(height: 15),
            _quickActions(budgetItem),
            const SizedBox(height: 15),
            _transactionsListForBudget(budgetItem),
          ],
        ),
      ),
    );
  }

  Widget _budgetNameHeader(Budget budgetItem) {
    String formattedMonthNameAndYear = _dateAndTimeFormatterService.returnCurrentMonthNameAndYear(budgetItem.startDate);

    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: Colors.green),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              budgetItem.budgetName,
              style: const TextStyle(color: Colors.white, fontSize: 25),
            ),
            Text(
              formattedMonthNameAndYear,
              style: const TextStyle(color: Colors.white, fontSize: 25),
            ),
          ],
        ),
      ),
    );
  }

  Widget _budgetCalculationHeader() {
    Color remainingAmountColor = remainingAmount > budgetedAmount ? Colors.red : Colors.green;

    return Container(
      decoration: BoxDecoration(
          border: const Border(
              top: BorderSide(style: BorderStyle.solid, color: Colors.black),
              bottom: BorderSide(style: BorderStyle.solid)),
          color: Colors.grey[200]),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Text('Amount Spent', style: TextStyle(fontSize: 16)),
                    Text('RM${amountSpent.toStringAsFixed(2)}', style: const TextStyle(color: Colors.red, fontSize: 16)),
                  ],
                ),
                Column(
                  children: [
                    const Text('Budgeted Amount', style: TextStyle(fontSize: 16)),
                    Text('RM${budgetedAmount.toStringAsFixed(2)}', style: const TextStyle(color: Colors.blue, fontSize: 16)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 5),
            Column(
              children: [
                const Text('Remaining', style: TextStyle(fontSize: 16)),
                Text('RM${remainingAmount.toStringAsFixed(2)}', style: TextStyle(color: remainingAmountColor, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  Widget _quickActions(Budget budgetItem) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0), side: const BorderSide()),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                IconButton.outlined(
                  onPressed: () async {
                      // Get the ScaffoldMessenger reference before the async operation
                      final scaffoldMessenger = ScaffoldMessenger.of(context);

                      // Navigate to the TransactionDetailPage and wait for the result
                      final result = await _navigationService.pushToGetResult(
                        MaterialPageRoute(
                        builder: (context) => BudgetFormPage(budgetItem: budgetItem),
                        ),
                      );

                      // Check if the result is 'deleted' and show a snackbar
                      if (result == 'updated') {
                        scaffoldMessenger.showSnackBar(
                          const SnackBar(
                          content: Text('The budget is successfully updated'),
                          duration: Duration(seconds: 2),
                          ),
                        );
                      }      
                }, 
                icon: const Icon(Icons.edit), iconSize: 30),
                const Text('Edit'),
              ],
            ),
            Column(
              children: [
                IconButton.outlined(onPressed: () {
                      // Show confirmation dialog before deleting
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirm Deletion'),
                            content: const Text('Are you sure you want to delete this budget?'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Cancel'),
                                onPressed: () {
                                  _navigationService.goBack(); // Close the dialog
                                },
                              ),
                              TextButton(
                                child: const Text('Delete'),
                                onPressed: () async {
                                  // Perform the deletion
                                  await _budgetService.deleteBudget(budgetItem.budgetId);
                                  
                                  _navigationService.goBack();

                                  // Return 'deleted' result when navigating back
                                  _navigationService.goBackWithResult(result: 'deleted');
                                  
                                },
                              ),
                            ],
                          );
                        }
                      );
                }, icon: const Icon(Icons.delete), iconSize: 30),
                const Text('Delete'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _transactionsListForBudget(Budget budgetItem) {
    return StreamBuilder<List<TransactionsWithCategoriesAndDebts>>(
      stream: _transactionsWithCategoriesAndDebtsService
          .getTransactionsWithCategoriesAndDebtsOnDateRangeByCategoryId(budgetItem.startDate, budgetItem.endDate, budgetItem.categoryId),
      builder: (context, snapshot) {
        String formattedMonthNameAndYear = _dateAndTimeFormatterService.returnCurrentMonthNameAndYear(budgetItem.startDate);

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('No transactions available for ${budgetItem.budgetName} in $formattedMonthNameAndYear', textAlign: TextAlign.center),
            ),
          );
        }

        final groupedTransactions = <String, List<TransactionsWithCategoriesAndDebts>>{};
        for (var transaction in snapshot.data!) {
          String transactionDate = _dateAndTimeFormatterService.formatDateDayTransactionListDisplay(transaction.transactions.transactionDate);
          groupedTransactions.putIfAbsent(transactionDate, () => []).add(transaction);
        }

        final sortedDates = groupedTransactions.keys.toList()..sort((a, b) => b.compareTo(a));

        return ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: sortedDates.length,
          itemBuilder: (context, index) {
            String date = sortedDates[index];
            List<TransactionsWithCategoriesAndDebts> transactionsOnDate = groupedTransactions[date]!;

            transactionsOnDate.sort((a, b) => b.transactions.transactionDate.compareTo(a.transactions.transactionDate));

            return Column(
              children: [
                Container(
                  decoration: const BoxDecoration(border: Border(bottom: BorderSide(style: BorderStyle.solid))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(padding: const EdgeInsets.all(8.0), child: Text(date, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                          Padding(padding: const EdgeInsets.all(8.0), child: Text('RM${transactionsOnDate.map((t) => t.transactions.value).fold(0.0, (sum, value) => sum + value).toStringAsFixed(2)}', style: const TextStyle(color: Colors.red, fontSize: 16))),
                        ],
                      ),
                      const Divider(height: 2, color: Colors.black),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: transactionsOnDate.length,
                        itemBuilder: (context, transIndex) {
                          final transaction = transactionsOnDate[transIndex];
                          String transactionTime = _dateAndTimeFormatterService.formatTimeTo24H(transaction.transactions.transactionDate);

                          return Container(
                            color: transIndex % 2 == 0 ? Colors.lightBlue[50] : Colors.lightGreen[50],
                            child: ListTile(
                              title: Text(transaction.transactions.transactionName),
                              subtitle: Text(transaction.categories.categoryName),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('RM ${transaction.transactions.value.toStringAsFixed(2)}', style: TextStyle(color: transaction.transactions.transactionType.name == 'income' ? Colors.green : Colors.red, fontSize: 17)),
                                  Text(transactionTime),
                                ],
                              ),
                              onTap: () async {
                                  // Get the ScaffoldMessenger reference before the async operation
                                  final scaffoldMessenger = ScaffoldMessenger.of(context);

                                  // Navigate to the TransactionDetailPage and wait for the result
                                  final result = await _navigationService.pushToGetResult(
                                    MaterialPageRoute(
                                      builder: (context) => TransactionDetailPage(transactionId: transaction.transactions.transactionId),
                                    ),
                                  );

                                  // Check if the result is 'deleted' and show a snackbar
                                  if (result == 'deleted') {
                                    scaffoldMessenger.showSnackBar(
                                      const SnackBar(
                                        content: Text('The transaction is successfully deleted'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            );
          },
        );
      },
    );
  }
}
