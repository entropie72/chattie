import 'package:chattie/providers/providers.dart';
import 'package:chattie/utils/constants.dart';
import 'package:chattie/widgets/layouts/custom_app_bar.dart';
import 'package:chattie/widgets/layouts/custom_tab_bar.dart';
import 'package:chattie/widgets/tab_views/chats_view.dart';
import 'package:chattie/widgets/tab_views/contacts_view.dart';
import 'package:chattie/widgets/tab_views/settings_view.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  TabItems _currentTab = TabItems.chats;
  List contacts = [];

  @override
  void initState() {
    super.initState();
    final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
    final currentUserUid = ref.read(currentUserUidProvider);
    dbRef.child('contacts/$currentUserUid').onValue.listen((event) async {
      List<Map> contactsListWithUserInfo = [];
      List contactsList =
          event.snapshot.value != 0 ? event.snapshot.value as List : [];
      for (String contact in contactsList) {
        final snapshot = await dbRef.child('users/$contact').get();
        contactsListWithUserInfo.add(snapshot.value as Map);
      }
      setState(() {
        contacts = contactsListWithUserInfo;
      });
    });
  }

  void _selectTab(TabItems tabItems) {
    setState(() {
      _currentTab = tabItems;
    });
  }

  Widget getTabView() {
    switch (_currentTab) {
      case TabItems.contacts:
        return ContactsView(
          contacts: contacts,
        );
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
