import 'package:intl/intl.dart';

class DateAndTimeFormatterService {
 
  DateAndTimeFormatterService();

    // Method to format date as dd/MM/yyyy
  String formatDateDayTransactionDetailsDisplay(DateTime date) {
    final DateFormat dateFormatter = DateFormat('EEEE, dd MMMM yyyy');
    return dateFormatter.format(date);
  }

  // Method to format date as dd/MM/yyyy
  String formatDateTransactionDetailsDisplay(DateTime date) {
    final DateFormat dateFormatter = DateFormat('dd/MM/yyyy');
    return dateFormatter.format(date);
  }

  // Method to format date as dd/MM/yyyy, day
  String formatDateDayTransactionListDisplay(DateTime date) {
    final DateFormat dateFormatter = DateFormat('dd MMM., yyyy EEEE');
    return dateFormatter.format(date);
  }

  // Method to format time as HH:mm
  String formatTimeTo24H(DateTime time) {
    final DateFormat timeFormatter = DateFormat('HH:mm');  // 24-hour format
    return timeFormatter.format(time);
  }

    // Method to format time as hh:mm a
  String formatTimeTo12H(DateTime time) {
    final DateFormat timeFormatter = DateFormat('hh:mm a');  // 24-hour format with AM/PM
    return timeFormatter.format(time);
  }

  // Method to format date and time together if needed
  String formatDateTimeTo24H(DateTime dateTime) {
    final DateFormat dateTimeFormatter = DateFormat('dd/MM/yyyy HH:mm');
    return dateTimeFormatter.format(dateTime);
  }

    // Method to format date and time together if needed
  String formatDateTimeTo12H(DateTime dateTime) {
    final DateFormat dateTimeFormatter = DateFormat('dd/MM/yyyy hh:mm a');
    return dateTimeFormatter.format(dateTime);
  }

  String returnCurrentMonthNameAndYear(DateTime dateTime) {
    final DateFormat dateTimeFormatter = DateFormat('MMMM yyyy');
    return dateTimeFormatter.format(dateTime);
  }
  
}