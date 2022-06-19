import 'package:chattie/pages/chat_page.dart';
import 'package:chattie/providers/providers.dart';
import 'package:chattie/widgets/messages/message_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatsView extends StatelessWidget {
  const ChatsView({Key? key, required this.previewMessages}) : super(key: key);
  final List<Map>? previewMessages;

  void handleTapOnMessagePreview(
      BuildContext context, Map message, String currentUserUid) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          metadata: message,
          currentUserUid: currentUserUid,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (previewMessages == null) {
      return const Center(
        child: Text('Loading ...'),
      );
    }

    if (previewMessages!.isEmpty) {
      return const Center(
        child: Text('No messages. New messages will appear here.'),
      );
    }
    return ListView.builder(
      itemCount: previewMessages!.length,
      itemBuilder: (context, index) {
        return Consumer(
          builder: (context, ref, _) {
            final currentUserUid = ref.watch(currentUserUidProvider);
            return GestureDetector(
              onTap: () => handleTapOnMessagePreview(
                  context, previewMessages![index], currentUserUid),
              child: MessagePreview(message: previewMessages![index]),
            );
          },
        );
      },
    );
  }
}
