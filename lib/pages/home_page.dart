import 'package:chattie/utils/constants.dart';
import 'package:chattie/widgets/layouts/custom_app_bar.dart';
import 'package:chattie/widgets/layouts/custom_tab_bar.dart';
import 'package:chattie/widgets/tab_views/chats_view.dart';
import 'package:chattie/widgets/tab_views/contacts_view.dart';
import 'package:chattie/widgets/tab_views/settings_view.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItems _currentTab = TabItems.chats;

  void _selectTab(TabItems tabItems) {
    setState(() {
      _currentTab = tabItems;
    });
  }

  Widget getTabView() {
    switch (_currentTab) {
      case TabItems.contacts:
        return const ContactsView();
      case TabItems.setting:
        return const SettingViews();
      default:
        return const ChatsView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(tabItem: _currentTab),
            Expanded(
              child: getTabView(),
            ),
            CustomTabBar(currentTab: _currentTab, selectTab: _selectTab)
          ],
        ),
      ),
    );
  }
}
