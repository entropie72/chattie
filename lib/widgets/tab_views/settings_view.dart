import 'package:chattie/providers/providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  void handleSignOut(WidgetRef ref) async {
    await FirebaseAuth.instance.signOut();
    ref.refresh(currentUserUidProvider);
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
                child: Text(userInfo['username']),
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
