import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:drift/drift.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:uruswang_money_manager_app/services/database_service/app_database.dart';

class DebtService {
  final GetIt _getIt = GetIt.instance;
  late AppDatabase _appDatabase;

  DebtService() {
    _appDatabase = _getIt.get<AppDatabase>();
  }

  Future<int> updateSettledDate(int debtId, DateTime? settledDate) {
    return (_appDatabase.update(_appDatabase.debts)
      ..where((tbl) => tbl.debtId.equals(debtId)))
      .write(DebtsCompanion(
        settledDate: Value(settledDate),
      ));
  }

  Future<int> insertDebt(DebtsCompanion newDebtCompanion) async {
    return _appDatabase.into(_appDatabase.debts).insert(newDebtCompanion);
  }

  Future<int> updateDebt(int debtId, DebtsCompanion updatedDebtCompanion) async {
    return (_appDatabase.update(_appDatabase.debts)
      ..where((tbl) => tbl.debtId.equals(debtId)))
      .write(updatedDebtCompanion);
  }

  Future<void> deleteDebt(int debtId) async {
    await (_appDatabase.delete(_appDatabase.debts)
      ..where((tbl) => tbl.debtId.equals(debtId))
    ).go();
  }

  // Call this method to schedule a notification
  Future<void> scheduleDebtNotification(int debtId, String debtTransactionName, String peopleName, String categoryName, double value, DateTime scheduledDate) async {
    // Customize the message based on the category
    String notificationMessage = '';
    if (categoryName == 'Lending') {
      notificationMessage = 'You need to request RM${value.toStringAsFixed(2)} from $peopleName for "$debtTransactionName" on today, ${DateFormat('dd/MM/yyyy').format(scheduledDate)}.';
    } else if (categoryName == 'Borrowing') {
      notificationMessage = 'You need to pay RM${value.toStringAsFixed(2)} to $peopleName for "$debtTransactionName" on today, ${DateFormat('dd/MM/yyyy').format(scheduledDate)}.';
    }

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: debtId,  // Assign a unique ID, ideally the debtId or a custom ID
        channelKey: 'scheduled_channel', // Ensure this matches with the channel you set up
        title: 'Debt Settlement Reminder',
        body: notificationMessage,
        notificationLayout: NotificationLayout.Default,
        payload: {
          'targetPage' : 'debtDetail',
          'debtId' : debtId.toString()
        }
      ),
      schedule: NotificationCalendar(
        year: scheduledDate.year,
        month: scheduledDate.month,
        day: scheduledDate.day,
        hour: scheduledDate.hour,  // You can set the time when the notification should appear
        minute: 0,
        second: 0,
        millisecond: 0,
        timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
        preciseAlarm: true, // Ensures the notification triggers exactly at the scheduled time
      ),
    );
  }

  // Method to cancel the existing notification if the expected settlement date is updated
  Future<void> cancelScheduledDebtNotification(int debtId) async {
    await AwesomeNotifications().cancel(debtId);  // Cancel by debt ID
  }

  // Call this method to schedule a notification
  Future<void> triggerDebtNotification(int debtId, String debtTransactionName, String peopleName, String categoryName, double value, DateTime scheduledDate) async {
    // Customize the message based on the category
    String notificationMessage = '';
    if (categoryName == 'Lending') {
      notificationMessage = 'You need to request RM${value.toStringAsFixed(2)} from $peopleName for "$debtTransactionName" on today, ${DateFormat('dd/MM/yyyy').format(scheduledDate)}.';
    } else if (categoryName == 'Borrowing') {
      notificationMessage = 'You need to pay RM${value.toStringAsFixed(2)} to $peopleName for "$debtTransactionName" on today, ${DateFormat('dd/MM/yyyy').format(scheduledDate)}.';
    }

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: debtId,  // Assign a unique ID, ideally the debtId or a custom ID
        channelKey: 'basic_channel', // Ensure this matches with the channel you set up
        title: 'Debt Settlement Reminder',
        body: notificationMessage,
        notificationLayout: NotificationLayout.Default,
        payload: {
          'targetPage' : 'debtDetail',
          'debtId' : debtId.toString()
        }
      ),
    );
  }
}