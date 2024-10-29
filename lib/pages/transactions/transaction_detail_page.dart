import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:uruswang_money_manager_app/models/transactions_with_categories_and_debts.dart';
import 'package:uruswang_money_manager_app/pages/transactions/transaction_form_page.dart';
import 'package:uruswang_money_manager_app/services/model_service/date_and_time_formatter_service.dart';
import 'package:uruswang_money_manager_app/services/model_service/transaction_service.dart';
import 'package:uruswang_money_manager_app/services/model_service/transactions_with_categories_and_debts_service.dart';
import 'package:uruswang_money_manager_app/services/navigation_service.dart';

class TransactionDetailPage extends StatefulWidget {
  //TransactionsWithCategoriesAndDebts transactionWithCategoryAndDebtItem;
  final int transactionId;

  //TransactionDetailPage({super.key, required this.transactionWithCategoryAndDebtItem});

  const TransactionDetailPage({super.key, required this.transactionId});

  @override
  State<TransactionDetailPage> createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {
  final GetIt _getIt = GetIt.instance;
  late DateAndTimeFormatterService _dateAndTimeFormatterService = _getIt.get<DateAndTimeFormatterService>();
  late NavigationService _navigationService;
  late TransactionsWithCategoriesAndDebtsService _transactionsWithCategoriesAndDebtsService;
  late TransactionService _transactionService;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _transactionsWithCategoriesAndDebtsService = _getIt.get<TransactionsWithCategoriesAndDebtsService>();
    _dateAndTimeFormatterService = _getIt.get<DateAndTimeFormatterService>();
    _navigationService = _getIt.get<NavigationService>();
    _transactionService = _getIt.get<TransactionService>();
  }

  @override
  Widget build(BuildContext context) {
    //final TransactionsWithCategoriesAndDebts transactionDetails = widget.transactionWithCategoryAndDebtItem;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
        backgroundColor: Colors.lightGreen[100],
      ),
      body: _buildUI()//_buildUI(transactionDetails),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: StreamBuilder<TransactionsWithCategoriesAndDebts>(
        stream: _transactionsWithCategoriesAndDebtsService.getTransactionWithCategoryAndDebtByTransactionId(widget.transactionId),
        builder: (context, snapshot) {
          // Handle different states of the Stream
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Show a loader while waiting
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // Show error message
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available')); // Handle no data case
          }

        // Safe to use snapshot.data now, as we know it exists
        final transactionDetails = snapshot.data!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10,),
              _transactionDetailsHeader(transactionDetails),
              const SizedBox(height: 10,),
              _transactionDetails(transactionDetails),
              const SizedBox(height: 10,),
              _quickActions(transactionDetails),
            ],
          );
        }
      ));
  }

  Widget _transactionDetailsHeader(TransactionsWithCategoriesAndDebts transactionDetails) {
    String formattedDate = _dateAndTimeFormatterService.formatDateDayTransactionDetailsDisplay(transactionDetails.transactions.transactionDate);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              transactionDetails.transactions.transactionType.name == 'income' ? // Display value
                Text('RM${transactionDetails.transactions.value.toStringAsFixed(2)}', style: const TextStyle(color: Colors.green, fontSize: 40),)
                : Text('RM${transactionDetails.transactions.value.toStringAsFixed(2)}', style: const TextStyle(color: Colors.red, fontSize: 40),),
                Text(transactionDetails.transactions.transactionName, style: const TextStyle(fontSize: 20),), 
              Text(formattedDate, style: const TextStyle(fontSize: 16),), // Display date
            ],
          ),
          transactionDetails.transactions.transactionType.name == 'income' ?
            const Icon(Icons.download, color: Colors.green, size: 60,) 
            : const Icon(Icons.upload, color: Colors.red,  size: 60,)
        ],
      ),
    );
  }

  Widget _transactionDetails(TransactionsWithCategoriesAndDebts transactionDetails) {
    String formattedDate = _dateAndTimeFormatterService.formatDateTransactionDetailsDisplay(transactionDetails.transactions.transactionDate);
    String formattedTime = _dateAndTimeFormatterService.formatTimeTo24H(transactionDetails.transactions.transactionDate);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0), side: const BorderSide()),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Transaction Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            const Divider(),
            Row(
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Category', style: TextStyle(fontSize: 18),),
                    Text('Trans. Type', style: TextStyle(fontSize: 18),),
                    Text('Date', style: TextStyle(fontSize: 18),),
                    Text('Time', style: TextStyle(fontSize: 18),),
                    Text('Description', style: TextStyle(fontSize: 18), softWrap: true,)
                  ],
                ),
                const Column(
                  children: [
                    Text(':  ', style: TextStyle(fontSize: 18),),
                    Text(':  ', style: TextStyle(fontSize: 18),),
                    Text(':  ', style: TextStyle(fontSize: 18),),
                    Text(':  ', style: TextStyle(fontSize: 18),),
                    Text(':  ', style: TextStyle(fontSize: 18), softWrap: true,)
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(transactionDetails.categories.categoryName, style: const TextStyle(fontSize: 18),),
                    Text(toBeginningOfSentenceCase(transactionDetails.transactions.transactionType.name), style: const TextStyle(fontSize: 18),),
                    Text(formattedDate, style: const TextStyle(fontSize: 18),),
                    Text(formattedTime, style: const TextStyle(fontSize: 18),),
                    const Text('', style: TextStyle(fontSize: 18),),
                  ],
                ),
              ],
            ),
            Text(transactionDetails.transactions.description ?? '', style: const TextStyle(fontSize: 18),),
          ],
        ),
      ),
    );
  }

  Widget  _quickActions(TransactionsWithCategoriesAndDebts transactionDetails) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0), side: const BorderSide()),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              const Divider(),
              Row(
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
                          builder: (context) => TransactionFormPage(transactionWithCategoryAndDebtItem: transactionDetails),
                          ),
                        );

                        // Check if the result is 'deleted' and show a snackbar
                        if (result == 'updated') {
                          scaffoldMessenger.showSnackBar(
                            const SnackBar(
                            content: Text('The transaction is successfully updated'),
                            duration: Duration(seconds: 2),
                            ),
                          );
                        }        
                      },
                      icon: const Icon(Icons.edit), iconSize: 40,),
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
                            content: const Text('Are you sure you want to delete this transaction?'),
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
                                  await _transactionService.deleteTransaction(transactionDetails.transactions.transactionId);
                                  
                                  _navigationService.goBack();

                                  // Return 'deleted' result when navigating back
                                  _navigationService.goBackWithResult(result: 'deleted');
                                  
                                },
                              ),
                            ],
                          );
                        }
                      );
                    }, icon: const Icon(Icons.delete), iconSize: 40,),
                      const Text('Delete'),
                    ],
                  )
                ],
                )
          ],
        ),
      ),
    );
  }

  // void _refreshTransactionDetails() async {
  //   // Fetch the updated transaction details
  //   final updatedTransaction = await _transactionsWithCategoriesAndDebtsService.getTransactionWithCategoryAndDebtByTransactionId(widget.transactionWithCategoryAndDebtItem.transactions.transactionId);

  //   // Update the UI with the new transaction data
  //   setState(() {
  //     widget.transactionWithCategoryAndDebtItem = updatedTransaction;
  //   });
  // }
}