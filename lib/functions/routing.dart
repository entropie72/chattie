import 'package:chattie/pages/chat_page.dart';
import 'package:flutter/material.dart';

void handleTapOnContact(
    BuildContext context, Map contact, String currentUserUid) {
  final title = (contact['displayName'] as String).isNotEmpty
      ? contact['displayName']
      : '@${contact['username']}';
  final metadata = {
    'avatarUri': contact['avatarUri'],
    'uid': contact['uid'],
    'title': title,
  };
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ChatPage(
        metadata: metadata,
        currentUserUid: currentUserUid,
      ),
    ),
  );
}
