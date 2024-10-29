import 'package:flutter/material.dart';

class DebtToIncomeRatioCard extends StatelessWidget {
  final double? debtToIncomeRatio; // Nullable to represent no data scenario

  const DebtToIncomeRatioCard({super.key, this.debtToIncomeRatio});

  @override
  Widget build(BuildContext context) {
    String status;
    Color progressBarColor;
    Color textColor;
    String description;
    String ratioText;

    // Handle the different conditions
    if (debtToIncomeRatio == null) {
      // Case for insufficient data
      status = "Insufficient Data";
      progressBarColor = Colors.grey;
      textColor = Colors.grey;
      description = "No debt or income data available to calculate the ratio.";
      ratioText = "NA";
    } else if (debtToIncomeRatio! <= 0.1) {
      // Case for excellent ratio (10% or below)
      status = "Excellent";
      progressBarColor = Colors.green;
      textColor = Colors.green;
      description = "You have an excellent debt-to-income ratio this month!";
      ratioText = "${(debtToIncomeRatio! * 100).toStringAsFixed(1)}%";
    } else if (debtToIncomeRatio! > 0.1 && debtToIncomeRatio! <= 0.3) {
      // Case for good ratio (10% to 30%)
      status = "Good";
      progressBarColor = Colors.amber;
      textColor = Colors.amber[700]!;
      description = "Your debt-to-income ratio is good, but there's room for improvement.";
      ratioText = "${(debtToIncomeRatio! * 100).toStringAsFixed(1)}%";
    } else if (debtToIncomeRatio! > 0.3 && debtToIncomeRatio! <= 0.5) {
      // Case for fair ratio (30% to 50%)
      status = "Fair";
      progressBarColor = Colors.orange;
      textColor = Colors.orange[700]!;
      description = "Your debt is getting high compared to your income.";
      ratioText = "${(debtToIncomeRatio! * 100).toStringAsFixed(1)}%";
    } else {
      // Case for poor ratio (above 50%)
      status = "Poor";
      progressBarColor = Colors.red;
      textColor = Colors.red;
      description = "Your debt is high relative to your income. Consider reducing debt.";
      ratioText = "${(debtToIncomeRatio! * 100).toStringAsFixed(1)}%";
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(width: 1)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              "Debt-to-Income Ratio",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Linear Progress Bar
            LinearProgressIndicator(
              value: debtToIncomeRatio != null
                  ? (debtToIncomeRatio! > 1.0 ? 1.0 : debtToIncomeRatio!) // Limit the progress bar to 100%
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
