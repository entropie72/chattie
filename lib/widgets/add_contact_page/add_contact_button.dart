import 'package:chattie/utils/constants.dart';
import 'package:flutter/material.dart';

class AddContactButton extends StatelessWidget {
  const AddContactButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      decoration: BoxDecoration(
        color: const Color(0x246667AB),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: const [
          Text(
            'Add',
            style: TextStyle(
                color: primaryColor, fontSize: 13, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            width: 2,
          ),
          Icon(
            Icons.add,
            size: 20,
            color: primaryColor,
          ),
        ],
      ),
    );
  }
}
