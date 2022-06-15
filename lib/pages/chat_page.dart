import 'package:chattie/providers/providers.dart';
import 'package:chattie/utils/constants.dart';
import 'package:chattie/widgets/messages/bubble_message.dart';
import 'package:chattie/widgets/messages/text_compose.dart';
import 'package:chattie/widgets/ui/base_divider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key, required this.metadata}) : super(key: key);
  final Map metadata;

  Future getChatMessages(String currentUserUid) async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db
        .collection('messages')
        .doc(currentUserUid)
        .collection('all_messages')
        .doc(metadata['uid'])
        .collection('all_messages')
        .orderBy('timestamp')
        .get();

    return snapshot.docs;
  }

  void handleBackToContacts(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: appBarPadding,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => handleBackToContacts(context),
                    child: SvgPicture.asset(
                      'assets/icons/linear/left_arrow.svg',
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(48),
                    child: Image.network(
                      metadata['avatar_uri'],
                      width: 36,
                      height: 36,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    metadata['title'],
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 15),
                  ),
                ],
              ),
            ),
            const BaseDivider(),
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  final String currentUserUid =
                      ref.watch(currentUserUidProvider);
                  return FutureBuilder(
                    future: getChatMessages(currentUserUid),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final chatMessagesList = snapshot.data as List;
                        return GroupedListView(
                          elements: chatMessagesList,
                          reverse: true,
                          order: GroupedListOrder.DESC,
                          groupBy: (dynamic message) {
                            final datetime =
                                DateTime.fromMillisecondsSinceEpoch(
                                    message['timestamp'].seconds * 1000);
                            return DateTime(
                                datetime.year, datetime.month, datetime.day);
                          },
                          groupHeaderBuilder: (dynamic message) {
                            final datetime =
                                DateTime.fromMillisecondsSinceEpoch(
                                    message['timestamp'].seconds * 1000);
                            return Container(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              alignment: Alignment.center,
                              child: Text(
                                DateFormat.MMMd().format(datetime),
                                style: const TextStyle(
                                    color: primaryColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500),
                              ),
                            );
                          },
                          itemBuilder: (context, dynamic message) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Align(
                                alignment: (message['is_received'] as bool)
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                                child: BubbleMessage(message: message),
                              ),
                            );
                          },
                        );
                      }
                      return const Text('Loading');
                    },
                  );
                },
              ),
            ),
            TextCompose(receiverUid: metadata['uid']),
          ],
        ),
      ),
    );
  }
}
