import 'package:chattie/providers/providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  dynamic user = "Hello";
  void handleSignOut(WidgetRef ref) async {
    await FirebaseAuth.instance.signOut();
    ref.refresh(currentUserUidProvider);
  }

  void handleTest(String uid) async {
    final DatabaseReference ref = FirebaseDatabase.instance.ref('users');
    final snapshot = await ref.get();
    print(snapshot.value);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final AsyncValue<Map> userInfo = ref.watch(currentUserInfoProvider);
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            userInfo.when(
              data: (userInfo) => Center(
                child: Row(
                  children: [
                    Text(userInfo['username']),
                    MaterialButton(
                      onPressed: () => handleTest(userInfo['uid']),
                      child: Text(
                        user.toString(),
                      ),
                    ),
                  ],
                ),
              ),
              error: (err, _) => Center(
                child: Text('$err'),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            MaterialButton(
              onPressed: () => handleSignOut(ref),
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }
}
