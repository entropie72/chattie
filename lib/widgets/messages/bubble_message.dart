import 'package:chattie/utils/constants.dart';
import 'package:flutter/material.dart';

class BubbleMessage extends StatelessWidget {
  const BubbleMessage({Key? key, required this.message}) : super(key: key);
  final dynamic message;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        constraints: BoxConstraints(maxWidth: 0.6 * screenWidth),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
        decoration: BoxDecoration(
          color: (message['is_received'] as bool)
              ? greyBackgroundColor
              : primaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Text(
          message['content'],
          style: TextStyle(
            color:
                (message['is_received'] as bool) ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }
}
