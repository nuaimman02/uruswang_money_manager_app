import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:uruswang_money_manager_app/services/database_service/app_database.dart';
import 'package:uruswang_money_manager_app/services/model_service/category_service.dart';
import 'package:uruswang_money_manager_app/services/navigation_service.dart';

class RestoreCategorySettingsPage extends StatefulWidget {
  const RestoreCategorySettingsPage({super.key});

  @override
  State<RestoreCategorySettingsPage> createState() => _RestoreCategorySettingsPageState();
}

class _RestoreCategorySettingsPageState extends State<RestoreCategorySettingsPage> 
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
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text('Restore Deleted Categories'),
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
        _deletedExpenseTabView(),
        _deletedIncomeTabView(),
      ]),
    );
  }

  Widget _deletedExpenseTabView() {
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
              child: Text('No deleted categories available'),
            );
          }

          final expenseCategories = snapshot.data!
              .where(
                  (categoryItem) => categoryItem.categoryType.name == 'expense' && categoryItem.deletedAt != null)
              .toList();

          if (expenseCategories.isEmpty) {
            return const Center(
                child: Text('No deleted expense categories available.'));
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

  Widget _deletedIncomeTabView() {
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
              child: Text('No deleted categories available'),
            );
          }

          final incomeCategories = snapshot.data!
              .where(
                  (categoryItem) => categoryItem.categoryType.name == 'income' && categoryItem.deletedAt != null)
              .toList();

          if (incomeCategories.isEmpty) {
            return const Center(child: Text('No deleted income categories available.'));
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
                  _categoryListTile(incomeCategory)
                ],
              );
            },
          );
        });
  }

  Widget _categoryListTile(Category categoryItem) {
    return ListTile(
      leading: categoryItem.categoryType.name == 'expense'
          ? const Icon(Icons.upload, color: Colors.red,)
          : const Icon(Icons.download, color: Colors.green,),
      title: Text(categoryItem.categoryName),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
                onPressed: () {
                  _showRestoreDialog(context, categoryItem);
                }, 
                icon: const Icon(Icons.restore)),
          IconButton(
            onPressed: () {
            _showDeleteDialog(context, categoryItem);
          }, icon: const Icon(Icons.delete))
        ],
      ) 
            );
  }

  Future<void> _showRestoreDialog(BuildContext context, Category category) async {
    await showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: Text('Restore ${category.categoryName} Category'),
          content: const Text('Are you sure you want to restore this category?'),
          actions: [
              TextButton(onPressed: _navigationService.goBack, child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () async {
                  final scaffoldMessenger = ScaffoldMessenger.of(context);

                  await _categoryService.restoreCategory(category.categoryId);
                  _navigationService.goBack();

                  scaffoldMessenger.showSnackBar(
                    const SnackBar(
                      content: Text('The category is successfully restored'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }, 
                child: const Text('Restore'),
              ),
            ],          
        );
      });
  }

  Future<void> _showDeleteDialog(BuildContext context, Category category) async {
    await showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: Text('Delete ${category.categoryName} Category'),
          content: const Text('Are you sure you want to delete this category?'),
          actions: [
              TextButton(onPressed: _navigationService.goBack, child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () async {
                  final scaffoldMessenger = ScaffoldMessenger.of(context);

                  await _categoryService.deleteCategory(category.categoryId);
                  _navigationService.goBack();

                  scaffoldMessenger.showSnackBar(
                    const SnackBar(
                      content: Text('The category is successfully deleted'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }, 
                child: const Text('Delete'),
              ),
            ],          
        );
      });
  }
}