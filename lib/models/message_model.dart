class MessageModel {
  const MessageModel({
    this.type = 'generic',
    required this.isReceived,
    required this.reactions,
    required this.datetime,
    required this.content,
  });
  final String type;
  final bool isReceived;
  final dynamic reactions;
  final String datetime;
  final String content;
  Map<String, dynamic> getMessage() {
    return {
      'type': type,
      'isReceived': isReceived,
      'reactions': reactions,
      'datetime': datetime,
      'content': content,
    };
  }
}
