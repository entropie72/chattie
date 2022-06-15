import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  const MessageModel({
    this.type = 'generic',
    required this.isReceived,
    required this.reactions,
    required this.timestamp,
    required this.content,
  });
  final String type;
  final bool isReceived;
  final dynamic reactions;
  final Timestamp timestamp;
  final String content;
  Map<String, dynamic> getMessage() {
    return {
      'type': type,
      'is_received': isReceived,
      'reactions': reactions,
      'timestamp': timestamp,
      'content': content,
    };
  }
}
