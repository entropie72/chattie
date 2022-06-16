import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final DatabaseReference dbRef = FirebaseDatabase.instance.ref();

final currentUserUidProvider = StateProvider<String>((ref) {
  return FirebaseAuth.instance.currentUser?.uid ?? '';
});

final currentUserInfoProvider = FutureProvider<Map>((ref) async {
  final String currentUserUid =
      ref.watch(currentUserUidProvider.notifier).state;
  if (currentUserUid.isEmpty) return {};
  final snapshot = await dbRef.child('users/$currentUserUid').get();
  return snapshot.exists ? snapshot.value as Map : {};
});
