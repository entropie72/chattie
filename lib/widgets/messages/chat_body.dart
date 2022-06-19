import 'package:chattie/utils/constants.dart';
import 'package:chattie/widgets/messages/bubble_message.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

Widget getChatBody(List? allMessages) {
  if (allMessages == null) {
    return const Expanded(
      child: Center(
        child: Text('Loading...'),
      ),
    );
  }
  if (allMessages.isEmpty) {
    return const Expanded(
      child: Center(
        child: Text('You don\'t have any chats.'),
      ),
    );
  }
  return Expanded(
      child: GroupedListView(
    elements: allMessages,
    reverse: true,
    order: GroupedListOrder.DESC,
    groupBy: (dynamic message) {
      final datetime = DateTime.parse(message['datetime']);
      return DateTime(datetime.year, datetime.month, datetime.day);
    },
    groupHeaderBuilder: (dynamic message) {
      final datetime = DateTime.parse(message['datetime']);
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        alignment: Alignment.center,
        child: Text(
          DateFormat.MMMd().format(datetime),
          style: const TextStyle(
              color: primaryColor, fontSize: 13, fontWeight: FontWeight.w500),
        ),
      );
    },
    itemBuilder: (context, dynamic message) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Align(
          alignment: (message['isReceived'] as bool)
              ? Alignment.centerLeft
              : Alignment.centerRight,
          child: BubbleMessage(message: message),
        ),
      );
    },
  ));
}
