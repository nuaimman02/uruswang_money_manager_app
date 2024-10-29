import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:uruswang_money_manager_app/services/model_service/transactions_with_categories_and_debts_service.dart';
import 'package:uruswang_money_manager_app/models/category.dart';

class CategoryPieChart extends StatefulWidget {
  final DateTime selectedDate;

  const CategoryPieChart({super.key, required this.selectedDate});

  @override
  State<CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends State<CategoryPieChart> {
  final GetIt _getIt = GetIt.instance;
  late TransactionsWithCategoriesAndDebtsService _transactionsWithCategoriesAndDebtsService;

  CategoryType _selectedCategoryType = CategoryType.expense; // Default to expense
  Map<String, double> _categoryData = {}; // For storing category data

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _transactionsWithCategoriesAndDebtsService = _getIt.get<TransactionsWithCategoriesAndDebtsService>();
    _loadCategoryData();
  }

  void _loadCategoryData() {
    _transactionsWithCategoriesAndDebtsService
        .getTransactionsByCategoryForMonth(widget.selectedDate, _selectedCategoryType)
        .listen((categoryData) {
      setState(() {
        _categoryData = categoryData;
      });
    });
  }

  @override
  void didUpdateWidget(covariant CategoryPieChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload data if the selected date changes
    if (widget.selectedDate != oldWidget.selectedDate) {
      _loadCategoryData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ToggleButtons to switch between income and expense
        ToggleButtons(
          isSelected: [
            _selectedCategoryType == CategoryType.expense,
            _selectedCategoryType == CategoryType.income,
          ],
          onPressed: (int newIndex) {
            setState(() {
              _selectedCategoryType = newIndex == 0 ? CategoryType.expense : CategoryType.income;
              _loadCategoryData(); // Load new data based on selection
            });
          },
          borderRadius: BorderRadius.circular(8), // Optional: add some corner radius
          borderColor: Colors.grey, // Optional: define border color
          selectedBorderColor: Colors.blue, // Border color for selected button
          selectedColor: Colors.white, // Text color for selected button
          fillColor: Colors.blue, // Background color for selected button
          color: Colors.black,
          children: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('Expense'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('Income'),
            ),
          ], // Text color for unselected button
        ),

        const SizedBox(height: 20),

        // Pie Chart
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.4, // Set a fixed height
          child: Stack(
            alignment: Alignment.center, // Align text to center
            children: [
              PieChart(
                PieChartData(
                  sections: _getSections(),
                  sectionsSpace: 4,
                  centerSpaceRadius: 40,
                ),
              ),
              if (_categoryData.isEmpty)
                const Text(
                  'No Data', // Text to display when there's no data
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // List of categories with percentage and RM value
        _buildCategoryList(),
      ],
    );
  }

  List<PieChartSectionData> _getSections() {
    if (_categoryData.isEmpty) {
      return [
        PieChartSectionData(
          title: '', // Keep the title empty since "No Data" will be displayed at the center
          value: 1,
          color: Colors.grey,
        ),
      ];
    }

    List<Color> spectrumColors = _generateSpectrumColors(_categoryData.length);
    int colorIndex = 0;

    return _categoryData.entries.map((entry) {
      final percentage = (entry.value / _categoryData.values.reduce((a, b) => a + b)) * 100;
      final sectionColor = spectrumColors[colorIndex++]; // Assign color once and increment index

      return PieChartSectionData(
        title: '', // No title inside the chart
        value: entry.value,
        color: sectionColor,
        radius: 60,
        titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        badgeWidget: _buildArm(entry.key, entry.value, percentage, sectionColor), // Pass the color to _buildArm
        badgePositionPercentageOffset: 1.5, // Position the arms further outside
      );
    }).toList();
  }

  Widget _buildArm(String categoryName, double value, double percentage, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label and percentage outside the pie chart
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              categoryName,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 4),
        // Arm (line)
        Container(
          height: 1,
          width: 40, // Adjust line length
          color: color, // Use the section color for the arm
        ),
        const SizedBox(height: 4),
        // Amount (RM value)
        Text(
          '${(percentage).toStringAsFixed(1)}%',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  List<Color> _generateSpectrumColors(int count) {
    List<Color> colors = [];
    for (int i = 0; i < count; i++) {
      double hue = (i * (360 / count)) % 360; // Generate hue evenly distributed in the spectrum
      colors.add(HSVColor.fromAHSV(1, hue, 0.7, 0.9).toColor());
    }
    return colors;
  }

  Widget _buildCategoryList() {
    return Column(
      children: _categoryData.entries.map((entry) {
        final percentage = (entry.value / _categoryData.values.reduce((a, b) => a + b)) * 100;
        return ListTile(
          leading: Container(
            width: 50,  // Adjust width to fit "100%" text
            height: 40, // Adjust height to make it proportionate
            decoration: BoxDecoration(
              color: _generateSpectrumColors(_categoryData.length)[_categoryData.keys.toList().indexOf(entry.key)],
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8),  // Adjust as needed for rounded corners
            ),
            alignment: Alignment.center,
            child: Text(
              '${(percentage).toStringAsFixed(0)}%',
              //style: TextStyle(fontSize: 16), // Increase font size if needed
            ),
          ),
          title: Text(entry.key),
          trailing: Text('RM ${entry.value.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
        );
      }).toList(),
    );
  }
}
