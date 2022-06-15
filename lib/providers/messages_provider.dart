import 'package:chattie/providers/providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final FirebaseFirestore _db = FirebaseFirestore.instance;

final messagesListProvider = FutureProvider<List>((ref) async {
  String currentUserUid = ref.watch(currentUserUidProvider.notifier).state;
  List<Map<String, dynamic>> messagesList = [];
  final QuerySnapshot snapshot = await _db
      .collection('messages')
      .doc(currentUserUid)
      .collection('messages_list')
      .get();

  for (var element in snapshot.docs) {
    final DocumentSnapshot snapshot =
        await _db.collection('users').doc(element.id).get();
    final Map user = snapshot.data() as Map;
    final Map<String, dynamic> messagePreview = {
      'avatar_uri': user['avatar_uri'],
      'title': (user['display_name'] as String).isNotEmpty
          ? user['display_name']
          : '@${user['username']}',
      ...element.data() as Map,
    };
    messagesList.add(messagePreview);
  }

  return messagesList;
});
