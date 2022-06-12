import 'package:chattie/providers/providers.dart';
import 'package:chattie/widgets/shared/contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContactsView extends StatelessWidget {
  const ContactsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final contacts = ref.watch(currentUserContactsProvider);

        return contacts.when(
          data: (contacts) {
            if (contacts.isEmpty) {
              return const Center(
                child: Text('You don\'t have any contact'),
              );
            }
            return Center(
              child: ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  final contact = contacts[index];
                  return Contact(contact: contact);
                },
              ),
            );
          },
          error: (err, _) => Center(
            child: Text('$err'),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
