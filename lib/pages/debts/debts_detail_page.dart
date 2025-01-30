import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uruswang_money_manager_app/models/transaction.dart';
import 'package:uruswang_money_manager_app/models/transactions_with_categories_and_debts.dart';
import 'package:uruswang_money_manager_app/pages/debts/debts_form_page.dart';
import 'package:uruswang_money_manager_app/services/database_service/app_database.dart';
import 'package:uruswang_money_manager_app/services/model_service/category_service.dart';
import 'package:uruswang_money_manager_app/services/model_service/date_and_time_formatter_service.dart';
import 'package:uruswang_money_manager_app/services/model_service/debt_service.dart';
import 'package:uruswang_money_manager_app/services/model_service/transaction_service.dart';
import 'package:uruswang_money_manager_app/services/model_service/transactions_with_categories_and_debts_service.dart';
import 'package:uruswang_money_manager_app/services/navigation_service.dart';

class DebtsDetailPage extends StatefulWidget {
  // TransactionsWithCategoriesAndDebts debtTransactionInitiator;
  // TransactionsWithCategoriesAndDebts? debtTransactionSettlement;
  final int debtId;

  // DebtsDetailPage(
  //     {super.key,
  //     required this.debtTransactionInitiator,
  //     required this.debtTransactionSettlement});

  const DebtsDetailPage(
    {super.key,
    required this.debtId});

  @override
  State<DebtsDetailPage> createState() => _DebtsDetailPageState();
}

class _DebtsDetailPageState extends State<DebtsDetailPage> {
  final GetIt _getIt = GetIt.instance;
  late NavigationService _navigationService;
  late DateAndTimeFormatterService _dateAndTimeFormatterService;
  late TransactionsWithCategoriesAndDebtsService
      _transactionsWithCategoriesAndDebtsService;
  late CategoryService _categoryService;
  late TransactionService _transactionService;
  late DebtService _debtService;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _navigationService = _getIt.get<NavigationService>();
    _transactionsWithCategoriesAndDebtsService =
        _getIt.get<TransactionsWithCategoriesAndDebtsService>();
    _dateAndTimeFormatterService = _getIt.get<DateAndTimeFormatterService>();
    _categoryService = _getIt.get<CategoryService>();
    _transactionService = _getIt.get<TransactionService>();
    _debtService = _getIt.get<DebtService>();

    //_getDebtTransactions();
  }

  // void _getDebtTransactions() {
  //   _transactionsWithCategoriesAndDebtsService
  //       .getDebtTransactionInitiator(widget.debtId)
  //       .listen((initiator) {
  //     setState(() {
  //       debtTransactionInitiator = initiator;
  //     });
  //   });

  //   _transactionsWithCategoriesAndDebtsService
  //       .getDebtTransactionSettlement(widget.debtId)
  //       .listen((settlement) {
  //     setState(() {
  //       debtTransactionInitiator = settlement;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debt Transaction Details'),
        backgroundColor: Colors.green[100],
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
        child: SingleChildScrollView(
      child: StreamBuilder<List<TransactionsWithCategoriesAndDebts?>>(
        stream: CombineLatestStream.list([_transactionsWithCategoriesAndDebtsService.getDebtTransactionInitiator(widget.debtId), _transactionsWithCategoriesAndDebtsService.getDebtTransactionSettlement(widget.debtId)]),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final debtTransactionInitiator = snapshot.data![0];
          final debtTransactionSettlement = snapshot.data![1];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              _debtTransactionDetailsHeader(debtTransactionInitiator),
              const SizedBox(
                height: 10,
              ),
              _debtTransactionInitiatorDetails(debtTransactionInitiator),
              const SizedBox(
                height: 10,
              ),
              _debtTransactionSettlementDetails(debtTransactionInitiator,
                  debtTransactionSettlement),
              const SizedBox(
                height: 10,
              ),
              _quickActions(debtTransactionInitiator,
                  debtTransactionSettlement),
              const SizedBox(
                height: 30,
              ),
            ],
          );
        }
      ),
    ));
  }

  Widget _debtTransactionDetailsHeader(
      TransactionsWithCategoriesAndDebts? debtTransactionInitiator) {
    String formattedDate =
        _dateAndTimeFormatterService.formatDateDayTransactionDetailsDisplay(
            debtTransactionInitiator!.transactions.transactionDate);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              debtTransactionInitiator.transactions.transactionType.name ==
                      'income'
                  ? // Display value
                  Text(
                      'RM${debtTransactionInitiator.transactions.value.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.green, fontSize: 40),
                    )
                  : Text(
                      'RM${debtTransactionInitiator.transactions.value.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.red, fontSize: 40),
                    ),
              Text(
                debtTransactionInitiator.transactions.transactionName,
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                formattedDate,
                style: const TextStyle(fontSize: 16),
              ), // Display date
            ],
          ),
          debtTransactionInitiator.transactions.transactionType.name == 'income'
              ? const Icon(
                  Icons.download,
                  color: Colors.green,
                  size: 60,
                )
              : const Icon(
                  Icons.upload,
                  color: Colors.red,
                  size: 60,
                )
        ],
      ),
    );
  }

  Widget _debtTransactionInitiatorDetails(
      TransactionsWithCategoriesAndDebts? debtTransactionInitiator) {
    String formattedDate =
        _dateAndTimeFormatterService.formatDateTransactionDetailsDisplay(
            debtTransactionInitiator!.transactions.transactionDate);
    String formattedTime = _dateAndTimeFormatterService
        .formatTimeTo24H(debtTransactionInitiator.transactions.transactionDate);

    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0), side: const BorderSide()),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              debtTransactionInitiator.categories.categoryName == 'Borrowing'
                  ? 'Borrowing Information'
                  : 'Lending Information',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Category',
                      style: TextStyle(fontSize: 18),
                    ),
                    const Text(
                      'Trans. Type',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      debtTransactionInitiator.categories.categoryName ==
                              'Borrowing'
                          ? 'From'
                          : 'To',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const Text(
                      'Date',
                      style: TextStyle(fontSize: 18),
                    ),
                    const Text(
                      'Time',
                      style: TextStyle(fontSize: 18),
                    ),
                    const Text(
                      'Description',
                      style: TextStyle(fontSize: 18),
                    )
                  ],
                ),
                const Column(
                  children: [
                    Text(
                      ':  ',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      ':  ',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      ':  ',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      ':  ',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      ':  ',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      ':  ',
                      style: TextStyle(fontSize: 18),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      debtTransactionInitiator.categories.categoryName,
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      toBeginningOfSentenceCase(debtTransactionInitiator
                          .transactions.transactionType.name),
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      debtTransactionInitiator.debts!.peopleName,
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      formattedDate,
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      formattedTime,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const Text(
                      '',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              debtTransactionInitiator.transactions.description ?? '',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _debtTransactionSettlementDetails(
      TransactionsWithCategoriesAndDebts? debtTransactionInitiator,
      TransactionsWithCategoriesAndDebts? debtTransactionSettlement) {
    String? formattedExpectedToBeSettledDate;
    String? formattedSettledDate;
    String? formattedSettledTime;

    if (debtTransactionInitiator!.debts?.expectedToBeSettledDate != null) {
      formattedExpectedToBeSettledDate =
          _dateAndTimeFormatterService.formatDateTransactionDetailsDisplay(
              debtTransactionInitiator.debts!.expectedToBeSettledDate!);
    } else {
      formattedExpectedToBeSettledDate =
          null; // Or assign a default value if you prefer
    }

    if (debtTransactionSettlement?.debts?.settledDate != null) {
      formattedSettledDate =
          _dateAndTimeFormatterService.formatDateTransactionDetailsDisplay(
              debtTransactionSettlement!.debts!.settledDate!);
    } else {
      formattedSettledDate = null; // Or assign a default value if you prefer
    }

    if (debtTransactionSettlement?.debts?.settledDate != null) {
      formattedSettledTime = _dateAndTimeFormatterService
          .formatTimeTo24H(debtTransactionSettlement!.debts!.settledDate!);
    } else {
      formattedSettledTime = null; // Or assign a default value if you prefer
    }

    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0), side: const BorderSide()),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Settlement Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Row(
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Expected Settle Date',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text('Settlement Date', style: TextStyle(fontSize: 18)),
                    Text('Settlement Time', style: TextStyle(fontSize: 18)),
                    Text('Settlement Category', style: TextStyle(fontSize: 18)),
                  ],
                ),
                const Column(
                  children: [
                    Text(':'),
                    Text(':'),
                    Text(':'),
                    Text(':'),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(formattedExpectedToBeSettledDate ?? 'Date Not Set',
                        style: const TextStyle(fontSize: 18)),
                    Text(formattedSettledDate ?? 'Not Paid Yet',
                        style: const TextStyle(fontSize: 18)),
                    Text(formattedSettledTime ?? 'Not Paid Yet',
                        style: const TextStyle(fontSize: 18)),
                    Text(debtTransactionSettlement != null ? debtTransactionSettlement.categories.categoryName : 'Not Applicable',
                        style: const TextStyle(fontSize: 18)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickActions(
      TransactionsWithCategoriesAndDebts? debtTransactionInitiator,
      TransactionsWithCategoriesAndDebts? debtTransactionSettlement) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0), side: const BorderSide()),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    // StreamBuilder<TransactionsWithCategoriesAndDebts?>(
                    //   stream: _transactionsWithCategoriesAndDebtsService
                    // .getDebtTransactionSettlement(
                    //     debtTransactionInitiator!.debts!.debtId),
                    //   builder: (context, snapshot) {
                    //     return IconButton.outlined(
                    //       onPressed: () async {
                    //         // Check if the debtTransactionSettlement is null (i.e., no settlement exists)
                    //         if (debtTransactionSettlement == null) {
                    //           // Insert a new transaction for debt settlement based on the category type
                    //           if (debtTransactionInitiator
                    //                   .categories.categoryName ==
                    //               'Borrowing') {
                    //             // Fetch categoryId for 'Paying Debt'
                    //             int? categoryId = await _categoryService
                    //                 .getCategoryId('Paying Debt');
                        
                    //             // Create a new transactionCompanion for debt payment
                    //             final transactionCompanion = TransactionsCompanion(
                    //               transactionName: drift.Value(
                    //                   '${debtTransactionInitiator.transactions.transactionName} (Paid)'),
                    //               value: drift.Value(
                    //                   debtTransactionInitiator.transactions.value),
                    //               transactionDate: drift.Value(DateTime.now()),
                    //               transactionType: const drift.Value(
                    //                   TransactionType.expense), // For paying debt
                    //               categoryId: drift.Value(categoryId),
                    //               debtId: drift.Value(
                    //                   debtTransactionInitiator.debts?.debtId),
                    //             );
                        
                    //             // Insert the new transaction
                    //             _transactionService
                    //                 .insertTransaction(transactionCompanion);
                    //           } else if (debtTransactionInitiator
                    //                   .categories.categoryName ==
                    //               'Lending') {
                    //             // Fetch categoryId for 'Receive Debt'
                    //             int? categoryId = await _categoryService
                    //                 .getCategoryId('Receive Debt');
                        
                    //             // Create a new transactionCompanion for receiving debt
                    //             final transactionCompanion = TransactionsCompanion(
                    //               transactionName: drift.Value(
                    //                   '${debtTransactionInitiator.transactions.transactionName} (Paid)'),
                    //               value: drift.Value(
                    //                   debtTransactionInitiator.transactions.value),
                    //               transactionDate: drift.Value(DateTime.now()),
                    //               transactionType: const drift.Value(
                    //                   TransactionType.income), // For receiving debt
                    //               categoryId: drift.Value(categoryId),
                    //               debtId: drift.Value(
                    //                   debtTransactionInitiator.debts?.debtId),
                    //             );
                        
                    //             // Insert the new transaction
                    //             _transactionService
                    //                 .insertTransaction(transactionCompanion);
                    //           }
                    //         } else {
                    //           // If a debt settlement already exists, delete the transaction
                    //           int? categoryId;
                        
                    //           // Determine the correct categoryId based on the initiator's category name
                    //           if (debtTransactionInitiator
                    //                   .categories.categoryName ==
                    //               'Borrowing') {
                    //             categoryId = await _categoryService
                    //                 .getCategoryId('Paying Debt');
                    //           } else if (debtTransactionInitiator
                    //                   .categories.categoryName ==
                    //               'Lending') {
                    //             categoryId = await _categoryService
                    //                 .getCategoryId('Receive Debt');
                    //           }
                        
                    //           // Ensure categoryId is not null before proceeding
                    //           if (categoryId != null) {
                    //             // Delete the settlement transaction using debtId and categoryId
                    //             await _transactionService.deleteDebtTransactionSettlement(
                    //                 debtTransactionInitiator.debts!.debtId,
                    //                 categoryId);
                    //           }
                    //         }
                    //         // _refreshDebtTransactionDetails();
                    //       },
                    //       icon: Icon(
                    //         Icons.done_outline,
                    //         color: debtTransactionSettlement != null
                    //             ? Colors.green
                    //             : null,
                    //       ),
                    //       iconSize: 40,
                    //     );
                    //   }
                    // ),
                    // Text(debtTransactionSettlement != null
                    //     ? 'Settled'
                    //     : 'Settle'),
                    StreamBuilder<TransactionsWithCategoriesAndDebts?>(
                      stream: _transactionsWithCategoriesAndDebtsService
                          .getDebtTransactionSettlement(debtTransactionInitiator!.debts!.debtId),
                      builder: (context, debtSnapshot) {
                        // Check if the settlement transaction is available
                        final debtTransactionSettlement = debtSnapshot.data;

                        return StreamBuilder<int?>(
                          stream: debtTransactionInitiator.categories.categoryName == 'Borrowing'
                              ? _categoryService.watchCategoryId('Paying Debt')
                              : _categoryService.watchCategoryId('Receive Debt'),
                          builder: (context, categoryIdSnapshot) {
                            final categoryId = categoryIdSnapshot.data;

                            if (categoryId == null) {
                              return const CircularProgressIndicator();
                            }

                            return IconButton.outlined(
                              onPressed: () {
                                if (debtTransactionSettlement == null) {
                                  // Insert a new transaction for debt settlement based on the category type
                                  final transactionCompanion = TransactionsCompanion(
                                    transactionName: drift.Value(
                                        '${debtTransactionInitiator.transactions.transactionName} (Paid)'),
                                    value: drift.Value(debtTransactionInitiator.transactions.value),
                                    transactionDate: drift.Value(DateTime.now()),
                                    transactionType: drift.Value(debtTransactionInitiator
                                                .categories.categoryName ==
                                            'Borrowing'
                                        ? TransactionType.expense
                                        : TransactionType.income), // For paying or receiving debt
                                    categoryId: drift.Value(categoryId),
                                    debtId: drift.Value(debtTransactionInitiator.debts?.debtId),
                                  );

                                  _transactionService.insertTransaction(transactionCompanion);
                                  _debtService.updateSettledDate(debtTransactionInitiator.debts!.debtId, DateTime.now());

                                  if (DateTime.now().isBefore(debtTransactionInitiator.debts!.expectedToBeSettledDate!)) {
                                    _debtService.cancelScheduledDebtNotification(debtTransactionInitiator.debts!.debtId);
                                  }
                                } else {
                                  // Delete the settlement transaction
                                  _transactionService.deleteDebtTransactionSettlement(
                                    debtTransactionInitiator.debts!.debtId,
                                    categoryId,
                                  );
                                  _debtService.updateSettledDate(debtTransactionInitiator.debts!.debtId, null);

                                  // Schedule a notification if the debt becomes unsettled
                                  if (debtTransactionInitiator.debts!.expectedToBeSettledDate != null) {
                                    _debtService.scheduleDebtNotification(
                                      debtTransactionInitiator.debts!.debtId,
                                      debtTransactionInitiator.transactions.transactionName,
                                      debtTransactionInitiator.debts!.peopleName,
                                      debtTransactionInitiator.categories.categoryName,
                                      debtTransactionInitiator.transactions.value,
                                      debtTransactionInitiator.debts!.expectedToBeSettledDate!,
                                    );
                                  }
                                }
                                // Refresh the debt details if necessary
                                // _refreshDebtTransactionDetails();
                              },
                              icon: Icon(
                                Icons.done,
                                color: debtTransactionSettlement != null ? Colors.green : null,
                              ),
                              iconSize: 40,
                            );
                          },
                        );
                      },
                    ),
                    Text(debtTransactionSettlement != null
                         ? 'Settled'
                         : 'Settle'),
                  ],
                ),
                Column(
                  children: [
                    IconButton.outlined(
                      onPressed: () async {
                        // Get the ScaffoldMessenger reference before the async operation
                        final scaffoldMessenger = ScaffoldMessenger.of(context);

                        // Navigate to the TransactionDetailPage and wait for the result
                        final result = await _navigationService.pushToGetResult(
                          MaterialPageRoute(
                          builder: (context) => DebtsFormPage(debtTransactionInitiator: debtTransactionInitiator, debtTransactionSettlement: debtTransactionSettlement,),
                          ),
                        );

                        // Check if the result is 'deleted' and show a snackbar
                        if (result == 'updated') {
                          scaffoldMessenger.showSnackBar(
                            const SnackBar(
                            content: Text('The debt transaction is successfully updated'),
                            duration: Duration(seconds: 2),
                            ),
                          );
                        }      
                      },
                      icon: const Icon(Icons.edit),
                      iconSize: 40,
                    ),
                    const Text('Edit'),
                  ],
                ),
                Column(
                  children: [
                    IconButton.outlined(
                      onPressed: (){
                        // Show confirmation dialog before deleting
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirm Deletion'),
                            content: const Text('Are you sure you want to delete this debt transaction?'),
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
                                  await _debtService.deleteDebt(debtTransactionInitiator.transactions.debtId!);
                                  
                                  _navigationService.goBack();

                                  // Return 'deleted' result when navigating back
                                  _navigationService.goBackWithResult(result: 'deleted');
                                  
                                },
                              ),
                            ],
                          );
                        }
                      );
                      },
                      icon: const Icon(Icons.delete),
                      iconSize: 40,
                    ),
                    const Text('Delete'),
                  ],
                ),
                // Column( //Uncomment for developer release, Comment for user release
                //   children: [
                //     IconButton.outlined(
                //       onPressed: () {
                //         _debtService.triggerDebtNotification(
                //           debtTransactionInitiator.transactions.debtId!, 
                //           debtTransactionInitiator.transactions.transactionName, 
                //           debtTransactionInitiator.debts!.peopleName, 
                //           debtTransactionInitiator.categories.categoryName, 
                //           debtTransactionInitiator.transactions.value, 
                //           debtTransactionInitiator.debts!.expectedToBeSettledDate!);
                //       },
                //       icon: const Icon(Icons.notification_add),
                //       iconSize: 40,
                //     ),
                //     const Text('Notify Test', textAlign: TextAlign.center,),
                //   ],
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
// void _refreshDebtTransactionDetails() async {  //KENE TENGOKK
//   final debtId = widget.debtTransactionInitiator.debts!.debtId;

//   // Fetch both initiator and settlement in parallel
//   final results = await Future.wait([
//     _transactionsWithCategoriesAndDebtsService.getDebtTransactionInitiator(debtId).first,
//     _transactionsWithCategoriesAndDebtsService.getDebtTransactionSettlement(debtId).first,
//   ]);

//   final updatedDebtTransactionInitiator = results[0];
//   final updatedDebtTransactionSettlement = results[1];

//   // Update the UI in a single setState call
//   setState(() {
//     widget.debtTransactionInitiator = updatedDebtTransactionInitiator!;
//     widget.debtTransactionSettlement = updatedDebtTransactionSettlement;
//   });
// }

}
