import 'package:flutter/material.dart';
import 'package:flutter_custom_month_picker/flutter_custom_month_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:uruswang_money_manager_app/models/transactions_with_categories_and_debts.dart';
import 'package:uruswang_money_manager_app/pages/debts/debts_detail_page.dart';
import 'package:uruswang_money_manager_app/pages/transactions/transaction_detail_page.dart';
import 'package:uruswang_money_manager_app/pages/transactions/transaction_form_page.dart';
import 'package:uruswang_money_manager_app/services/model_service/date_and_time_formatter_service.dart';
import 'package:uruswang_money_manager_app/services/model_service/transactions_with_categories_and_debts_service.dart';
import 'package:uruswang_money_manager_app/services/navigation_service.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  final GetIt _getIt = GetIt.instance;
  late NavigationService _navigationService;
  late DateAndTimeFormatterService _dateAndTimeFormatterService;
  late TransactionsWithCategoriesAndDebtsService
      _transactionsWithCategoriesAndDebtsService;

  DateTime _selectedDate = DateTime.now();
  double totalIncomeOnCurrentMonth = 0.0;
  double totalExpenseOnCurrentMonth = 0.0;
  double totalBalanceOnCurrentMonth = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _navigationService = _getIt.get<NavigationService>();
    _transactionsWithCategoriesAndDebtsService =
        _getIt.get<TransactionsWithCategoriesAndDebtsService>();
    _dateAndTimeFormatterService = _getIt.get<DateAndTimeFormatterService>();

    _getIncomeExpenseAndTotalBalance();
  }

  // Method untuk dapatkan total income dan expense
  void _getIncomeExpenseAndTotalBalance() {
    // Listen to total income stream
    _transactionsWithCategoriesAndDebtsService
        .getTotalIncomeForCurrentMonth(_selectedDate)
        .listen((income) {
      setState(() {
        totalIncomeOnCurrentMonth = income;
      });
    });

    // Listen to total expense stream
    _transactionsWithCategoriesAndDebtsService
        .getTotalExpenseForCurrentMonth(_selectedDate)
        .listen((expense) {
      setState(() {
        totalExpenseOnCurrentMonth = expense;
      });
    });

    // Listen to total balance stream
    _transactionsWithCategoriesAndDebtsService
        .getTotalBalanceForCurrentMonth(_selectedDate)
        .listen((balance) {
      setState(() {
        totalBalanceOnCurrentMonth = balance;
      });
    });
  }

  // Function to subtract a month
  void _subtractMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1);
    });
    _getIncomeExpenseAndTotalBalance();
  }

  // Function to add a month
  void _addMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1);
    });
    _getIncomeExpenseAndTotalBalance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _buildUI(),
      floatingActionButton: _transactionFloatingActionButton(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text('Transactions'),
      backgroundColor: Colors.lightGreen[100],
    );
  }

  Widget _buildUI() {
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          children: [
            _monthYearWidget(),
            //_dateTimelineWidget(),
            _incomeExpenseContainer(),
            _transactionsList(),
            _footer(),
          ],
        ),
      ),
    );
  }

  Widget _footer() {
    return const SizedBox(
      height: 60,
    );
  }

  Widget _monthYearWidget() {
    String displayDate = _dateAndTimeFormatterService
        .returnCurrentMonthNameAndYear(_selectedDate);
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 184, 221, 189),
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                child: const Row(
                  children: [
                    Icon(Icons.arrow_back_ios),
                    Text('Previous Month'),
                  ],
                ),
                onTap: () {
                  _subtractMonth();
                },
              ),
              GestureDetector(
                child: const Row(
                  children: [
                    Text('Next Month'),
                    Icon(Icons.arrow_forward_ios),
                  ],
                ),
                onTap: () {
                  _addMonth();
                },
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  displayDate,
                  style: const TextStyle(fontSize: 30),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
            onTap: () async {
              // Show the month-year picker
              // DateTime? pickedDate = await showMonthYearPicker(
              //   context: context,
              //   initialDate: _selectedDate, // _selectedDate is non-null
              //   firstDate: DateTime(2015), // First selectable date
              //   lastDate: DateTime(2030),
              // );
              showMonthPicker(
                context,
                onSelected: (month, year) {
                  setState(() {
                    _selectedDate = DateTime(year, month);
                  });
                },
                initialSelectedMonth: _selectedDate.month,
                initialSelectedYear: _selectedDate.year,
                firstYear: 2020,
                lastYear: 2030,
              );
            },
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  // Widget _dateTimelineWidget() {
  //   return EasyDateTimeLine(
  //     initialDate: DateTime.now(),
  //     onDateChange: (newSelectedDate) {
  //       _selectedDate = newSelectedDate;
  //     },
  //     // headerProps: const EasyHeaderProps(
  //     //   monthPickerType: MonthPickerType.dropDown,
  //     //   dateFormatter: DateFormatter.fullDateDMonthAsStrY(),
  //     // ),
  //     );
  // }

  Widget _incomeExpenseContainer() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.grey[800], borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.attach_money,
                    color: Colors.black,
                    size: 35,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Balance',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text('RM ${totalBalanceOnCurrentMonth.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.white))
                  ],
                ),
              ],
            ),
            const Divider(),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)),
                  child: const Icon(
                    Icons.download,
                    color: Colors.green,
                    size: 35,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Income',
                        style: TextStyle(
                          color: Colors.green,
                        )),
                    Text('RM ${totalIncomeOnCurrentMonth.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.green))
                  ],
                ),
                  ],
                ),
                // const VerticalDivider(
                //   width: 40,
                //   thickness: 5,
                //   color: Colors.white,
                // ),
                // const SizedBox(
                //   width: 40,
                // ),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                      child: const Icon(
                        Icons.upload,
                        color: Colors.red,
                        size: 35,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Expense',
                            style: TextStyle(
                              color: Colors.red[500],
                            )),
                        Text(
                            'RM ${totalExpenseOnCurrentMonth.toStringAsFixed(2)}',
                            style: TextStyle(color: Colors.red[500]))
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _transactionFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () async {
        // Get the ScaffoldMessenger reference before the async operation
        final scaffoldMessenger = ScaffoldMessenger.of(context);

        // Navigate to the TransactionDetailPage and wait for the result
        final result = await _navigationService.pushToGetResult(
          MaterialPageRoute(
            builder: (context) => const TransactionFormPage(),
          ),
        );

        // Check if the result is 'deleted' and show a snackbar
        if (result == 'inserted') {
          scaffoldMessenger.showSnackBar(
            const SnackBar(
              content: Text('The transaction is successfully inserted'),
              duration: Duration(seconds: 2),
            ),
          );
        }        
      },
      label: const Text('Transaction'),
      icon: const Icon(Icons.add),
    );
  }

  Widget _transactionsList() {
    return StreamBuilder<List<TransactionsWithCategoriesAndDebts>>(
      stream: _transactionsWithCategoriesAndDebtsService
          .getTransactionsWithCategoriesAndDebtsOnCurrentMonth(_selectedDate),
      builder: (context, snapshot) {
        String formattedMonthNameAndYear =
            _dateAndTimeFormatterService.returnCurrentMonthNameAndYear(
                _selectedDate); // Format the selected date
        // developer.log(
        //     "Selected Date: $formattedMonthNameAndYear"); // Debugging output

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child:
                  CircularProgressIndicator()); // Show loading spinner while waiting for data
        }

        if (snapshot.hasError) {
          return Center(
              child: Text('Error: ${snapshot.error}')); // Display error message
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
              child: Text(
                  'No transactions available for $formattedMonthNameAndYear', textAlign: TextAlign.center,)); // No data available
        }

        //LATER IMPLEMENTATION IN BUDGETS AND FILTERS NEED TO REFER THIS!!!
        // Group transactions by date
        final groupedTransactions =
            <String, List<TransactionsWithCategoriesAndDebts>>{};

        for (var transaction in snapshot.data!) {
          // Format the transaction date
          String transactionDate =
              _dateAndTimeFormatterService.formatDateDayTransactionListDisplay(
                  transaction.transactions.transactionDate);

          if (groupedTransactions[transactionDate] == null) {
            groupedTransactions[transactionDate] = [];
          }
          groupedTransactions[transactionDate]!.add(transaction);
        }

        // Sort dates in descending order
        final sortedDates = groupedTransactions.keys.toList()
          ..sort((a, b) => b.compareTo(a));

        // Untuk setiap tarikh, susun transaksi berdasarkan masa
        for (var date in sortedDates) {
          List<TransactionsWithCategoriesAndDebts> transactionsOnDate =
              groupedTransactions[date]!;

          // Sort transactions by time (DateTime)
          transactionsOnDate.sort((a, b) => b.transactions.transactionDate
              .compareTo(a.transactions.transactionDate));

          groupedTransactions[date] = transactionsOnDate;
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: sortedDates.length,
          itemBuilder: (context, index) {
            String date = sortedDates[index];

            List<TransactionsWithCategoriesAndDebts> transactionsOnDate =
                groupedTransactions[date]!;

            // Kira jumlah pendapatan dan perbelanjaan
            double totalIncomeOnDate = transactionsOnDate
                .where((transaction) =>
                    transaction.transactions.transactionType.name == 'income')
                .fold(0.0,
                    (sum, transaction) => sum + transaction.transactions.value);

            double totalExpenseOnDate = transactionsOnDate
                .where((transaction) =>
                    transaction.transactions.transactionType.name == 'expense')
                .fold(0.0,
                    (sum, transaction) => sum + transaction.transactions.value);

            return Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                      border:
                          Border(bottom: BorderSide(style: BorderStyle.solid))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display the date header
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          date,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Divider(
                        height: 1,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: const Border(
                                top: BorderSide(
                                    style: BorderStyle.solid,
                                    color: Colors.black),
                                bottom: BorderSide(style: BorderStyle.solid)),
                            color: Colors.grey[200]),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  const Text(
                                    'Total Income',
                                    style: TextStyle(
                                        color: Colors.green, fontSize: 16),
                                  ),
                                  Text(
                                    'RM${totalIncomeOnDate.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        color: Colors.green, fontSize: 16),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  const Text(
                                    'Total Expense',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 16),
                                  ),
                                  Text(
                                    'RM${totalExpenseOnDate.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 16),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      ListView.builder(
                        // Display the transactions for the selected date
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: transactionsOnDate.length,
                        itemBuilder: (context, transIndex) {
                          final transaction = transactionsOnDate[transIndex];

                          String transactionTime =
                              _dateAndTimeFormatterService.formatTimeTo24H(
                                  transaction.transactions.transactionDate);

                          // Tukar warna latar belakang secara bergilir
                          Color tileColor = (transIndex % 2 == 0)
                              ? Colors.lightBlue[50]!
                              : Colors.lightGreen[50]!;

                          if (transaction.debts?.debtId == null) {
                            return Container(
                              color: tileColor,
                              child: ListTile(
                                title: Text(
                                    transaction.transactions.transactionName),
                                subtitle:
                                    Text(transaction.categories.categoryName),
                                trailing: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        'RM ${transaction.transactions.value.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          color: transaction.transactions
                                                      .transactionType.name ==
                                                  'income'
                                              ? Colors.green
                                              : Colors.red,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                    Flexible(child: Text(transactionTime)),
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
                          } else if (transaction.debts?.debtId != null) {
                            return Container(
                              color: tileColor,
                              child: ListTile(
                                title: Text(
                                    transaction.transactions.transactionName),
                                subtitle: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(transaction.categories.categoryName),
                                    Text(', ${transaction.debts?.peopleName}'),
                                  ],
                                ),
                                trailing: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        'RM ${transaction.transactions.value.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          color: transaction.transactions
                                                      .transactionType.name ==
                                                  'income'
                                              ? Colors.green
                                              : Colors.red,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                    Text(transactionTime),
                                    if (transaction.debts?.settledDate !=
                                        null) ...[
                                      const Text('Settled'),
                                    ] else ...[
                                      const Text('Unsettled'),
                                    ]
                                  ],
                                ),
                                onTap: () async {
                                  //final debtId = transaction.debts!.debtId;
                                  // Fetch both debtInitiator and debtSettlement using await
                                  // final debtInitiator =
                                  //     await _transactionsWithCategoriesAndDebtsService
                                  //         .getDebtTransactionInitiator(debtId)
                                  //         .first;
                                  // final debtSettlement =
                                  //     await _transactionsWithCategoriesAndDebtsService
                                  //         .getDebtTransactionSettlement(debtId)
                                  //         .first;
                                  
                                  // Get the ScaffoldMessenger reference before the async operation
                                  final scaffoldMessenger = ScaffoldMessenger.of(context);

                                  final result = await _navigationService.pushToGetResult(
                                      MaterialPageRoute(builder: (context) {
                                        return DebtsDetailPage(
                                            // debtTransactionInitiator: debtInitiator,
                                            // debtTransactionSettlement:debtSettlement);
                                            debtId: transaction.debts!.debtId);
                                      }));

                                    // Check if the result is 'deleted' and show a snackbar
                                    if (result == 'deleted') {
                                      scaffoldMessenger.showSnackBar(
                                        const SnackBar(
                                          content: Text('The debt transaction is successfully deleted'),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                  }
                                },
                              ),
                            );
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                )
              ],
            );
          },
        );
      },
    );
  }
}
