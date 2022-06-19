import 'package:chattie/utils/constants.dart';
import 'package:chattie/widgets/messages/chat_body.dart';
import 'package:chattie/widgets/messages/text_compose.dart';
import 'package:chattie/widgets/ui/base_divider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatPage extends StatefulWidget {
  const ChatPage(
      {Key? key, required this.metadata, required this.currentUserUid})
      : super(key: key);
  final Map metadata;
  final String currentUserUid;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List? allMessages;
  @override
  void initState() {
    super.initState();
    getChatMessages(widget.currentUserUid);
  }

  Future getChatMessages(String currentUserUid) async {
    final dbRef = FirebaseDatabase.instance.ref();
    dbRef
        .child('messages/allMessages/$currentUserUid/${widget.metadata['uid']}')
        .orderByValue()
        .onValue
        .listen((event) {
      if (mounted) {
        List allMessagesSorted = [];
        if (event.snapshot.exists) {
          final allMessagesKeysSorted =
              (event.snapshot.value as Map).keys.toList()..sort();
          for (String key in allMessagesKeysSorted) {
            allMessagesSorted.add((event.snapshot.value as Map)[key]);
          }
        }

        setState(() {
          allMessages = allMessagesSorted;
        });
      }
    });
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
                      widget.metadata['avatarUri'],
                      width: 36,
                      height: 36,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.metadata['title'],
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 15),
                  ),
                ],
              ),
            ),
            const BaseDivider(),
            getChatBody(allMessages),
            const BaseDivider(),
            TextCompose(receiverUid: widget.metadata['uid']),
          ],
        ),
      ),
    );
  }
}
