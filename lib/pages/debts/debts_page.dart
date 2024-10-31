import 'package:flutter/material.dart';
import 'package:flutter_custom_month_picker/flutter_custom_month_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:uruswang_money_manager_app/models/transactions_with_categories_and_debts.dart';
import 'package:uruswang_money_manager_app/pages/debts/debts_detail_page.dart';
import 'package:uruswang_money_manager_app/pages/debts/debts_form_page.dart';
import 'package:uruswang_money_manager_app/services/model_service/date_and_time_formatter_service.dart';
import 'package:uruswang_money_manager_app/services/model_service/transactions_with_categories_and_debts_service.dart';
import 'package:uruswang_money_manager_app/services/navigation_service.dart';

class DebtsPage extends StatefulWidget {
  const DebtsPage({super.key});

  @override
  State<DebtsPage> createState() => _DebtsPageState();
}

class _DebtsPageState extends State<DebtsPage> {
  final GetIt _getIt = GetIt.instance;
  late NavigationService _navigationService;
  late DateAndTimeFormatterService _dateAndTimeFormatterService;
  late TransactionsWithCategoriesAndDebtsService
      _transactionsWithCategoriesAndDebtsService;

  int _selectedIndex = 0; // 0 for Borrowing, 1 for Lending

  DateTime _selectedDate = DateTime.now();

  double totalBorrowingOnCurrentMonth = 0.0;
  double totalBorrowingPaidOnCurrentMonth = 0.0;
  double totalBorrowingBalanceOnCurrentMonth = 0.0;

  double totalLendingOnCurrentMonth = 0.0;
  double totalLendingPaidOnCurrentMonth = 0.0;
  double totalLendingBalanceOnCurrentMonth = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _navigationService = _getIt.get<NavigationService>();
    _transactionsWithCategoriesAndDebtsService =
        _getIt.get<TransactionsWithCategoriesAndDebtsService>();
    _dateAndTimeFormatterService = _getIt.get<DateAndTimeFormatterService>();

    _getDebtsTotalAndBalances();
  }

  void _getDebtsTotalAndBalances() {
    // Listen to total income stream
    _transactionsWithCategoriesAndDebtsService
        .getTotalBorrowingForCurrentMonth(_selectedDate)
        .listen((totalBorrow) {
      setState(() {
        totalBorrowingOnCurrentMonth = totalBorrow;
      });
    });

    // Listen to total expense stream
    _transactionsWithCategoriesAndDebtsService
        .getTotalBorrowingPaidForCurrentMonth(_selectedDate)
        .listen((totalBorrowPaid) {
      setState(() {
        totalBorrowingPaidOnCurrentMonth = totalBorrowPaid;
      });
    });

    _transactionsWithCategoriesAndDebtsService
        .getTotalBorrowingBalanceForCurrentMonth(_selectedDate)
        .listen((totalBorrowBalance) {
      setState(() {
        totalBorrowingBalanceOnCurrentMonth = totalBorrowBalance;
      });
    });

    // Listen to total balance stream
    _transactionsWithCategoriesAndDebtsService
        .getTotalLendingForCurrentMonth(_selectedDate)
        .listen((totalLend) {
      setState(() {
        totalLendingOnCurrentMonth = totalLend;
      });
    });

    _transactionsWithCategoriesAndDebtsService
        .getTotalLendingPaidForCurrentMonth(_selectedDate)
        .listen((totalLendPaid) {
      setState(() {
        totalLendingPaidOnCurrentMonth = totalLendPaid;
      });
    });

    _transactionsWithCategoriesAndDebtsService
        .getTotalLendingBalanceForCurrentMonth(_selectedDate)
        .listen((totalLendBalance) {
      setState(() {
        totalLendingBalanceOnCurrentMonth = totalLendBalance;
      });
    });
  }

  // Function to subtract a month
  void _subtractMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1);
      _getDebtsTotalAndBalances();
    });
  }

  // Function to add a month
  void _addMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1);
      _getDebtsTotalAndBalances();
    });
  }

  // Function to toggle between views (Borrowing and Lending)
  void _onCategorySelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _buildUI(),
      floatingActionButton: _debtsFloatingActionButton(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text('Debts'),
      backgroundColor: Colors.lightGreen[100],
    );
  }

  Widget _buildUI() {
    return SafeArea(
        child: SingleChildScrollView(
      child: Column(
        children: [
          _monthYearWidget(),
          const SizedBox(height: 10,),
          _changingDebtViewButton(),
          _stackedView(),
          _footer(),
        ],
      ),
    ));
  }

  Widget _footer() {
    return const SizedBox(
      height: 60,
    );
  }

  Widget _debtsFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () async {
        // Get the ScaffoldMessenger reference before the async operation
        final scaffoldMessenger = ScaffoldMessenger.of(context);

        // Navigate to the TransactionDetailPage and wait for the result
        final result = await _navigationService.pushToGetResult(
          MaterialPageRoute(
            builder: (context) => const DebtsFormPage(),
          ),
        );

        // Check if the result is 'deleted' and show a snackbar
        if (result == 'inserted') {
          scaffoldMessenger.showSnackBar(
            const SnackBar(
              content: Text('The debt transaction is successfully inserted'),
              duration: Duration(seconds: 2),
            ),
          );
        }        
      },
      label: const Text('Debt'),
      icon: const Icon(Icons.add),
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

  Widget _changingDebtViewButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            _onCategorySelected(0);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _selectedIndex == 0
                ? Colors.green[200]
                : Colors.grey[300], // Green when selected, grey otherwise
            shape: const LinearBorder(),
          ),
          label: const Text('Borrowing'),
          icon: const Icon(
            Icons.download,
            color: Colors.green,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        ElevatedButton.icon(
          onPressed: () {
            _onCategorySelected(1);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _selectedIndex == 1
                ? Colors.red[200]
                : Colors.grey[300], // Red when selected, grey otherwise
            shape: const LinearBorder(),
          ),
          label: const Text('Lending'),
          icon: const Icon(
            Icons.upload,
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _stackedView() {
    // IndexedStack to display the correct view based on selection
    return IndexedStack(
      index: _selectedIndex, // Switch between borrowing and lending views
      children: [
        _buildBorrowingView(),
        _buildLendingView(),
      ],
    );
  }

  Widget _buildBorrowingView() {
    String borrowCategoryName = 'Borrowing';

    return Column(
      children: [
        _debtsTotalAndBalancesContainer(borrowCategoryName),
        _debtsListView(borrowCategoryName),
      ],
    );
  }

  Widget _buildLendingView() {
    String lendCategoryName = 'Lending';

    return Column(
      children: [
        _debtsTotalAndBalancesContainer(lendCategoryName),
        _debtsListView(lendCategoryName),
      ],
    );
  }

  Widget _debtsTotalAndBalancesContainer(String initiatorDebtCategoryName) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.grey[800], borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (initiatorDebtCategoryName == 'Borrowing') ...[
                  const Text(
                    'Total Amount Borrowed',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('RM ${totalBorrowingOnCurrentMonth.toStringAsFixed(2)}',
                      style: const TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold))
                ] else if (initiatorDebtCategoryName == 'Lending') ...[
                  const Text(
                    'Total Amount Lend',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    softWrap: true,
                  ),
                  Text('RM ${totalLendingOnCurrentMonth.toStringAsFixed(2)}',
                      style: const TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold))
                ]
              ],
            ),
            const SizedBox(
              width: 15,
            ),
            const Divider(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (initiatorDebtCategoryName == 'Borrowing') ...[
                  const Text(
                    'Total Amount Borrowed Paid',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                      'RM ${totalBorrowingPaidOnCurrentMonth.toStringAsFixed(2)}',
                      style: const TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold)),
                ] else if (initiatorDebtCategoryName == 'Lending') ...[
                  const Text(
                    'Total Amount Lend Paid',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    softWrap: true,
                  ),
                  Text(
                      'RM ${totalLendingPaidOnCurrentMonth.toStringAsFixed(2)}',
                      style: const TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold))
                ]
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Container(
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.circular(8),
                //   ),
                //   child: const Icon(
                //     Icons.attach_money,
                //     color: Colors.black,
                //     size: 35,
                //   ),
                // ),
                // const SizedBox(
                //   width: 10,
                // ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (initiatorDebtCategoryName == 'Borrowing') ...[
                      const Text(
                        'Total Borrowing Balance',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                          'RM ${totalBorrowingBalanceOnCurrentMonth.toStringAsFixed(2)}',
                          style: const TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold))
                    ] else if (initiatorDebtCategoryName == 'Lending') ...[
                      const Text(
                        'Total Lending Balance',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                          'RM ${totalLendingBalanceOnCurrentMonth.toStringAsFixed(2)}',
                          style: const TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold))
                    ]
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _debtsListView(String initiatorDebtCategoryName) {
    return StreamBuilder<List<TransactionsWithCategoriesAndDebts>>(
      stream: _transactionsWithCategoriesAndDebtsService
          .getTransactionsWithCategoriesAndDebtsOnCurrentMonthForSpecificCategory(
              _selectedDate, initiatorDebtCategoryName),
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    'No ${initiatorDebtCategoryName.toLowerCase()} transactions available for \n$formattedMonthNameAndYear',
                    textAlign: TextAlign.center,),
              )); // No data available
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

            // // Kira jumlah pendapatan dan perbelanjaan
            // double totalIncomeOnDate = transactionsOnDate
            //     .where((transaction) =>
            //         transaction.transactions.transactionType.name == 'income')
            //     .fold(0.0,
            //         (sum, transaction) => sum + transaction.transactions.value);

            // double totalExpenseOnDate = transactionsOnDate
            //     .where((transaction) =>
            //         transaction.transactions.transactionType.name == 'expense')
            //     .fold(0.0,
            //         (sum, transaction) => sum + transaction.transactions.value);

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
                        color: Colors.black,
                      ),
                      // Container(
                      //   decoration: BoxDecoration(border: Border(top: BorderSide(style: BorderStyle.solid, color: Colors.black), bottom: BorderSide(style: BorderStyle.solid)), color: Colors.grey[200]),
                      //   child: Padding(
                      //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //       children: [
                      //         Column(
                      //           children: [
                      //             Text('Total Income', style: const TextStyle(color: Colors.green, fontSize: 16),),
                      //             Text('RM${totalIncomeOnDate.toStringAsFixed(2)}', style: const TextStyle(color: Colors.green, fontSize: 16),)
                      //           ],
                      //         ),
                      //         Column(
                      //           children: [
                      //             Text('Total Expense', style: const TextStyle(color: Colors.red, fontSize: 16),),
                      //             Text('RM${totalExpenseOnDate.toStringAsFixed(2)}', style: const TextStyle(color: Colors.red, fontSize: 16),)
                      //           ],
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
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

                          // Filter transactions that only belong to 'Borrowing' or 'Lending' categories
                          if (transaction.debts?.debtId != null && transaction.categories.categoryName == initiatorDebtCategoryName) {
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
                                  // Fetch both debtInitiator and debtSettlement using await
                                  // final debtInitiator = await _transactionsWithCategoriesAndDebtsService.getDebtTransactionInitiator(debtId).first;
                                  // final debtSettlement = await _transactionsWithCategoriesAndDebtsService.getDebtTransactionSettlement(debtId).first;

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
