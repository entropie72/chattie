import 'package:chattie/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatsView extends StatelessWidget {
  const ChatsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final AsyncValue<Map> userInfo = ref.watch(currentUserInfoProvider);
        return userInfo.when(
          data: (userInfo) => Center(
            child: Text(userInfo.toString()),
          ),
          error: (err, _) => Center(
            child: Text('$err'),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
