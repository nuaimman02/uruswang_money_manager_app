import 'package:flutter/material.dart';

class SavingsRateCard extends StatelessWidget {
  final double? savingsRate; // Nullable to represent no data scenario

  const SavingsRateCard({super.key, this.savingsRate});

  @override
  Widget build(BuildContext context) {
    String status;
    Color progressBarColor;
    Color textColor;
    String description;
    String percentageText;

    // Handle the different conditions
    if (savingsRate == null) {
      // Case for insufficient data
      status = "Insufficient Data";
      progressBarColor = Colors.grey;
      textColor = Colors.grey;
      description = "No income transactions available to calculate the savings rate.";
      percentageText = "NA";
    } else if (savingsRate! >= 20) {
      // Case for good savings rate
      status = "Good";
      progressBarColor = Colors.green;
      textColor = Colors.green;
      description = "You have a strong savings rate this month!";
      percentageText = "${savingsRate!.toStringAsFixed(1)}%";
    } else if (savingsRate! >= 10 && savingsRate! < 20) {
      // Case for normal savings rate
      status = "Normal";
      progressBarColor = Colors.amber;
      textColor = Colors.amber[700]!;
      description = "Your savings rate is average this month. You might want to save more.";
      percentageText = "${savingsRate!.toStringAsFixed(1)}%";
    } else {
      // Case for bad savings rate (below 10%)
      status = "Bad";
      progressBarColor = Colors.red;
      textColor = Colors.red;
      description = "Your savings rate is low this month. Consider reviewing your expenses.";
      percentageText = "${savingsRate!.toStringAsFixed(1)}%";
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
              "Savings Rate",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
    
            // Linear Progress Bar
            LinearProgressIndicator(
              value: savingsRate != null ? savingsRate! / 100 : 0, // Progress based on percentage
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(progressBarColor),
            ),
            const SizedBox(height: 10),
    
            // Percentage Value
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  percentageText,
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
