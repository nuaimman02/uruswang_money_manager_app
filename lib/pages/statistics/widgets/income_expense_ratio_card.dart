import 'package:flutter/material.dart';

class IncomeExpenseRatioCard extends StatelessWidget {
  final double? incomeExpenseRatio; // Nullable to represent no data scenario

  const IncomeExpenseRatioCard({super.key, this.incomeExpenseRatio});

  @override
  Widget build(BuildContext context) {
    String status;
    Color progressBarColor;
    Color textColor;
    String description;
    String ratioText;

    // Handle the different conditions
    if (incomeExpenseRatio == null) {
      // Case for insufficient data
      status = "Insufficient Data";
      progressBarColor = Colors.grey;
      textColor = Colors.grey;
      description = "No expense transactions available to calculate the income-to-expense ratio.";
      ratioText = "NA";
    } else if (incomeExpenseRatio! >= 0.75) {
      // Case for excellent ratio (75% or above)
      status = "Excellent";
      progressBarColor = Colors.green;
      textColor = Colors.green;
      description = "You have an excellent income-to-expense ratio this month!";
      ratioText = "${(incomeExpenseRatio! * 100).toStringAsFixed(1)}%";
    } else if (incomeExpenseRatio! >= 0.5 && incomeExpenseRatio! < 0.75) {
      // Case for good ratio (50% to 75%)
      status = "Good";
      progressBarColor = Colors.amber;
      textColor = Colors.amber[700]!;
      description = "Your income-to-expense ratio is good, but there's room for improvement.";
      ratioText = "${(incomeExpenseRatio! * 100).toStringAsFixed(1)}%";
    } else {
      // Case for poor ratio (below 50%)
      status = "Poor";
      progressBarColor = Colors.red;
      textColor = Colors.red;
      description = "Your income is lower than your expenses. Consider reviewing your spending.";
      ratioText = "${(incomeExpenseRatio! * 100).toStringAsFixed(1)}%";
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),side: const BorderSide(width: 1)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              "Income-to-Expense Ratio",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Linear Progress Bar
            LinearProgressIndicator(
              value: incomeExpenseRatio != null
                  ? (incomeExpenseRatio! > 1.0 ? 1.0 : incomeExpenseRatio!) // Limit the progress bar to 100%
                  : 0, // Progress based on the ratio
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(progressBarColor),
            ),
            const SizedBox(height: 10),

            // Ratio Value
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ratioText,
                  style: TextStyle(fontSize: 16, color: textColor),
                ),
                Text(
                  status,
                  style: TextStyle(fontSize: 16, color: textColor),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Description Text
            Text(
              description,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}
