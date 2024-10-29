import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DailyIncomeExpenseChart extends StatelessWidget {
  final Map<DateTime, double> dailyIncome;
  final Map<DateTime, double> dailyExpense;
  final DateTime selectedDate;

  const DailyIncomeExpenseChart({
    super.key,
    required this.dailyIncome,
    required this.dailyExpense,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    // Get the correct number of days for the selected month
    final int daysInMonth = DateTime(selectedDate.year, selectedDate.month + 1, 0).day;

    // Initialize maps with all days filled with 0.0 if no transactions exist
    final Map<DateTime, double> filledIncome = {};
    final Map<DateTime, double> filledExpense = {};

    for (int i = 1; i <= daysInMonth; i++) {
      DateTime day = DateTime(selectedDate.year, selectedDate.month, i);
      filledIncome[day] = dailyIncome[day] ?? 0.0;
      filledExpense[day] = dailyExpense[day] ?? 0.0;
    }

    // Combine both income and expense values after filling missing days
    final allValues = [...filledIncome.values, ...filledExpense.values];

    // Calculate min and max Y values considering 0.0 for non-transaction days
    final minYValue = allValues.isNotEmpty ? allValues.reduce((a, b) => a < b ? a : b) : 0.0;
    final maxYValue = allValues.isNotEmpty ? allValues.reduce((a, b) => a > b ? a : b) : 0.0;

    // Determine if the max value has 3 digits
    bool hasFourDigits = maxYValue.abs() >= 1000;

    // Ensure graphMinY starts from 0.0
    double graphMinY = minYValue < 0 ? minYValue : 0.0;

    return LineChart(
      LineChartData(
        minY: graphMinY,
        maxY: maxYValue > 0 ? maxYValue : 10.0, // Ensure Y-axis shows at least up to 10 even if no values exist
        gridData: const FlGridData(
          drawHorizontalLine: true, // Enable horizontal grid lines
          drawVerticalLine: false,   // Disable vertical grid lines
        ),
        titlesData: FlTitlesData(
          bottomTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: false, // Hide x-axis titles
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false), // Hide top titles
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true, // Keep the y-axis titles
              reservedSize: hasFourDigits ? 50 : 40, // Set reserved size based on max Y value,
              getTitlesWidget: (value, meta) {
                // Avoid duplication by filtering out values close to each other
                if (value % 1 == 0) {  // Only show integer labels
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(value.toStringAsFixed(0)),
                  );
                }
                return const SizedBox.shrink(); // Hide labels for non-integers
              },
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false), // Hide right titles
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: const Border(
            left: BorderSide(width: 1, color: Colors.black), // Keep left border
            bottom: BorderSide.none, // Remove the bottom border
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: _generateSpots(filledIncome),
            isCurved: true, // Set to true to have smooth curves
            preventCurveOverShooting: true, // Prevents the curves from dipping below 0
            color: Colors.green,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false), // Disable dots if unnecessary
            //belowBarData: BarAreaData(show: false), // Disable the shadow/area below the line
            belowBarData: BarAreaData(
              show: true, // Enable the shadow area below the line
              color: Colors.green.withOpacity(0.2), // Shadow color with some transparency
            ),
          ),
          LineChartBarData(
            spots: _generateSpots(filledExpense),
            isCurved: true, // Set to true to have smooth curves
            preventCurveOverShooting: true, // Prevents the curves from dipping below 0
            color: Colors.red,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false), // Disable dots if unnecessary
            //belowBarData: BarAreaData(show: false), // Disable the shadow/area below the line
            belowBarData: BarAreaData(
              show: true, // Enable the shadow area below the line
              color: Colors.red.withOpacity(0.2), // Shadow color with some transparency
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (LineBarSpot spot) => Colors.blueAccent,
            tooltipPadding: const EdgeInsets.all(8.0),
            showOnTopOfTheChartBoxArea: true, // Ensure tooltip appears on top
            fitInsideVertically: true, // Ensure tooltip is inside the chart vertically
            fitInsideHorizontally: true, // Ensure tooltip is inside the chart horizontally
            getTooltipItems: (touchedSpots) {
              if (touchedSpots.isNotEmpty) {
                // Retrieve the x-value as the touched day of the month
                final touchedDay = touchedSpots.first.x.toInt();

                // Use the selectedDate month and year to ensure correct tooltip
                final touchedDate = DateTime(selectedDate.year, selectedDate.month, touchedDay);

                // Format the date
                final formattedDate = DateFormat('dd-MM-yy').format(touchedDate);

                // Find income and expense for the touched day, or 0 if none exists
                final income = filledIncome[touchedDate] ?? 0;
                final expense = filledExpense[touchedDate] ?? 0;

                // Generate tooltip items for all touched spots
                return touchedSpots.map((touchedSpot) {
                  // Show the combined tooltip on the first spot
                  if (touchedSpot == touchedSpots.first) {
                    return LineTooltipItem(
                      'Date: $formattedDate\nIncome: RM ${income.toStringAsFixed(2)}\nExpense: RM ${expense.toStringAsFixed(2)}',
                      const TextStyle(color: Colors.white),
                    );
                  } else {
                    // Return null for other spots to avoid duplicate tooltips
                    return null;
                  }
                }).toList();
              }
              return []; // No tooltip when no spot is touched
            },
          ),
          handleBuiltInTouches: true,
          getTouchedSpotIndicator: (barData, spotIndexes) {
            return spotIndexes.map((index) {
              return const TouchedSpotIndicatorData(
                FlLine(color: Colors.blue, strokeWidth: 2), // Vertical line on touch
                FlDotData(show: true), // Show dot on touch
              );
            }).toList();
          },
        ),
      ),
    );
  }

  // Generate spots for each day, setting values to 0 for days without transactions
  List<FlSpot> _generateSpots(Map<DateTime, double> dailyData) {
    // Use the selectedDate to determine the correct year and month
    final year = selectedDate.year;
    final month = selectedDate.month;

    // Calculate the number of days in the selected month
    final daysInMonth = DateTime(year, month + 1, 0).day;

    final spots = <FlSpot>[];
    for (var day = 1; day <= daysInMonth; day++) {
      final date = DateTime(year, month, day);
      final dayValue = dailyData[date] ?? 0.0;

      spots.add(FlSpot(day.toDouble(), dayValue.toDouble()));
    }

    return spots;
  }
}
