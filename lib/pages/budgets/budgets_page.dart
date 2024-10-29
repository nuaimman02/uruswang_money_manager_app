import 'package:flutter/material.dart';
import 'package:flutter_custom_month_picker/flutter_custom_month_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:uruswang_money_manager_app/pages/budgets/budget_form_page.dart';
import 'package:uruswang_money_manager_app/pages/budgets/budget_detail_page.dart';
import 'package:uruswang_money_manager_app/services/database_service/app_database.dart';
import 'package:uruswang_money_manager_app/services/model_service/budget_service.dart';
import 'package:uruswang_money_manager_app/services/model_service/date_and_time_formatter_service.dart';
import 'package:uruswang_money_manager_app/services/model_service/transactions_with_categories_and_debts_service.dart';
import 'package:uruswang_money_manager_app/services/navigation_service.dart';

class BudgetsPage extends StatefulWidget {
  const BudgetsPage({super.key});

  @override
  State<BudgetsPage> createState() => _BudgetsPageState();
}

class _BudgetsPageState extends State<BudgetsPage> {
  final GetIt _getIt = GetIt.instance;
  late NavigationService _navigationService;
  late BudgetService _budgetService;
  late TransactionsWithCategoriesAndDebtsService
      _transactionsWithCategoriesAndDebtsService;
  late DateAndTimeFormatterService _dateAndTimeFormatterService;

  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _navigationService = _getIt.get<NavigationService>();
    _budgetService = _getIt.get<BudgetService>();
    _transactionsWithCategoriesAndDebtsService =
        _getIt.get<TransactionsWithCategoriesAndDebtsService>();
    _dateAndTimeFormatterService = _getIt.get<DateAndTimeFormatterService>();
  }

  // Function to subtract a month
  void _subtractMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1);
    });
  }

  // Function to add a month
  void _addMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _buildUI(),
      floatingActionButton: _budgetsFloatingActionButton(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text('Budgets'),
      backgroundColor: Colors.lightGreen[100],
    );
  }

  Widget _buildUI() {
    return SafeArea(
        child: SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _monthYearHeader(),
          ),
          _budgetList(),
        ],
      ),
    ));
  }

  Widget _budgetsFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () async{
        // Get the ScaffoldMessenger reference before the async operation
        final scaffoldMessenger = ScaffoldMessenger.of(context);

        // Navigate to the TransactionDetailPage and wait for the result
        final result = await _navigationService.pushToGetResult(
          MaterialPageRoute(
            builder: (context) => const BudgetFormPage(),
          ),
        );

        // Check if the result is 'deleted' and show a snackbar
        if (result == 'inserted') {
          scaffoldMessenger.showSnackBar(
            const SnackBar(
              content: Text('The budget is successfully inserted'),
              duration: Duration(seconds: 2),
            ),
          );
        }  
      },      
      label: const Text('Budget'),
      icon: const Icon(Icons.add),
    );
  }

  Widget _monthYearHeader() {
    String displayDate = _dateAndTimeFormatterService
        .returnCurrentMonthNameAndYear(_selectedDate);

    return Container(
      //color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        width: 350, // Set a fixed width for the entire header
        decoration: BoxDecoration(
          color: Colors.green, // Set the main background color to green
          borderRadius: BorderRadius.circular(16), // Fully rounded corners
          border: Border.all(
              color: Colors.green, width: 2), // Border matching the background
        ),
        child: Row(
          children: [
            // Previous Month Arrow in White Box with Fixed Width
            GestureDetector(
              onTap: () {
                setState(() {
                  _subtractMonth();
                });
              },
              child: Container(
                width: 50, // Fixed width for the arrow
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(16)), // Rounded on the left
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.arrow_left,
                  size: 24,
                  color: Colors.green, // Match icon color to the background
                ),
              ),
            ),

            // Month-Year Display Centered with Expanded
            Expanded(
              child: GestureDetector(
                onTap: () async {
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
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  alignment: Alignment.center, // Center the text
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        displayDate,
                        style: const TextStyle(
                          fontSize: 20,
                          color:
                              Colors.white, // White text color for visibility
                        ),
                      ),
                      const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white, // White icon color
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Next Month Arrow in White Box with Fixed Width
            GestureDetector(
              onTap: () {
                setState(() {
                  _addMonth();
                });
              },
              child: Container(
                width: 50, // Fixed width for the arrow
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(16)), // Rounded on the right
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.arrow_right,
                  size: 24,
                  color: Colors.green, // Match icon color to the background
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //PERHATI DUA BAWAH NI TAKUT BUAT HAL
  Widget _budgetList() {
    return StreamBuilder<List<Budget>>(
      stream: _budgetService.watchAllBudgetsForCurrentMonth(_selectedDate),
      builder: (context, snapshot) {
        String formattedMonthNameAndYear = _dateAndTimeFormatterService
            .returnCurrentMonthNameAndYear(_selectedDate);

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
                  'No budgets available for $formattedMonthNameAndYear', textAlign: TextAlign.center,)); // No data available
        }

        final budgets = snapshot.data!;

        return ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: budgets.length,
            itemBuilder: (context, index) {
              final budget = budgets[index];
              return _budgetCard(budget);
            });
      },
    );
  }

  Widget _budgetCard(Budget budgetItem) {
    return StreamBuilder(
        stream: _transactionsWithCategoriesAndDebtsService
            .watchTotalSpentForCategoryInCurrentMonth(
                budgetItem.categoryId, _selectedDate),
        builder: (context, snapshot) {
          double spentAmount = snapshot.data ?? 0.0;
          double budgetAmount = budgetItem.budgetedValue;
          double spendingPercentage = spentAmount / budgetAmount;
          double clampedSpendingPercentage = spendingPercentage.clamp(
              0.0, 1.0); // Use this for the progress indicator

          // Determine progress color based on the spending percentage
          Color progressColor;
          if (spendingPercentage < 0.8) {
            progressColor = Colors.green; // Green for less than 80%
          } else if (spendingPercentage < 1.0) {
            progressColor = Colors.amber; // Yellow for 80% to less than 100%
          } else {
            progressColor = Colors.red; // Red for 100% and above
          }

          Color percentageColor;
          if (spendingPercentage < 0.8) {
            percentageColor = Colors.green; // Green for less than 80%
          } else if (spendingPercentage < 1.0) {
            percentageColor = Colors.amber; // Yellow for 80% to less than 100%
          } else {
            percentageColor = Colors.red; // Red for 100% and above
          }

          return GestureDetector(
            onTap: () async {
              // Get the ScaffoldMessenger reference before the async operation
              final scaffoldMessenger = ScaffoldMessenger.of(context);

              final result = await _navigationService
                  .pushToGetResult(MaterialPageRoute(builder: (context) {
                return BudgetDetailPage(
                    budgetId: budgetItem.budgetId);
              }));

              // Check if the result is 'deleted' and show a snackbar
              if (result == 'deleted') {
                scaffoldMessenger.showSnackBar(
                  const SnackBar(
                    content:
                        Text('The budget is successfully deleted'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: Card(
              margin: const EdgeInsets.all(12),
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(width: 1)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Row (Percentage and Title)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Budget Title
                        Text(
                          budgetItem.budgetName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Spending Percentage
                        Text(
                          '${(spendingPercentage * 100).toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: percentageColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Linear Progress Indicator with dynamic color
                    LinearProgressIndicator(
                      value: clampedSpendingPercentage,
                      backgroundColor: Colors.grey[300],
                      color: progressColor,
                    ),
                    const SizedBox(height: 10),

                    // Bottom Rows (Spent Amount and Budgeted Amount)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Amount Spent
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Amount Spent',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              'RM ${spentAmount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        // Budgeted Amount
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Budgeted Amount',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              'RM ${budgetAmount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
