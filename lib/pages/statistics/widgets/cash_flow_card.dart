import 'package:flutter/material.dart';

class CashFlowCard extends StatelessWidget {
  final double totalBalance;
  final double income;
  final double expense;

  const CashFlowCard({super.key, 
    required this.totalBalance,
    required this.income,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.black)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              "Cash Flow",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Total Balance
            Text(
              "Total Balance",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[700]),
            ),
            const SizedBox(height: 5),
            Text(
              "RM ${totalBalance.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: totalBalance >= 0 ? Colors.green : Colors.red),
            ),
            const SizedBox(height: 20),

            // Income Section
            Row(
              children: [
                const Icon(Icons.download, color: Colors.green, size: 24),
                const SizedBox(width: 10),
                Text(
                  "Income",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[700]),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: income > 0 ? income / (income + expense) : 0,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "RM ${income.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 16, color: Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Expense Section
            Row(
              children: [
                const Icon(Icons.upload, color: Colors.red, size: 24),
                const SizedBox(width: 10),
                Text(
                  "Expense",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[700]),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: expense > 0 ? expense / (income + expense) : 0,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "RM ${expense.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
