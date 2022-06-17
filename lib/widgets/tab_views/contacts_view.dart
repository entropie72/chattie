import 'package:chattie/widgets/shared/contact.dart';
import 'package:flutter/material.dart';

class ContactsView extends StatelessWidget {
  const ContactsView({Key? key, required this.contacts}) : super(key: key);
  final List contacts;

  void handleTapOnContact() {}

  @override
  Widget build(BuildContext context) {
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
          return GestureDetector(
            // onTap: () => handleTapOnContact(context, contact),
            child: Contact(contact: contact),
          );
        },
      ),
    );
  }
}
