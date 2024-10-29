import 'package:flutter/material.dart';

class UruswangBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const UruswangBottomNavigationBar({super.key, 
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap, // Only notify the parent to update the current page index
      destinations: const [
        NavigationDestination(icon: Icon(Icons.list), label: 'Trans.'),
        NavigationDestination(icon: Icon(Icons.money), label: 'Debts'),
        NavigationDestination(icon: Icon(Icons.wallet), label: 'Budgets'),
        NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Statistics'),
        NavigationDestination(icon: Icon(Icons.more_horiz), label: 'More'),
      ],
      backgroundColor: Theme.of(context).navigationBarTheme.backgroundColor,
      indicatorColor: Colors.lightGreen, // To indicate selected item
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    );
  }
}
