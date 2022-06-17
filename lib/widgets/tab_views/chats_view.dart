import 'package:chattie/pages/chat_page.dart';
import 'package:chattie/widgets/messages/message_preview.dart';
import 'package:flutter/material.dart';

class ChatsView extends StatelessWidget {
  const ChatsView({Key? key, required this.previewMessages}) : super(key: key);
  final List<Map>? previewMessages;

  void handleTapOnMessagePreview(BuildContext context, Map message) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          metadata: message,
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
        return GestureDetector(
          onTap: () =>
              handleTapOnMessagePreview(context, previewMessages![index]),
          child: MessagePreview(message: previewMessages![index]),
        );
      },
    );
  }
}
