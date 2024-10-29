import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:uruswang_money_manager_app/pages/more/category_settings/category_settings_page.dart';
import 'package:uruswang_money_manager_app/pages/more/restore_category_settings/restore_category_settings_page.dart';
import 'package:uruswang_money_manager_app/services/navigation_service.dart';

class MorePage extends StatefulWidget {
  const MorePage({super.key});

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  final GetIt _getIt = GetIt.instance;
  late NavigationService navigationService;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    navigationService = _getIt.get<NavigationService>();
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
      title: const Text('More'),
      backgroundColor: Colors.lightGreen[100],
    );
  }

  Widget _buildUI() {
    return SafeArea(
        child: Column(
      children: [
        // const SizedBox(height: 20,),
        // _moreHeader('MORE FUNCTIONS'),
        // _moreDivider(),
        // _moreTile(text: 'Debts', icon: Icons.money, page: const DebtsPage()),
        // _moreDivider(),
        const SizedBox(height: 20),
        _moreHeader('CATEGORY SETTINGS'),
        _moreDivider(),
        _moreTile(
            text: 'Manage Category', icon: Icons.category, page: const CategorySettingsPage()),
        _moreDivider(),
        _moreTile(text: 'Restore Deleted Category', icon: Icons.restore, page: const RestoreCategorySettingsPage()),
        _moreDivider(),
        // const SizedBox(height: 20),
        // _moreHeader('APP SETTINGS'),
        // _moreDivider(),
        // _moreTile(
        //     text: 'Security', icon: Icons.security, page: const SecuritySettingsPage()),
        // _moreDivider(),
        // _logoutTile(),
        // _moreDivider(),
      ],
    ));
  }

  Widget _moreHeader(String text) {
    return Row(
      children: [
        const SizedBox(width: 8),
        Column(
          children: [
            Text(text,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }

  Widget _moreDivider() {
    return const Divider();
  }

  Widget _moreTile(
      {required String text, required IconData icon, required Widget page}) {
    return ListTile(
      title: Text(
        text,
        style: const TextStyle(fontSize: 19),
      ),
      leading: Icon(
        icon,
        size: 35,
      ),
      onTap: () {
        navigationService.push(MaterialPageRoute(builder: (context) {
          return page;
        }));
      },
      trailing: const Icon(Icons.arrow_forward_ios),
    );
  }

  // Widget _logoutTile() {
  //   return ListTile(
  //     title: const Text(
  //       'Logout',
  //       style: TextStyle(fontSize: 19, color: Colors.red),
  //     ),
  //     leading: const Icon(Icons.logout, size: 35, color: Colors.red),
  //     onTap: () {
  //       // navigationService.push(MaterialPageRoute(builder: (context) {
  //       //   return page;
  //       // }));
  //     },
  //   );
  // }
}
