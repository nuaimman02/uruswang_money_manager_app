import 'package:flutter/material.dart';
import 'package:uruswang_money_manager_app/pages/debts/debts_page.dart';
import 'package:uruswang_money_manager_app/pages/dynamicmainpage/dynamic_main_page.dart';
import 'package:uruswang_money_manager_app/pages/more/more_page.dart';
import 'package:uruswang_money_manager_app/pages/transactions/transaction_form_page.dart';
import 'package:uruswang_money_manager_app/pages/transactions/transactions_page.dart';
import 'package:uruswang_money_manager_app/pages/statistics/statistics_page.dart';


class NavigationService {
  late GlobalKey<NavigatorState> _navigatorKey;

  final Map<String, Widget Function(BuildContext)> _routes = {
    "/dynamic": (context) => const DynamicMainPage(),
    "/transactions": (context) => const TransactionsPage(),
    "/transactions_form": (context) => const TransactionFormPage(),
    "/debts": (context) => const DebtsPage(),
    "/statistics": (context) => const StatisticsPage(),
    "/more": (context) => const MorePage(),
  };

  GlobalKey<NavigatorState>? get navigatorKey {
    return _navigatorKey;
  }

  Map<String, Widget Function(BuildContext)> get routes {
    return _routes;
  }

  NavigationService(){
    _navigatorKey = GlobalKey<NavigatorState>();
  }

  void pushNamed(String routeName){
    _navigatorKey.currentState?.pushNamed(routeName);
  }

  void pushReplacementNamed(String routeName){
    _navigatorKey.currentState?.pushReplacementNamed(routeName);
  }

  void push(MaterialPageRoute route){
    _navigatorKey.currentState?.push(route);
  }

  void goBack(){
    _navigatorKey.currentState?.pop();
  }

  // Modify push method to return the result
  Future<T?>? pushToGetResult<T extends Object?>(MaterialPageRoute<T> route) {
    return _navigatorKey.currentState?.push(route);
  }

  // Generic pop with a result
  void goBackWithResult<T>({T? result}) {
    _navigatorKey.currentState?.pop(result);
  }

}