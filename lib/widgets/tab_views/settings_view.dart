import 'package:chattie/providers/providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingViews extends StatefulWidget {
  const SettingViews({Key? key}) : super(key: key);

  @override
  State<SettingViews> createState() => _SettingViewsState();
}

class _SettingViewsState extends State<SettingViews> {
  void handleLogOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final currentUserInfo = ref.watch(currentUserInfoProvider);
        return Column(
          children: [
            currentUserInfo.when(
              loading: () => const CircularProgressIndicator(),
              error: (err, _) => Text(
                err.toString(),
              ),
              data: (data) {
                return Text(data['username']);
              },
            ),
            MaterialButton(
              onPressed: () => handleLogOut(),
              child: const Text('Log Out'),
            ),
          ],
        );
      },
    );
  }
}
