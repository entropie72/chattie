import 'package:chattie/utils/constants.dart';
import 'package:chattie/widgets/add_contact_page/search_body.dart';
import 'package:chattie/widgets/ui/base_divider.dart';
import 'package:chattie/widgets/ui/base_input.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

final searchStateProvider = StateProvider.autoDispose<SearchState>((ref) {
  return SearchState.beforeSearching;
});
final searchResultProvider = StateProvider.autoDispose<Map?>((ref) => null);

class AddContactPage extends StatefulWidget {
  const AddContactPage({Key? key}) : super(key: key);

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  void handleBackToContacts(BuildContext context) {
    Navigator.pop(context);
  }

  void setSearchResultState(
      WidgetRef ref, SearchState searchState, Map? searchResult) {
    ref.read(searchStateProvider.notifier).state = searchState;
    ref.read(searchResultProvider.notifier).state = searchResult;
  }

  void handleSearch(String inputText, WidgetRef ref) async {
    if (inputText.isEmpty) {
      setSearchResultState(ref, SearchState.beforeSearching, null);
      return;
    }

    final db = FirebaseFirestore.instance;
    final QuerySnapshot snapshot = await db
        .collection('users')
        .where('username', isEqualTo: inputText)
        .get();

    snapshot.docs.isNotEmpty
        ? setSearchResultState(
            ref, SearchState.hasResult, snapshot.docs.first.data() as Map)
        : setSearchResultState(ref, SearchState.empty, null);
  }

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: appBarPadding,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => handleBackToContacts(context),
                    child: SvgPicture.asset(
                      'assets/icons/linear/left_arrow.svg',
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Consumer(
                      builder: (context, ref, _) => BaseInput(
                          onChanged: (text) => handleSearch(text, ref),
                          labelText: 'Search Chattie',
                          controller: searchController),
                    ),
                  ),
                ],
              ),
            ),
            const BaseDivider(),
            const Expanded(
              child: Center(
                child: SearchBody(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
