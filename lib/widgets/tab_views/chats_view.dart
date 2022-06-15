import 'package:chattie/pages/chat_page.dart';
import 'package:chattie/providers/messages_provider.dart';
import 'package:chattie/widgets/messages/message_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatsView extends StatelessWidget {
  const ChatsView({Key? key}) : super(key: key);

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
    return Consumer(
      builder: (context, ref, child) {
        final messages = ref.watch(messagesListProvider);
        return messages.when(
          data: (messages) {
            if (messages.isEmpty) {
              return const Center(
                child: Text('No messages. New messages will appear here.'),
              );
            }
            return ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () =>
                      handleTapOnMessagePreview(context, messages[index]),
                  child: MessagePreview(message: messages[index]),
                );
              },
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
