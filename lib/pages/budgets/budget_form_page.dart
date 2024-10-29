import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_month_picker/flutter_custom_month_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' as drift;
import 'package:uruswang_money_manager_app/models/category.dart';
import 'package:uruswang_money_manager_app/models/transaction.dart';
import 'package:uruswang_money_manager_app/services/database_service/app_database.dart';
import 'package:uruswang_money_manager_app/services/model_service/budget_service.dart';
import 'package:uruswang_money_manager_app/services/model_service/category_service.dart';
import 'package:uruswang_money_manager_app/services/navigation_service.dart';

class BudgetFormPage extends StatefulWidget {
  final Budget? budgetItem;
  
  const BudgetFormPage({super.key, this.budgetItem});

  @override
  State<BudgetFormPage> createState() => _BudgetFormPageState();
}

class _BudgetFormPageState extends State<BudgetFormPage> {
  final GetIt _getIt = GetIt.instance;
  late NavigationService _navigationService;
  late CategoryService _categoryService;
  late BudgetService _budgetService;
  
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _budgetBudgetedValueController = TextEditingController();
  final TextEditingController _selectedMonthAndYearController = TextEditingController();

  List<Category> _filteredExpenseCategories = [];
  final TransactionType _selectedTransactionType = TransactionType.expense;
  String? _originalBudgetName;
  String? _selectedBudgetName; // Store the selected category name
  DateTime _selectedDate = DateTime.now();
  
  bool isUpdate = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _navigationService = _getIt.get<NavigationService>();
    _categoryService = _getIt.get<CategoryService>();
    _budgetService = _getIt.get<BudgetService>();

    if(widget.budgetItem != null) {
      isUpdate = true;
      _selectedBudgetName = widget.budgetItem?.budgetName;
      _originalBudgetName = _selectedBudgetName; // Store original category
      _budgetBudgetedValueController.text = widget.budgetItem?.budgetedValue.toStringAsFixed(2) ?? '0.00' ;
      _selectedMonthAndYearController.text = widget.budgetItem != null
          ? DateFormat('MMMM yyyy').format(widget.budgetItem!.startDate)
          : '';    
    } else {
      DateTime now = DateTime.now();
      _selectedMonthAndYearController.text = DateFormat('MMMM yyyy').format(now);  // Set today's date
      _budgetBudgetedValueController.text = '0.00';    
    }

    // Fetch and filter categories based on the selected transaction type
    _watchAndFilterCategories(_selectedTransactionType);
  }

  // Watch categories from the database and filter by transaction type
  // All names converted from selectedCategoryName to selectedBudgetName
  void _watchAndFilterCategories(TransactionType transactionType) {
    _categoryService.watchAllCategories().listen((categories) {
      setState(() {
        // Filter categories by type (income/expense)
        _filteredExpenseCategories = categories.where((category) {
          if (transactionType == TransactionType.income) {
            return category.categoryType == CategoryType.income && category.isProtected == false;
          } else {
            return category.categoryType == CategoryType.expense && category.isProtected == false;
          }
        }).toList();

        // If switching back to the original type, restore the original category
        if (_selectedBudgetName == null && _originalBudgetName != null) {
          // Check if the original category matches the current type
          bool isOriginalCategoryValid = _filteredExpenseCategories.any(
            (category) => category.categoryName == _originalBudgetName,
          );

          if (isOriginalCategoryValid) {
            _selectedBudgetName = _originalBudgetName; // Restore the original category
          }
        } else {
          // If the selected category doesn't exist in the filtered categories, reset it
          if (!_filteredExpenseCategories.any((category) => category.categoryName == _selectedBudgetName)) {
            _selectedBudgetName = null;
          }
        }
      });
    });
  }

  void _saveBudget() async {
    if (_formKey.currentState!.validate()) {
      String? budgetName = _selectedBudgetName!;
      double budgetedValue = double.parse(_budgetBudgetedValueController.text);
      
      // Parse the month and year from _selectedMonthAndYearController
      DateTime parsedDate = DateFormat('MMMM yyyy').parse(_selectedMonthAndYearController.text);
      
      // Set startDate as the first day of the selected month at midnight
      DateTime startDate = DateTime(parsedDate.year, parsedDate.month, 1);
      DateTime endDate = parsedDate.month == 12 ? DateTime(parsedDate.year + 1, 1, 1) : DateTime(parsedDate.year, parsedDate.month + 1, 1);

      int? categoryId = await _categoryService.getCategoryId(budgetName);

      // Check for existing budgets in the same month
      _budgetService.watchAllBudgetsForCurrentMonth(startDate).first.then((budgets) {
        final isDuplicate = budgets.any((budget) => budget.budgetName == budgetName && budget.budgetId != widget.budgetItem?.budgetId);

        if (isDuplicate) {
          // Show dialog if a duplicate budget name for the month exists
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Duplicate Budget"),
                content: Text("A budget named $budgetName already exists for ${DateFormat('MMMM yyyy').format(startDate)}."),
                actions: [
                  TextButton(
                    child: const Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else {
          // Proceed to save or update if no duplicates
          if (isUpdate == false) {
            final newBudgetCompanion = BudgetsCompanion(
              budgetName: drift.Value(budgetName),
              budgetedValue: drift.Value(budgetedValue),
              dateCreated: drift.Value(DateTime.now()),
              dateUpdated: drift.Value(DateTime.now()),
              startDate: drift.Value(startDate),
              endDate: drift.Value(endDate),
              categoryId: drift.Value(categoryId)
            );

            _budgetService.insertBudget(newBudgetCompanion);
          } else {
            final toUpdateBudgetCompanion = BudgetsCompanion(
              budgetName: drift.Value(budgetName),
              budgetedValue: drift.Value(budgetedValue),
              dateUpdated: drift.Value(DateTime.now()),
              startDate: drift.Value(startDate),
              endDate: drift.Value(endDate),
              categoryId: drift.Value(categoryId)
            );

            _budgetService.updateBudget(widget.budgetItem!.budgetId, toUpdateBudgetCompanion);
          }

          if(isUpdate == false) {
            _navigationService.goBackWithResult(result: 'inserted');
          } else {
            _navigationService.goBackWithResult(result: 'updated');
          }
        }
      });
    }
  }

    void _formatCurrencyInput(String value) {
    // Remove non-digit characters
    String cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');

    // If empty, set to "0"
    if (cleaned.isEmpty) {
      cleaned = '000';
    } else if (cleaned.length == 1) {
      // If the user has entered only 1 number, pad it with leading zeros
      cleaned = '00$cleaned';
    } else if (cleaned.length == 2) {
      // If the user has entered only 2 numbers, pad with one leading zero
      cleaned = '0$cleaned';
    }

    // Convert the cleaned number to a double and divide by 100 to get the decimal value
    double valueAsDouble = double.parse(cleaned) / 100;

    // Format the double as currency
    String formatted = NumberFormat('0.00').format(valueAsDouble);

    // Set the formatted value back to the controller
    _budgetBudgetedValueController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.fromPosition(
        TextPosition(offset: formatted.length), // Keep the cursor at the end
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _buildUI(),
      floatingActionButton: FloatingActionButton.large(
        child: const Icon(Icons.save),
        onPressed: () {
          _saveBudget();
        }),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(isUpdate ? 'Update Budget' : 'New Budget'),
      backgroundColor: Colors.lightGreen[100],
    );
  }

  Widget _buildUI() {
    return SafeArea(child: 
    Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _budgetNameDropdown(),
            const SizedBox(height: 20,),
            _budgetMonthAndYearTextFormField(),
            const SizedBox(height: 20,),
            _budgetedValueTextFormField(),
          ],
        )),
    ));
  }

  Widget _budgetNameDropdown() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(border: OutlineInputBorder(), label: Text('Budget Name')),
      value: _selectedBudgetName,
      items: _filteredExpenseCategories.map((category) {
        return DropdownMenuItem<String>(
          value: category.categoryName,
          child: Text(category.categoryName),
        );
      }).toList(), 
      onChanged: (newValue) {
            setState(() {
              _selectedBudgetName = newValue;
            });
          },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a category';
        }
        return null;
      },
    );
  }

  Widget _budgetMonthAndYearTextFormField() {
    return TextFormField(
      controller: _selectedMonthAndYearController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Budget Month and Year',
      ),
      readOnly: true,
      onTap: () {
         showMonthPicker(
          context,
          onSelected: (month, year) {
            setState(() {
              // Create a DateTime from the selected month and year
              _selectedDate = DateTime(year, month);
              
              // Format the selected date and update the text controller
              _selectedMonthAndYearController.text = DateFormat('MMMM yyyy').format(_selectedDate);
            });
          },
          initialSelectedMonth: _selectedDate.month,
          initialSelectedYear: _selectedDate.year,
          firstYear: 2020,
          lastYear: 2030,
        );
      },
    );
  }

  Widget _budgetedValueTextFormField() {
    return TextFormField(
      controller: _budgetBudgetedValueController,
      decoration: const InputDecoration(border: OutlineInputBorder(), label: Text('Budgeted Amount')),
      validator: (value) {
        if(value == null || value.isEmpty) {
          return 'Please enter an amount';
        }
        if(value == '0.00') {
          return 'Please enter an amount';
        }
        return null;
      }, 
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],  // Allow only numbers with up to 2 decimal places,
      onChanged: _formatCurrencyInput, // Call the format function on input change
    );
  }
}