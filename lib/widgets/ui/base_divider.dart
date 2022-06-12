import 'package:chattie/utils/constants.dart';
import 'package:flutter/material.dart';

class BaseDivider extends StatelessWidget {
  const BaseDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 0.5,
      color: dividerColor,
    );
  }
}
