import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:uruswang_money_manager_app/models/category.dart';
import 'package:uruswang_money_manager_app/services/database_service/app_database.dart';
import 'package:uruswang_money_manager_app/services/model_service/category_service.dart';
import 'package:uruswang_money_manager_app/services/navigation_service.dart';

class CategorySettingsPage extends StatefulWidget {
  const CategorySettingsPage({super.key});

  @override
  State<CategorySettingsPage> createState() => _CategorySettingsPageState();
}

class _CategorySettingsPageState extends State<CategorySettingsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final GetIt _getIt = GetIt.instance;
  late NavigationService _navigationService;
  late CategoryService _categoryService;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Initialize TabController with 2 tabs
    _tabController = TabController(length: 2, vsync: this);

    // Listen to tab changes to update the FAB dynamically
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {}); // Update the UI when the tab changes
      }
    });

    _navigationService = _getIt.get<NavigationService>();
    _categoryService = _getIt.get<CategoryService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _buildUI(),
      floatingActionButton: _categoryFloatingActionButton(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text('Manage Category'),
      backgroundColor: Colors.lightGreen[100],
      bottom: TabBar(
        tabs: const [
          Tab(
            text: 'Expense',
          ),
          Tab(
            text: 'Income',
          )
        ],
        controller: _tabController,
      ),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: TabBarView(controller: _tabController, children: [
        _expenseTabView(),
        _incomeTabView(),
      ]),
    );
  }

  Widget _expenseTabView() {
    return StreamBuilder(
        stream: _categoryService.watchAllCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator()); // Loading state
          }

          if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}')); // Error state
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No categories available'),
            );
          }

          final expenseCategories = snapshot.data!
              .where((categoryItem) =>
                  categoryItem.categoryType.name == 'expense' &&
                  categoryItem.deletedAt == null)
              .toList();

          if (expenseCategories.isEmpty) {
            return const Center(
                child: Text('No expense categories available.'));
          }

          // Display the filtered expense categories in a ListView
          return ListView.builder(
            itemCount: expenseCategories.length + 1,
            itemBuilder: (context, index) {
              if (index == expenseCategories.length) {
                // Return SizedBox at the end of the list
                return const SizedBox(height: 70); // Adjust the height as needed
              }

              final expenseCategory = expenseCategories[index];

              return Column(
                children: [
                  _categoryListTile(expenseCategory),
                  // ListTile(
                  //   title: Text(expenseCategory.categoryName),
                  //   subtitle: Text('${expenseCategory.categoryType.name}'),
                  // ),
                ],
              );
            },
          );
        });
  }

  Widget _incomeTabView() {
    return StreamBuilder(
        stream: _categoryService.watchAllCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator()); // Loading state
          }

          if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}')); // Error state
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No categories available'),
            );
          }

          final incomeCategories = snapshot.data!
              .where((categoryItem) =>
                  categoryItem.categoryType.name == 'income' &&
                  categoryItem.deletedAt == null)
              .toList();

          if (incomeCategories.isEmpty) {
            return const Center(child: Text('No income categories available.'));
          }

          // Display the filtered expense categories in a ListView
          return ListView.builder(
            itemCount: incomeCategories.length + 1,
            itemBuilder: (context, index) {
              if (index == incomeCategories.length) {
                // Return SizedBox at the end of the list
                return const SizedBox(height: 70); // Adjust the height as needed
              }

              final incomeCategory = incomeCategories[index];

              return Column(
                children: [
                  // ListTile(
                  //   title: Text(incomeCategory.categoryName),
                  //   subtitle: Text('${incomeCategory.categoryType.name}'),
                  // ),
                  _categoryListTile(incomeCategory),
                ],
              );
            },
          );
        });
  }

  Widget _categoryListTile(Category categoryItem) {
    return ListTile(
        leading: categoryItem.categoryType.name == 'expense'
            ? const Icon(
                Icons.upload,
                color: Colors.red,
              )
            : const Icon(
                Icons.download,
                color: Colors.green,
              ),
        title: Text(categoryItem.categoryName),
        trailing: categoryItem.isProtected == true
            ? IconButton(
                onPressed: () {
                  _showWhyProtectedDialog(context, categoryItem);
                },
                icon: const Icon(Icons.info))
            : Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(
                    onPressed: () {
                      _showUpdateCategoryNameDialog(context, categoryItem);
                    },
                    icon: const Icon(Icons.edit)),
                IconButton(
                    onPressed: () {
                      _showDeleteCategoryNameDialog(context, categoryItem);
                    },
                    icon: const Icon(Icons.delete))
              ]));
  }

  Widget _categoryFloatingActionButton() {
    if (_tabController.index == 0) {
      return FloatingActionButton.extended(
        label: const Text('Expense'),
        icon: const Icon(Icons.add),
        onPressed: () {
          _showInsertCategoryNameDialog(context, 'Expense');
        },
      );
    } else if (_tabController.index == 1) {
      return FloatingActionButton.extended(
          label: const Text('Income'),
          icon: const Icon(Icons.add),
          onPressed: () {
            _showInsertCategoryNameDialog(context, 'Income');
          });
    } else {
      return FloatingActionButton(onPressed: () {});
    }
  }

  Future<void> _showInsertCategoryNameDialog(
      BuildContext context, String categoryTypeName) async {
    final inputNewCategoryNameFormKey = GlobalKey<FormState>();
    String inputNewCategoryName = '';
    String? errorMessage;

    await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text('Insert New $categoryTypeName Category'),
              content: Form(
                  key: inputNewCategoryNameFormKey,
                  child: TextFormField(
                    autofocus: true,
                    decoration: InputDecoration(
                      label: const Text('Category Name'),
                      border: const OutlineInputBorder(),
                      errorText: errorMessage,
                      errorMaxLines: 4,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return ('This field cannot be empty');
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        inputNewCategoryName = value;
                        errorMessage = null;
                      });
                    },
                  )),
              actions: [
                TextButton(
                    onPressed: _navigationService.goBack,
                    child: const Text('Cancel')),
                ElevatedButton(
                    onPressed: () async {
                      final scaffoldMessenger = ScaffoldMessenger.of(context);

                      if (inputNewCategoryNameFormKey.currentState!
                          .validate()) {
                        // Call insertNewCategory and check if there's an error
                        final result = await _categoryService.insertNewCategory(
                          inputNewCategoryName,
                          categoryTypeName.toLowerCase(),
                          DateTime.now(),
                        );

                        // If result is not null, we have a validation error
                        if (result != null) {
                          // Update the UI to show the error message
                          setState(() {
                            errorMessage =
                                result; // Show error message in TextFormField
                          });
                        } else {
                          // If no error, close the dialog
                          _navigationService.goBack();

                          scaffoldMessenger.showSnackBar(
                            const SnackBar(
                              content: Text('The category is successfully inserted'),
                              duration: Duration(seconds: 2),
                          ),
                    );
                        }
                      }
                    },
                    child: const Text('Confirm'))
              ],
            );
          });
        });
  }

  Future<void> _showUpdateCategoryNameDialog(
      BuildContext context, Category category) async {
    final inputUpdateCategoryNameFormKey = GlobalKey<FormState>();
    String updatedCategoryName = category.categoryName;
    CategoryType categoryTypeToBeUpdated = category.categoryType;
    String? errorMessage;

    await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text('Update ${category.categoryName} Category'),
              content: Form(
                key: inputUpdateCategoryNameFormKey,
                child: TextFormField(
                    initialValue: updatedCategoryName,
                    decoration: InputDecoration(
                      label: const Text('Category Name'),
                      border: const OutlineInputBorder(),
                      errorText: errorMessage,
                      errorMaxLines: 5,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field cannot be empty';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      updatedCategoryName = value;
                    }),
              ),
              actions: [
                TextButton(
                    onPressed: _navigationService.goBack,
                    child: const Text('Cancel')),
                ElevatedButton(
                    onPressed: () async {
                      final scaffoldMessenger = ScaffoldMessenger.of(context);

                      if (inputUpdateCategoryNameFormKey.currentState!
                          .validate()) {
                        final result =
                            await _categoryService.updateCategoryInDatabase(
                                category.categoryId,
                                updatedCategoryName,
                                categoryTypeToBeUpdated,
                                DateTime.now());
                        // If result is not null, we have a validation error
                        if (result != null) {
                          // Update the UI to show the error message
                          setState(() {
                            errorMessage =
                                result; // Show error message in TextFormField
                          });
                        } else {
                          // If no error, close the dialog
                          _navigationService.goBack();

                          scaffoldMessenger.showSnackBar(
                            const SnackBar(
                              content: Text('The category name is successfully updated'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      }
                    },
                    child: const Text('Confirm'))
              ],
            );
          });
        });
  }

  Future<void> _showDeleteCategoryNameDialog(
      BuildContext context, Category category) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete ${category.categoryName} Category'),
            content:
                const Text('Are you sure you want to delete this category?'),
            actions: [
              TextButton(
                  onPressed: _navigationService.goBack,
                  child: const Text('Cancel')),
              ElevatedButton(
                  onPressed: () {
                    final scaffoldMessenger = ScaffoldMessenger.of(context);

                    _categoryService.softDeleteCategory(category.categoryId);
                    _navigationService.goBack();

                    scaffoldMessenger.showSnackBar(
                            const SnackBar(
                              content: Text('The category is successfully soft deleted'),
                              duration: Duration(seconds: 2),
                            ),
                    );
                  },
                  child: const Text('Delete',
                      style: TextStyle(color: Colors.red))),
            ],
          );
        });
  }

  Future<void> _showWhyProtectedDialog(BuildContext context, Category category) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Additional Information on ${category.categoryName} Category'),
          content: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 200, // Set the maximum height you want
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${category.additionalInformation}'),
                  const SizedBox(height: 16), // Add some spacing
                  const Text(
                    'This category cannot be edited and deleted because this category is fixed to debt-related transactions uses.',
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: _navigationService.goBack,
              child: const Text('Understood'),
            ),
          ],
        );
      },
    );
  }


  @override
  void dispose() {
    _tabController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
}
