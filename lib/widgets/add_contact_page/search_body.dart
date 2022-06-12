import 'package:chattie/pages/add_contact_page.dart';
import 'package:chattie/utils/constants.dart';
import 'package:chattie/widgets/shared/contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchBody extends ConsumerWidget {
  const SearchBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SearchState searchState = ref.watch(searchStateProvider);
    Map? searchResult = ref.watch(searchResultProvider);
    switch (searchState) {
      case SearchState.empty:
        return const Text('Not found');
      case SearchState.hasResult:
        return Contact(contact: searchResult!);
      default:
        return const Text('Find your friends on Chattie');
    }
  }
}
