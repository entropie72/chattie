import 'package:chattie/models/message_model.dart';
import 'package:chattie/providers/providers.dart';
import 'package:chattie/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class TextCompose extends StatelessWidget {
  const TextCompose({Key? key, required this.receiverUid}) : super(key: key);
  final String receiverUid;

  void handleSend(String text, WidgetRef ref) async {
    final currentUserUid = ref.watch(currentUserUidProvider);
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final MessageModel message = MessageModel(
      isReceived: true,
      reactions: [],
      timestamp: Timestamp.fromDate(DateTime.now()),
      content: text,
    );
    await db
        .collection('messages')
        .doc(currentUserUid)
        .collection('all_messages')
        .doc(receiverUid)
        .collection('all_messages')
        .add(message.getMessage());
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController textComposeController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF5F5F5),
              ),
              child: TextField(
                cursorColor: greyTextColor,
                controller: textComposeController,
                maxLines: 5,
                minLines: 1,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(12),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFFC9C9C9),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: primaryColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Consumer(
            builder: (context, ref, child) {
              return GestureDetector(
                onTap: () => handleSend(textComposeController.text, ref),
                child: SvgPicture.asset('assets/icons/filled/send.svg',
                    color: primaryColor),
              );
            },
          ),
        ],
      ),
    );
  }
}
