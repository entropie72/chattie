import 'package:chattie/utils/constants.dart';
import 'package:chattie/widgets/ui/base_divider.dart';
import 'package:flutter/material.dart';

class Contact extends StatelessWidget {
  const Contact({
    Key? key,
    required this.contact,
  }) : super(key: key);

  final Map contact;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      minVerticalPadding: 0,
      title: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(48),
                  child: Image.network(
                    contact['avatar_uri'],
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '@${contact['username']}',
                      style: const TextStyle(
                          fontSize: bodyTextSize, fontWeight: FontWeight.w600),
                    ),
                    if ((contact['display_name'] as String).isNotEmpty)
                      const SizedBox(
                        height: 2,
                      ),
                    if ((contact['display_name'] as String).isNotEmpty)
                      Text(
                        (contact['display_name'] as String).toUpperCase(),
                        style: displayNameTextStyle,
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            const BaseDivider(),
          ],
        ),
      ),
    );
  }
}
