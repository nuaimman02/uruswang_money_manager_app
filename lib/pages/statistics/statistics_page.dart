import 'package:flutter/material.dart';
import 'package:flutter_custom_month_picker/flutter_custom_month_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uruswang_money_manager_app/pages/statistics/widgets/category_pie_chart.dart';
import 'package:uruswang_money_manager_app/pages/statistics/widgets/daily_income_expense_line_chart.dart';
import 'package:uruswang_money_manager_app/pages/statistics/widgets/daily_total_balance_line_chart.dart';
import 'package:uruswang_money_manager_app/pages/statistics/widgets/debt_to_income_rate_card.dart';
//import 'package:uruswang_money_manager_app/pages/statistics/widgets/income_expense_ratio_card.dart';
import 'package:uruswang_money_manager_app/pages/statistics/widgets/savings_rate_card.dart';
import 'package:uruswang_money_manager_app/services/model_service/date_and_time_formatter_service.dart';
import 'package:uruswang_money_manager_app/services/model_service/transactions_with_categories_and_debts_service.dart';
import 'dart:developer' as developer;

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage>
    with SingleTickerProviderStateMixin {
  final GetIt _getIt = GetIt.instance;
  late DateAndTimeFormatterService _dateAndTimeFormatterService;
  late TransactionsWithCategoriesAndDebtsService
      _transactionsWithCategoriesAndDebtsService;
  late TabController _tabController;

  DateTime _selectedDate = DateTime.now();

  // BehaviorSubject for caching stream data and allowing multiple listeners
  final BehaviorSubject<Map<String, dynamic>> _combinedStreamSubject =
      BehaviorSubject<Map<String, dynamic>>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dateAndTimeFormatterService = _getIt.get<DateAndTimeFormatterService>();
    _transactionsWithCategoriesAndDebtsService =
        _getIt.get<TransactionsWithCategoriesAndDebtsService>();

    _tabController = TabController(length: 4, vsync: this);

    // Initialize the stream with the current month
    _updateStream();
  }

  // Dynamically recreate streams when the selected date changes
  void _updateStream() {
    // Clear previous data
    _combinedStreamSubject.add({});

    final streams = [
      _transactionsWithCategoriesAndDebtsService
        .getTotalIncomeForCurrentMonth(_selectedDate),
      _transactionsWithCategoriesAndDebtsService
        .getTotalExpenseForCurrentMonth(_selectedDate),
      _transactionsWithCategoriesAndDebtsService
        .getTotalBalanceForCurrentMonth(_selectedDate),
      _transactionsWithCategoriesAndDebtsService
        .getDailyIncomeForMonth(_selectedDate),
      _transactionsWithCategoriesAndDebtsService
        .getDailyExpenseForMonth(_selectedDate),
      _transactionsWithCategoriesAndDebtsService
        .getDailyTotalBalanceForMonth(_selectedDate),
      _transactionsWithCategoriesAndDebtsService
        .getTotalBorrowingForCurrentMonth(_selectedDate),
    ];

    // Use combineLatestList to combine all streams in the list
    Rx.combineLatestList<dynamic>(streams).listen((values) {
      final monthlyIncome = values[0] ?? 0.0;
      final monthlyExpense = values[1] ?? 0.0;
      final monthlyTotalBalance = values[2] ?? 0.0;
      final dailyIncome = values[3];
      final dailyExpense = values[4];
      final dailyTotalBalance = values[5];
      final monthlyBorrowing = values[6] ?? 0.0;

      double? savingsRate;
      //double? incomeExpenseRatio;
      double? debtToIncomeRatio;
      double? totalMonthlyIncomeMinusBorrowing;

      if (monthlyIncome == 0 && monthlyExpense == 0) {
        savingsRate = null;
        //incomeExpenseRatio = null;
      } else {
        savingsRate = monthlyIncome > 0
            ? ((monthlyTotalBalance) / monthlyIncome) * 100
            : null;
        // incomeExpenseRatio =
        //     monthlyExpense > 0 ? monthlyIncome / monthlyExpense : null;
      }

      if(monthlyIncome == 0 && monthlyBorrowing == 0) {
        debtToIncomeRatio = null;
      } else {
        totalMonthlyIncomeMinusBorrowing = monthlyIncome - monthlyBorrowing;
        debtToIncomeRatio = totalMonthlyIncomeMinusBorrowing! > 0 ? monthlyBorrowing / totalMonthlyIncomeMinusBorrowing : null;
      }

      // Add the calculated data to the BehaviorSubject
      _combinedStreamSubject.add({
        'savingsRate': savingsRate,
        //'incomeExpenseRatio': incomeExpenseRatio,
        'totalMonthlyIncome': monthlyIncome,
        'totalMonthlyExpense': monthlyExpense,
        'totalMonthlyBalance': monthlyTotalBalance,
        'totalDailyIncome': dailyIncome,
        'totalDailyExpense': dailyExpense,
        'dailyTotalBalance': dailyTotalBalance,
        'debtToIncomeRatio': debtToIncomeRatio,
      });
    }).onError((error) {
      _combinedStreamSubject.addError(error);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _combinedStreamSubject.close();
    // TODO: implement dispose
    super.dispose();
  }

  // Function to subtract a month
  void _subtractMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1);
      _updateStream(); // Update the stream when the month changes
    });
  }

  // Function to add a month
  void _addMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1);
      _updateStream(); // Update the stream when the month changes
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: _appBar(),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _monthYearHeader(),
            ),
            Expanded(child: _buildUI()), // Ensure Expanded is around _buildUI
          ],
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text('Statistics'),
      backgroundColor: Colors.lightGreen[100],
      bottom: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: 'Financial Health'),
          Tab(text: 'Distribution'),
          Tab(text: 'Balance Evaluation'),
          Tab(text: 'Cash Flow'),
        ],
        isScrollable: true,
      ),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: TabBarView(
        controller: _tabController,
        children: [
          _financialHealthView(),
          _distributionView(),
          _balanceEvaluationView(),
          _cashFlowView(),
        ],
      ),
    );
  }

  Widget _monthYearHeader() {
    String displayDate = _dateAndTimeFormatterService
        .returnCurrentMonthNameAndYear(_selectedDate);

    return Container(
      //color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        width: 350,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.green, width: 2),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: _subtractMonth,
              child: Container(
                width: 50,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.horizontal(left: Radius.circular(16)),
                ),
                padding: const EdgeInsets.all(8),
                child:
                    const Icon(Icons.arrow_left, size: 24, color: Colors.green),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  showMonthPicker(
                    context,
                    onSelected: (month, year) {
                      setState(() {
                        _selectedDate = DateTime(year, month);
                        _updateStream(); // Update stream when selecting new date
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
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(displayDate,
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white)),
                      const Icon(Icons.arrow_drop_down, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: _addMonth,
              child: Container(
                width: 50,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.horizontal(right: Radius.circular(16)),
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.arrow_right,
                    size: 24, color: Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _financialHealthView() {
    return StreamBuilder<Map<String, dynamic>>(
      stream: _combinedStreamSubject.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const Text("Error loading data");
        }

        final data = snapshot.data!;
        final savingsRate = data['savingsRate'];
        //final incomeExpenseRatio = data['incomeExpenseRatio'];
        final debtToIncomeRatio = data['debtToIncomeRatio'];

        return SingleChildScrollView(
          // Add scrollable behavior here
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SavingsRateCard(savingsRate: savingsRate),
                const SizedBox(height: 10),
                //IncomeExpenseRatioCard(incomeExpenseRatio: incomeExpenseRatio),
                DebtToIncomeRatioCard(debtToIncomeRatio: debtToIncomeRatio,),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _distributionView() {
    return StreamBuilder<Map<String, dynamic>>(
      stream: _combinedStreamSubject.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const Text("Error loading data");
        }

        // String displayDate = _dateAndTimeFormatterService
        // .returnCurrentMonthNameAndYear(_selectedDate);

        // return CustomScrollView(
        //   slivers: [
        //     SliverToBoxAdapter(
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,  // Align content if needed
        //         children: [
        //           // Wrapping CategoryPieChart in a Column
        //           Padding(
        //             padding: const EdgeInsets.all(8.0),
        //             child: CategoryPieChart(selectedDate: selectedDate),
        //           ),
        //           const SizedBox(height: 20),
        //           // Add more widgets here if necessary
        //           Text("More content below the pie chart"),
        //         ],
        //       ),
        //     ),
        //   ],
        // );
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [CategoryPieChart(selectedDate: _selectedDate)],
            ),
            ),
        );
      },
    );
  }

  Widget _balanceEvaluationView() {
    return StreamBuilder(
      stream: _combinedStreamSubject.stream, 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const Center(child: Text("Error loading data"));
        }

        final data = snapshot.data!;
        final dailyTotalBalance = (data['dailyTotalBalance'] as Map<DateTime, double>?) ?? <DateTime, double>{};
        String displayDate = _dateAndTimeFormatterService.returnCurrentMonthNameAndYear(_selectedDate);
        
        // Optionally, you can also ensure all values in the map are not null
        // final dailyTotalBalanceWithNonNullValues = dailyTotalBalance.map(
        //   (key, value) => MapEntry(key, value ?? 0.0),
        // );

        developer.log('Daily Total Balance: $dailyTotalBalance');

        return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Daily Total Balance \nfor $displayDate',
                textAlign: TextAlign.center, // Center-align the text
                style: const TextStyle(fontSize: 18), // Adjust the font size as needed
              ),
              const SizedBox(height: 15,),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4, // Set a fixed height
                child: DailyTotalBalanceChart(
                  dailyTotalBalance: dailyTotalBalance,
                  selectedDate: _selectedDate,
                ),
              ),
            ],
          ),
        ),
      );
      });
  }

Widget _cashFlowView() {
  return StreamBuilder<Map<String, dynamic>>(
    stream: _combinedStreamSubject.stream,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      if (snapshot.hasError || !snapshot.hasData) {
        return const Center(child: Text("Error loading data"));
      }

      final data = snapshot.data!;
      // Safely handle the case where the data might be null
      final dailyIncome = (data['totalDailyIncome'] as Map<DateTime, double>?) ?? <DateTime, double>{};
      final dailyExpense = (data['totalDailyExpense'] as Map<DateTime, double>?) ?? <DateTime, double>{};
      String displayDate = _dateAndTimeFormatterService.returnCurrentMonthNameAndYear(_selectedDate);

      // Optionally, you can also ensure all values in the map are not null
      // final dailyIncomeWithNonNullValues = dailyIncome.map(
      //   (key, value) => MapEntry(key, value ?? 0.0),
      // );

      // final dailyExpenseWithNonNullValues = dailyExpense.map(
      //   (key, value) => MapEntry(key, value ?? 0.0),
      // );
      _transactionsWithCategoriesAndDebtsService.getDailyExpenseForMonth(_selectedDate).listen((dailyExpense) {
        // Log the entire map when it's updated
        print('Stream emitted: $dailyExpense');
      });

      developer.log('Daily Income: $dailyIncome');
      developer.log('Daily Expense: $dailyExpense');

      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Daily Income and Expenses \nfor $displayDate',
                textAlign: TextAlign.center, // Center-align the text
                style: const TextStyle(fontSize: 18), // Adjust the font size as needed
              ),
              const SizedBox(height: 15,),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4, // Set a fixed height
                child: DailyIncomeExpenseChart(
                  dailyIncome: dailyIncome,
                  dailyExpense: dailyExpense,
                  selectedDate: _selectedDate,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

}
