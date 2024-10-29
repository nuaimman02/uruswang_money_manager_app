import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:uruswang_money_manager_app/models/transaction.dart';
import 'package:uruswang_money_manager_app/models/transactions_with_categories_and_debts.dart';
import 'package:uruswang_money_manager_app/services/database_service/app_database.dart';
import 'package:uruswang_money_manager_app/services/model_service/category_service.dart';
import 'package:uruswang_money_manager_app/services/model_service/debt_service.dart';
import 'package:uruswang_money_manager_app/services/model_service/transaction_service.dart';
import 'package:uruswang_money_manager_app/services/navigation_service.dart';
import 'package:drift/drift.dart' as drift;

class DebtsFormPage extends StatefulWidget {
  final TransactionsWithCategoriesAndDebts? debtTransactionInitiator;
  final TransactionsWithCategoriesAndDebts? debtTransactionSettlement;

  const DebtsFormPage({super.key, this.debtTransactionInitiator, this.debtTransactionSettlement});

  @override
  State<DebtsFormPage> createState() => _DebtsFormPageState();
}

class _DebtsFormPageState extends State<DebtsFormPage> {
  final GetIt _getIt = GetIt.instance;
  late NavigationService _navigationService;
  late CategoryService _categoryService;
  late TransactionService _transactionService;
  late DebtService _debtService;

  final _formKey = GlobalKey<FormState>(); 
  final TextEditingController _debtTransactionNameController = TextEditingController(); 
  final TextEditingController _debtTransactionValueController = TextEditingController();
  final TextEditingController _debtTransactionDateController = TextEditingController();
  final TextEditingController _debtTransactionTimeController = TextEditingController();
  final TextEditingController _debtTransactionDescriptionController = TextEditingController();
  final TextEditingController _debtTransactionPeopleNameController = TextEditingController();
  final TextEditingController _debtTransactionExpectedSettlementDateController = TextEditingController();

  bool isUpdate = false;

  TransactionType _selectedTransactionType = TransactionType.income;
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
    _debtService = _getIt.get<DebtService>();

    if(widget.debtTransactionInitiator != null) {
      isUpdate = true;
      _debtTransactionNameController.text = widget.debtTransactionInitiator?.transactions.transactionName ?? '';
      _debtTransactionValueController.text = widget.debtTransactionInitiator?.transactions.value.toStringAsFixed(2) ?? '0.00';
      _debtTransactionDateController.text = widget.debtTransactionInitiator != null
          ? DateFormat('dd/MM/yyyy').format(widget.debtTransactionInitiator!.transactions.transactionDate)
          : '';
      _debtTransactionTimeController.text = widget.debtTransactionInitiator != null
          ? DateFormat('HH:mm').format(widget.debtTransactionInitiator!.transactions.transactionDate)
          : ''; 
      _debtTransactionDescriptionController.text = widget.debtTransactionInitiator?.transactions.description ?? '';
      _debtTransactionPeopleNameController.text = widget.debtTransactionInitiator?.debts?.peopleName ?? '';
      _debtTransactionExpectedSettlementDateController.text = 
          (widget.debtTransactionInitiator != null && widget.debtTransactionInitiator!.debts?.expectedToBeSettledDate != null)
          ? DateFormat('dd/MM/yyyy').format(widget.debtTransactionInitiator!.debts!.expectedToBeSettledDate!)
          : '';
      _selectedCategoryName = widget.debtTransactionInitiator?.categories.categoryName;
      _originalCategoryName = _selectedCategoryName; // Store original category
      _selectedTransactionType = widget.debtTransactionInitiator != null
        ? TransactionType.values.byName(widget.debtTransactionInitiator!.transactions.transactionType.name)
        : TransactionType.expense;   

    } else {
      DateTime now = DateTime.now();
      _debtTransactionDateController.text = DateFormat('dd/MM/yyyy').format(now);  // Set today's date
      _debtTransactionTimeController.text = DateFormat('HH:mm').format(now); // Set current time
      _debtTransactionValueController.text = '0.00';  
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
            return category.categoryName == 'Borrowing'; //category.categoryType == CategoryType.income && category.isProtected == true ;
          } else {
            return category.categoryName == 'Lending'; //category.categoryType == CategoryType.expense && category.isProtected == true;
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
      String debtTransactionName = _debtTransactionNameController.text;
      double debtTransactionValue = double.parse(_debtTransactionValueController.text);
      DateTime debtTransactionDate = combineDateAndTime(_debtTransactionDateController, _debtTransactionTimeController);
      String? categoryName = _selectedCategoryName;
      TransactionType debtTransactionType = _selectedTransactionType;
      String description = _debtTransactionDescriptionController.text;
      String peopleName = _debtTransactionPeopleNameController.text;

      DateTime? expectedSettlementDate;
      if(_debtTransactionExpectedSettlementDateController.text.isNotEmpty) {
        expectedSettlementDate = combineExpectedSettlementDateAndTime(_debtTransactionExpectedSettlementDateController);
      }

      // Fetch categoryId based on categoryName (assuming you have a method like _getCategoryIdByName)
      int? inititatorCategoryId = await _categoryService.getCategoryId(categoryName!);
      
      final debtCompanion = DebtsCompanion(
        peopleName: drift.Value(peopleName),
        expectedToBeSettledDate: drift.Value(expectedSettlementDate),
      );

      final initiatorDebtTransactionCompanion = TransactionsCompanion(
        transactionName: drift.Value(debtTransactionName),
        value: drift.Value(debtTransactionValue),
        transactionDate: drift.Value(debtTransactionDate),
        transactionType: drift.Value(debtTransactionType),
        categoryId: drift.Value(inititatorCategoryId),
        description: drift.Value(description),
        //debtId: const drift.Value.absentIfNull(null)
      );

      if (isUpdate == false) { //If inserting new record
        // Insert the debt and get the debtId
        final debtId = await _debtService.insertDebt(debtCompanion);

        // Now link the debtId to the transaction
        final linkedInitiatorDebtTransactionCompanion = initiatorDebtTransactionCompanion.copyWith(
          debtId: drift.Value(debtId), // Set the debtId here
        );

        // Insert the transaction with the debtId
        await _transactionService.insertTransaction(linkedInitiatorDebtTransactionCompanion);

        // Schedule the notification
        if (expectedSettlementDate != null) {
          await _debtService.scheduleDebtNotification(
            debtId,
            debtTransactionName,
            peopleName,
            categoryName,
            debtTransactionValue,
            expectedSettlementDate,
          );
        }
      } else { // If updating
        if(widget.debtTransactionSettlement != null) { //If debtTransactionSettlement exist
          if(widget.debtTransactionInitiator!.categories.categoryName == categoryName) { //If categoryName still same after updating
            _debtService.updateDebt(widget.debtTransactionInitiator!.debts!.debtId, debtCompanion);
            _transactionService.updateTransaction(widget.debtTransactionInitiator!.transactions.transactionId, initiatorDebtTransactionCompanion);

            final settlementDebtTransactionCompanion = TransactionsCompanion(
                transactionName: drift.Value('$debtTransactionName (Paid)'),
                value: drift.Value(debtTransactionValue),
            );

            _transactionService.updateTransaction(widget.debtTransactionSettlement!.transactions.transactionId, settlementDebtTransactionCompanion);

          } else { //If categoryName changes after updating
            if(widget.debtTransactionInitiator!.categories.categoryName == 'Borrowing') {
              //If debtTransactionInitiator.categories.categoryName == 'Borrowing', 
              //the initiator become 'Lending'and settlement becomes 'Receive Debt'
              _debtService.updateDebt(widget.debtTransactionInitiator!.debts!.debtId, debtCompanion);
              _transactionService.updateTransaction(widget.debtTransactionInitiator!.transactions.transactionId, initiatorDebtTransactionCompanion);
              
              int? receiveDebtCategoryId = await _categoryService.getCategoryId('Receive Debt');

              final settlementDebtTransactionCompanion = TransactionsCompanion(
                transactionName: drift.Value('$debtTransactionName (Paid)'),
                value: drift.Value(debtTransactionValue),
                transactionType: const drift.Value(TransactionType.income),
                categoryId: drift.Value(receiveDebtCategoryId),
              );

              _transactionService.updateTransaction(widget.debtTransactionSettlement!.transactions.transactionId, settlementDebtTransactionCompanion);

            } else { 
               //If debtTransactionInitiator.categories.categoryName == 'Lending' 
               //the initiator become 'Borrowing'and settlement becomes 'Paying Debt'
              _debtService.updateDebt(widget.debtTransactionInitiator!.debts!.debtId, debtCompanion);
              _transactionService.updateTransaction(widget.debtTransactionInitiator!.transactions.transactionId, initiatorDebtTransactionCompanion);

              int? payingDebtCategoryId = await _categoryService.getCategoryId('Paying Debt');

              final settlementDebtTransactionCompanion = TransactionsCompanion(
                transactionName: drift.Value('$debtTransactionName (Paid)'),
                value: drift.Value(debtTransactionValue),
                transactionType: const drift.Value(TransactionType.expense),
                categoryId: drift.Value(payingDebtCategoryId),
              );

              _transactionService.updateTransaction(widget.debtTransactionSettlement!.transactions.transactionId, settlementDebtTransactionCompanion);
            }
          } 
        } else { // If debtTransactionSettlement not exist
          _debtService.updateDebt(widget.debtTransactionInitiator!.debts!.debtId, debtCompanion);
          _transactionService.updateTransaction(widget.debtTransactionInitiator!.transactions.transactionId, initiatorDebtTransactionCompanion);
        }

          // Cancel any previous notification
          await _debtService.cancelScheduledDebtNotification(widget.debtTransactionInitiator!.debts!.debtId);

          // Reschedule a new notification with updated expected settlement date
          if (expectedSettlementDate != null) {
            await _debtService.scheduleDebtNotification(
              widget.debtTransactionInitiator!.debts!.debtId,
              debtTransactionName,
              peopleName,
              categoryName,
              debtTransactionValue,
              expectedSettlementDate,
            );
          }
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

  DateTime combineExpectedSettlementDateAndTime(TextEditingController dateController) {
    // 1. Parse the date from the controller
    DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(dateController.text);

    // 2. Set the time to 12:00 PM (noon)
    int fixedHour = 12;
    int fixedMinute = 0;

    // 3. Combine the date and fixed time (12:00)
    DateTime combinedExpectedSettlementDateTime = DateTime(
      parsedDate.year,
      parsedDate.month,
      parsedDate.day,
      fixedHour,
      fixedMinute,
    );

    return combinedExpectedSettlementDateTime; // Return the combined DateTime
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
    _debtTransactionValueController.value = TextEditingValue(
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
      appBar: _appBar(),
      body: _buildUI(),
      floatingActionButton: FloatingActionButton.large(
        child: const Icon(Icons.save),
        onPressed: () {
          _saveTransaction();
      }),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(isUpdate ? 'Update Debt Transaction' : 'New Debt Transaction'),
      backgroundColor: Colors.lightGreen[100],
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: SingleChildScrollView(
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
                    label: const Text('Borrowing'),
                    icon: const Icon(Icons.download, color: Colors.green,),
                  ),
                  const SizedBox(width: 10), // Spacing between the buttons
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
                    label: const Text('Lending'),
                    icon: const Icon(Icons.upload, color: Colors.red,),
                  ),
                ],
              ),
              const SizedBox(height: 20),
                const SizedBox(height: 20,),
                Row(
                  children: [
                    Flexible(flex: 2, child: _debtTransactionDateTextFormField(),),
                    const SizedBox(width: 20,),
                    Flexible(flex: 1, child: _debtTransactionTimeTextFormField(),),
                  ],
                ),
                const SizedBox(height: 20,),
                _debtTransactionNameTextFormField(),
                const SizedBox(height: 20,),
                _debtCategoryNameDropdown(),
                const SizedBox(height: 20,),
                _debtTransactionValueTextFormField(),
                const SizedBox(height: 20,),
                _debtTransactionPeopleNameTextFormField(),
                const SizedBox(height: 20,),
                _debtTransactionExpectedSettlementDateTextFormField(),
                const SizedBox(height: 20,),
                _debtTransactionDescriptionTextFormField(),
                const SizedBox(height: 110,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _debtTransactionDateTextFormField() {
    return TextFormField(
      controller: _debtTransactionDateController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Debt Transaction Date',
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
            _debtTransactionDateController.text = formattedDate; // Update the TextFormField
          });
        }
      },
    );
  }

  Widget _debtTransactionTimeTextFormField() {
    return TextFormField(
      controller: _debtTransactionTimeController,
      decoration: const InputDecoration(border: OutlineInputBorder(), label: Text('Debt Transaction Time')),
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
          _debtTransactionTimeController.text = formattedTime;
        });
        }
      },
    );
  }

  Widget _debtTransactionNameTextFormField() {
    return TextFormField(
      controller: _debtTransactionNameController,
      decoration: const InputDecoration(border: OutlineInputBorder(), label: Text('Debt Transaction Name')),
      validator: (value) {
        if(value == null || value.isEmpty) {
          return 'Please enter a transaction name';
        }
        return null;
      },
    );
  }

  Widget _debtCategoryNameDropdown() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(border: OutlineInputBorder(), label: Text('Debt Category')),
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

  Widget _debtTransactionValueTextFormField() { ///KENE TENGOK NAK BAGI INITIALIZE DUA TITIK PERPULUHAN
    return TextFormField(
      controller: _debtTransactionValueController,
      decoration: const InputDecoration(border: OutlineInputBorder(), label: Text('Debt Amount')),
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

  Widget _debtTransactionDescriptionTextFormField() {
    return TextFormField(
      controller: _debtTransactionDescriptionController,
      decoration: const InputDecoration(border: OutlineInputBorder(), label: Text('Description')),
    );
  }

    Widget _debtTransactionPeopleNameTextFormField() {
    return TextFormField(
      controller: _debtTransactionPeopleNameController,
      decoration: const InputDecoration(border: OutlineInputBorder(), label: Text('People Name')),
      validator: (value) {
        if(value == null || value.isEmpty) {
          return 'Please enter a person name who involves in this debt transaction';
        }
        return null;
      },
    );
  }

  // Widget _debtTransactionExpectedSettlementDateTextFormField() {
  //   return TextFormField(
  //     controller: _debtTransactionExpectedSettlementDateController,
  //     decoration: InputDecoration(
  //       border: const OutlineInputBorder(),
  //       labelText: 'Expected Debt Settlement Date',
  //       suffixIcon: IconButton(
  //         icon: const Icon(Icons.info_outline),  // Information icon
  //         onPressed: () {
  //           showDialog(
  //             context: context,
  //             builder: (BuildContext context) {
  //               return AlertDialog(
  //                 title: const Text('Information'),
  //                 content: const Text('This date will be used to notify you to settle the debt.'),
  //                 actions: <Widget>[
  //                   TextButton(
  //                     onPressed: () {
  //                       Navigator.of(context).pop();
  //                     },
  //                     child: const Text('OK'),
  //                   ),
  //                 ],
  //               );
  //             },
  //           );
  //         },
  //       ),
  //     ),
  //     readOnly: true, // Make the field non-editable, so the user must use the date picker
  //     onTap: () async {
  //       DateTime? pickedDate = await showDatePicker(
  //         context: context,
  //         initialDate: DateTime.now(),
  //         firstDate: DateTime(2000), // The earliest date you want to allow
  //         lastDate: DateTime(2101), // The latest date you want to allow
  //       );
        
  //       if (pickedDate != null) {
  //         // Format the picked date to 'dd/MM/yyyy' and display it in the TextFormField
  //         String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
  //         setState(() {
  //           _debtTransactionExpectedSettlementDateController.text = formattedDate; // Update the TextFormField
  //         });
  //       }
  //     },
  //   );
  // }
  Widget _debtTransactionExpectedSettlementDateTextFormField() {
  return TextFormField(
    controller: _debtTransactionExpectedSettlementDateController,
    decoration: InputDecoration(
      border: const OutlineInputBorder(),
      labelText: 'Expected Debt Settlement Date',
      suffixIcon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_debtTransactionExpectedSettlementDateController.text.isNotEmpty) 
            IconButton(
              icon: const Icon(Icons.clear),  // "X" icon
              onPressed: () {
                setState(() {
                  _debtTransactionExpectedSettlementDateController.clear();  // Clear the text field
                });
              },
            ),
          IconButton(
            icon: const Icon(Icons.info_outline),  // Information icon
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Information'),
                    content: const Text('This date will be used to notify you to settle the debt.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    ),
    readOnly: true, // Still make the field non-editable except via the date picker
    onTap: () async {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000), // The earliest date you want to allow
        lastDate: DateTime(2101),  // The latest date you want to allow
      );
      
      if (pickedDate != null) {
        // Format the picked date and display it in the TextFormField
        String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
        setState(() {
          _debtTransactionExpectedSettlementDateController.text = formattedDate; // Update the TextFormField
        });
      }
    },
  );
}

}  
