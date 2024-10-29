import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting

class DailyTotalBalanceChart extends StatelessWidget {
  final Map<DateTime, double> dailyTotalBalance;
  final DateTime selectedDate;

  const DailyTotalBalanceChart({
    super.key,
    required this.dailyTotalBalance,
    required this.selectedDate, // Pass the selected month
  });

  @override
  Widget build(BuildContext context) {
    // Extract the values to determine the min and max Y-axis values
    final allValues = dailyTotalBalance.values.toList();
    final minYValue = allValues.isNotEmpty ? allValues.reduce((a, b) => a < b ? a : b) : 0.0;
    final maxYValue = allValues.isNotEmpty ? allValues.reduce((a, b) => a > b ? a : b) : 0.0;

    // Determine if the max value has 3 digits
    bool hasFourDigits = maxYValue.abs() >= 1000;

    late double graphMinY;
    late double graphMaxY;

    // Adjust to allow negative values to be displayed correctly
    if (minYValue < 0) {
      graphMinY = minYValue;  // Allow negative min values
    } else {
      graphMinY = 0;  // Start from 0 if no negative values
    }

    graphMaxY = maxYValue > 0 ? maxYValue : 10.0;  // Adjust max to highest value

    return LineChart(
      LineChartData(
        minY: graphMinY, // Ensure Y-axis starts from 0 or the minimum value
        maxY: graphMaxY, // Ensure Y-axis shows at least up to 10 even if no values exist
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
              reservedSize: hasFourDigits ? 50 : 40, // Set reserved size based on max Y value
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
            spots: _generateSpots(dailyTotalBalance),
            isCurved: true, // Set to true to make the line curved
            preventCurveOverShooting: true, // Prevent the line from curving below 0
            color: Colors.blue, // Set the line color to blue
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false), // Disable dots on the line
            belowBarData: BarAreaData(
              show: true, // Enable the shadow area below the line
              color: Colors.blue.withOpacity(0.2), // Shadow color with some transparency
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
                final touchedDay = touchedSpots.first.x.toInt();

                // Use the selectedDate to infer the correct month
                final touchedDate = DateTime(selectedDate.year, selectedDate.month, touchedDay);

                // Format the date
                final formattedDate = DateFormat('dd-MM-yy').format(touchedDate);

                // Find the total balance for the touched day
                final balance = dailyTotalBalance[touchedDate] ?? 0;

                // Return tooltip item showing the total balance for the touched day
                return touchedSpots.map((touchedSpot) {
                  if (touchedSpot == touchedSpots.first) {
                    return LineTooltipItem(
                      'Date: $formattedDate\nBalance: RM ${balance.toStringAsFixed(2)}',
                      const TextStyle(color: Colors.white),
                    );
                  } else {
                    return null; // Return null to avoid duplicate tooltips
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

  // Helper function to generate FlSpots for each day
  List<FlSpot> _generateSpots(Map<DateTime, double> dailyData) {
    // Calculate the number of days in the selected month
    final year = selectedDate.year;
    final month = selectedDate.month;
    final daysInMonth = DateTime(year, month + 1, 0).day; // Number of days in the selected month

    final spots = <FlSpot>[];
    for (var day = 1; day <= daysInMonth; day++) {
      final date = DateTime(year, month, day);
      final dayValue = dailyData[date] ?? 0.0;

      spots.add(FlSpot(day.toDouble(), dayValue.toDouble()));
    }

    return spots;
  }
}
