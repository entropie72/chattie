import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final FirebaseFirestore _db = FirebaseFirestore.instance;

final currentUserUidProvider = StateProvider<String>((ref) {
  return FirebaseAuth.instance.currentUser?.uid ?? '';
});

final currentUserInfoProvider = FutureProvider<Map>((ref) async {
  final String currentUserUid =
      ref.watch(currentUserUidProvider.notifier).state;
  if (currentUserUid.isEmpty) return {};
  final DocumentSnapshot snapshot =
      await _db.collection('users').doc(currentUserUid).get();
  return snapshot.data() as Map;
});

final currentUserContactsProvider = FutureProvider<List<Map>>((ref) async {
  final String currentUserUid =
      ref.watch(currentUserUidProvider.notifier).state;

  if (currentUserUid.isEmpty) return [];

  final DocumentSnapshot snapshot =
      await _db.collection('contacts').doc(currentUserUid).get();
  final List contactsList = (snapshot.data() as Map)['contacts'];

  List<Map> contactsWithContactInfo = [];

  for (String contact in contactsList) {
    final DocumentSnapshot snapshot =
        await _db.collection('users').doc(contact).get();
    contactsWithContactInfo.add(snapshot.data() as Map);
  }

  return contactsWithContactInfo;
});
