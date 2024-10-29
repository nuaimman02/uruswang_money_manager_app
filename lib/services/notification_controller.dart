import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:uruswang_money_manager_app/pages/debts/debts_detail_page.dart';
import 'package:uruswang_money_manager_app/services/navigation_service.dart';

class NotificationController {
  final GetIt getIt = GetIt.instance;
  late NavigationService navigationService;

  NotificationController() {
    navigationService = getIt.get<NavigationService>();
  }

  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future <void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future <void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future <void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future <void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    // Your code goes here
    final controller = NotificationController();

    if (receivedAction.payload != null) {
      final targetPage = receivedAction.payload!['targetPage'];
      final debtId = receivedAction.payload!['debtId'];

      if (targetPage == 'debtDetail' && debtId != null) {
        controller.navigationService.push(
          MaterialPageRoute(
            builder: (context) => DebtsDetailPage(debtId: int.parse(debtId)), // Pass debtId here
          ),
        );
      }
    }
  }
}