import 'package:flutter/material.dart';
import 'package:uruswang_money_manager_app/pages/budgets/budgets_page.dart';
import 'package:uruswang_money_manager_app/pages/debts/debts_page.dart';
import 'package:uruswang_money_manager_app/pages/dynamicmainpage/bottom_nav_bar_widget.dart';
import 'package:uruswang_money_manager_app/pages/more/more_page.dart';
import 'package:uruswang_money_manager_app/pages/statistics/statistics_page.dart';
import 'package:uruswang_money_manager_app/pages/transactions/transactions_page.dart';

class DynamicMainPage extends StatefulWidget {
  const DynamicMainPage({super.key});

  @override
  State<DynamicMainPage> createState() => _DynamicMainPageState();
}

class _DynamicMainPageState extends State<DynamicMainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const TransactionsPage(),
    const DebtsPage(),
    const BudgetsPage(),
    const StatisticsPage(),
    const MorePage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index; // Update the current page index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: UruswangBottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,),
    );
  }
}
