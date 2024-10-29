import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' as drift;
import 'package:uruswang_money_manager_app/models/category.dart';
import 'package:uruswang_money_manager_app/models/transaction.dart';
import 'package:uruswang_money_manager_app/models/transactions_with_categories_and_debts.dart';
import 'package:uruswang_money_manager_app/services/database_service/app_database.dart';
import 'package:uruswang_money_manager_app/services/model_service/category_service.dart';
import 'package:uruswang_money_manager_app/services/model_service/transaction_service.dart';
import 'package:uruswang_money_manager_app/services/navigation_service.dart';

class TransactionFormPage extends StatefulWidget {
  final TransactionsWithCategoriesAndDebts? transactionWithCategoryAndDebtItem;

  const TransactionFormPage({super.key, this.transactionWithCategoryAndDebtItem});

  @override
  State<TransactionFormPage> createState() => _TransactionFormPageState();
}

class _TransactionFormPageState extends State<TransactionFormPage> {
  final GetIt _getIt = GetIt.instance;
  late NavigationService _navigationService;
  late CategoryService _categoryService;
  late TransactionService _transactionService;

  final _formKey = GlobalKey<FormState>(); 
  final TextEditingController _transactionNameController = TextEditingController();
  final TextEditingController _transactionValueController = TextEditingController();
  final TextEditingController _transactionDateController = TextEditingController();
  final TextEditingController _transactionTimeController = TextEditingController();
  final TextEditingController _transactionDescriptionController = TextEditingController();
 
  bool isUpdate = false;

  TransactionType _selectedTransactionType = TransactionType.expense;
  String? _originalCategoryName;
  String? _selectedCategoryName; // Store the selected category name
  List<Category> _filteredCategories = []; // Categories to display in dropdown

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _navigationService = _getIt.get<NavigationService>();
    _categoryService = _getIt.get<CategoryService>();
    _transactionService = _getIt.get<TransactionService>();

    // If `transactionData` is not null, we are updating, not inserting
    if (widget.transactionWithCategoryAndDebtItem != null) {
      isUpdate = true;
      _transactionNameController.text = widget.transactionWithCategoryAndDebtItem?.transactions.transactionName ?? '';
      _transactionValueController.text = widget.transactionWithCategoryAndDebtItem?.transactions.value.toStringAsFixed(2) ?? '0.00';
      _transactionDateController.text = widget.transactionWithCategoryAndDebtItem != null
          ? DateFormat('dd/MM/yyyy').format(widget.transactionWithCategoryAndDebtItem!.transactions.transactionDate)
          : '';     
      _transactionTimeController.text = widget.transactionWithCategoryAndDebtItem != null
          ? DateFormat('HH:mm').format(widget.transactionWithCategoryAndDebtItem!.transactions.transactionDate)
          : '';      
      _transactionDescriptionController.text = widget.transactionWithCategoryAndDebtItem?.transactions.description ?? '';
      _selectedCategoryName = widget.transactionWithCategoryAndDebtItem?.categories.categoryName;
      _originalCategoryName = _selectedCategoryName; // Store original category
      _selectedTransactionType = widget.transactionWithCategoryAndDebtItem != null
        ? TransactionType.values.byName(widget.transactionWithCategoryAndDebtItem!.transactions.transactionType.name)
        : TransactionType.expense;
    } else {
      // If inserting, set default values for date and time
      DateTime now = DateTime.now();
      _transactionDateController.text = DateFormat('dd/MM/yyyy').format(now);  // Set today's date
      _transactionTimeController.text = DateFormat('HH:mm').format(now); // Set current time
      _transactionValueController.text = '0.00';      
    }
    // Fetch and filter categories based on the selected transaction type
    _watchAndFilterCategories(_selectedTransactionType);
  }

    // Watch categories from the database and filter by transaction type
  void _watchAndFilterCategories(TransactionType transactionType) {
    _categoryService.watchAllCategories().listen((categories) {
      setState(() {
        // Filter categories by type (income/expense)
        _filteredCategories = categories.where((category) {
          if (transactionType == TransactionType.income) {
            return category.categoryType == CategoryType.income && category.isProtected == false && category.deletedAt == null;
          } else {
            return category.categoryType == CategoryType.expense && category.isProtected == false && category.deletedAt == null;
          }
        }).toList();

        // If switching back to the original type, restore the original category
        if (_selectedCategoryName == null && _originalCategoryName != null) {
          // Check if the original category matches the current type
          bool isOriginalCategoryValid = _filteredCategories.any(
            (category) => category.categoryName == _originalCategoryName,
          );

          if (isOriginalCategoryValid) {
            _selectedCategoryName = _originalCategoryName; // Restore the original category
          }
        } else {
          // If the selected category doesn't exist in the filtered categories, reset it
          if (!_filteredCategories.any((category) => category.categoryName == _selectedCategoryName)) {
            _selectedCategoryName = null;
          }
        }
      });
    });
  }

  void _saveTransaction() async {
    if(_formKey.currentState!.validate()) {
      // Extract form data
      String transactionName = _transactionNameController.text;
      double transactionValue = double.parse(_transactionValueController.text);
      DateTime transactionDate = combineDateAndTime(_transactionDateController, _transactionTimeController);
      String? categoryName = _selectedCategoryName;
      TransactionType transactionType = _selectedTransactionType;
      String description = _transactionDescriptionController.text;

      // Fetch categoryId based on categoryName (assuming you have a method like _getCategoryIdByName)
      int? categoryId = await _categoryService.getCategoryId(categoryName!);

      // Create a TransactionsCompanion object for inserting
      final transactionCompanion = TransactionsCompanion(
        transactionName: drift.Value(transactionName),
        value: drift.Value(transactionValue),
        transactionDate: drift.Value(transactionDate),
        transactionType: drift.Value(transactionType),
        categoryId: drift.Value(categoryId),
        description: drift.Value(description),
      );

      if(isUpdate == false) {
        _transactionService.insertTransaction(transactionCompanion);
      } else {
        _transactionService.updateTransaction(widget.transactionWithCategoryAndDebtItem!.transactions.transactionId, transactionCompanion);
      }

      if(isUpdate == false) {
        _navigationService.goBackWithResult(result: 'inserted');
      } else {
        _navigationService.goBackWithResult(result: 'updated');
      }
    }
  }

  DateTime combineDateAndTime(TextEditingController dateController, TextEditingController timeController) {
    // 1. Parse the date from the controller
    DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(dateController.text);

    // 2. Parse the time from the controller
    TimeOfDay parsedTime = TimeOfDay(
      hour: int.parse(timeController.text.split(":")[0]),
      minute: int.parse(timeController.text.split(":")[1]),
    );

    // 3. Combine the date and time
    DateTime combinedDateTime = DateTime(
      parsedDate.year,
      parsedDate.month,
      parsedDate.day,
      parsedTime.hour,
      parsedTime.minute,
    );

    // Return the combined DateTime
    return combinedDateTime;
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
    _transactionValueController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.fromPosition(
        TextPosition(offset: formatted.length), // Keep the cursor at the end
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: isUpdate? _transactionFormUpdateAppBar() : _transactionFormInsertAppBar(),
      body: _buildUI(),
      floatingActionButton: FloatingActionButton.large(
        child: const Icon(Icons.save),
        onPressed: () {
          _saveTransaction();
      }),
    );
  }

  AppBar _transactionFormInsertAppBar() {
    return AppBar(
      title: const Text('New Transaction'),
      backgroundColor: Colors.lightGreen[100],
    );
  }

  AppBar _transactionFormUpdateAppBar() {
    return AppBar(
      title: const Text('Update Transaction'),
      backgroundColor: Colors.lightGreen[100],
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [ 
            const SizedBox(height: 20,),
            // Elevated buttons for selecting Income or Expense
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _selectedTransactionType = TransactionType.expense;

                    // Watch and filter categories when transaction type changes
                    _watchAndFilterCategories(_selectedTransactionType);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedTransactionType == TransactionType.expense
                        ? Colors.red[200]
                        : Colors.grey[300], // Red when selected, grey otherwise
                    shape: const LinearBorder(),
                  ),
                  label: const Text('Expense'),
                  icon: const Icon(Icons.upload, color: Colors.red,),
                ),
                const SizedBox(width: 10), // Spacing between the buttons
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _selectedTransactionType = TransactionType.income;

                      // Watch and filter categories when transaction type changes
                    _watchAndFilterCategories(_selectedTransactionType);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedTransactionType == TransactionType.income
                        ? Colors.green[200]
                        : Colors.grey[300], // Green when selected, grey otherwise
                    shape: const LinearBorder(),
                  ),
                  label: const Text('Income'),
                  icon: const Icon(Icons.download, color: Colors.green,),
                ),
              ],
            ),
            const SizedBox(height: 20),
              const SizedBox(height: 20,),
              Row(
                children: [
                  Flexible(flex: 2, child: _transactionDateTextFormField(),),
                  const SizedBox(width: 20,),
                  Flexible(flex: 1, child: _transactionTimeTextFormField(),),
                ],
              ),
              const SizedBox(height: 20,),
              _transactionNameTextFormField(),
              const SizedBox(height: 20,),
              _categoryNameDropdown(),
              const SizedBox(height: 20,),
              _transactionValueTextFormField(),
              const SizedBox(height: 20,),
              _transactionDescriptionTextFormField(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _transactionDateTextFormField() {
    return TextFormField(
      controller: _transactionDateController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Transaction Date',
      ),
      readOnly: true, // Make the field non-editable, so the user must use the date picker
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000), // The earliest date you want to allow
          lastDate: DateTime(2101), // The latest date you want to allow
        );
        
        if (pickedDate != null) {
          // Format the picked date to 'dd/MM/yyyy' and display it in the TextFormField
          String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
          setState(() {
            _transactionDateController.text = formattedDate; // Update the TextFormField
          });
        }
      },
    );
  }

  Widget _transactionTimeTextFormField() {
    return TextFormField(
      controller: _transactionTimeController,
      decoration: const InputDecoration(border: OutlineInputBorder(), label: Text('Transaction Time')),
      readOnly: true,
      onTap: () async {
        // Show the time picker
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
          builder: (BuildContext context, Widget? child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child!,
            );
          },
        );

        if (pickedTime != null) {
        setState(() {
          // Convert TimeOfDay to 24-hour format and update the controller
          final now = DateTime.now();
          final formattedTime = DateFormat('HH:mm').format(
            DateTime(now.year, now.month, now.day, pickedTime.hour, pickedTime.minute)
          );
          _transactionTimeController.text = formattedTime;
        });
        }
      },
    );
  }

  Widget _transactionNameTextFormField() {
    return TextFormField(
      controller: _transactionNameController,
      decoration: const InputDecoration(border: OutlineInputBorder(), label: Text('Transaction Name')),
      validator: (value) {
        if(value == null || value.isEmpty) {
          return 'Please enter a transaction name';
        }
        return null;
      },
    );
  }

  Widget _categoryNameDropdown() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(border: OutlineInputBorder(), label: Text('Category')),
      value: _selectedCategoryName,
      isExpanded: true,
      items: _filteredCategories.map((category) {
        return DropdownMenuItem<String>(
          value: category.categoryName,
          child: Text(category.categoryName),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _selectedCategoryName = newValue;
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

  Widget _transactionValueTextFormField() { ///KENE TENGOK NAK BAGI INITIALIZE DUA TITIK PERPULUHAN
    return TextFormField(
      controller: _transactionValueController,
      decoration: const InputDecoration(border: OutlineInputBorder(), label: Text('Amount')),
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

  Widget _transactionDescriptionTextFormField() {
    return TextFormField(
      controller: _transactionDescriptionController,
      decoration: const InputDecoration(border: OutlineInputBorder(), label: Text('Description')),
    );
  }
}

// SegmentedButton<TransactionType>(
//                 segments: const <ButtonSegment<TransactionType>>[
//                   ButtonSegment<TransactionType>(
//                     value: TransactionType.expense, 
//                     label: Text('Expense'), 
//                     icon: Icon(Icons.upload),),
//                   ButtonSegment<TransactionType>(
                    
//                     value: TransactionType.income, 
//                     label: Text('Income'), 
//                     icon: Icon(Icons.download),),
//                 ],
//                 selected: <TransactionType>{_selectedTransactionType},
//                 onSelectionChanged: (Set<TransactionType> newSelection) {
//                   setState(() {
//                     _selectedTransactionType = newSelection.first;

//                     // Watch and filter categories when transaction type changes
//                     _watchAndFilterCategories(_selectedTransactionType);
//                   });
//                 },
//               ),