import 'package:chattie/providers/providers.dart';
import 'package:chattie/utils/constants.dart';
import 'package:chattie/widgets/add_contact_page/add_contact_button.dart';
import 'package:chattie/widgets/ui/base_divider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Contact extends StatefulWidget {
  const Contact({
    Key? key,
    required this.contact,
  }) : super(key: key);

  final Map contact;

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  bool? isExistInContacts;
  @override
  void initState() {
    super.initState();
    isExistInContacts = widget.contact['isExistInContacts'];
  }

  void handleAddToContact(String currentUserUid) async {
    final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
    final snapshot = await dbRef.child('contacts/$currentUserUid').get();
    final newContactsList = snapshot.exists
        ? [...(snapshot.value as List), widget.contact['uid']]
        : [widget.contact['uid']];
    await dbRef.child('contacts/$currentUserUid').set(newContactsList);
    setState(() {
      isExistInContacts = true;
    });
  }

  Widget getRightActionWidget(String currentUserUid) {
    if (currentUserUid == widget.contact['uid']) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        decoration: BoxDecoration(
          color: const Color(0x246667AB),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Text(
          'You',
          style: TextStyle(
              color: primaryColor, fontSize: 13, fontWeight: FontWeight.w500),
        ),
      );
    }
    if (isExistInContacts!) {
      return const Icon(
        Icons.contacts,
        size: 16,
        color: primaryColor,
      );
    }
    return GestureDetector(
      onTap: () => handleAddToContact(currentUserUid),
      child: const AddContactButton(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      minVerticalPadding: 0,
      title: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Column(
          children: [
            Consumer(
              builder: (context, ref, _) {
                final String currentUserUid = ref.watch(currentUserUidProvider);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(48),
                          child: Image.network(
                            widget.contact['avatarUri'],
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '@${widget.contact['username']}',
                              style: const TextStyle(
                                  fontSize: bodyTextSize,
                                  fontWeight: FontWeight.w600),
                            ),
                            if ((widget.contact['displayName'] as String)
                                .isNotEmpty)
                              const SizedBox(
                                height: 2,
                              ),
                            if ((widget.contact['displayName'] as String)
                                .isNotEmpty)
                              Text(
                                (widget.contact['displayName'] as String)
                                    .toUpperCase(),
                                style: displayNameTextStyle,
                              ),
                          ],
                        ),
                      ],
                    ),
                    if (widget.contact['isExistInContacts'] != null)
                      getRightActionWidget(currentUserUid),
                  ],
                );
              },
            ),
            const SizedBox(
              height: 12,
            ),
            const BaseDivider(),
          ],
        ),
      ),
    );
  }
}
