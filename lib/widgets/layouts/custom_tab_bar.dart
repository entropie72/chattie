import 'package:chattie/utils/constants.dart';
import 'package:chattie/widgets/ui/base_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar(
      {Key? key, required this.currentTab, required this.selectTab})
      : super(key: key);
  final TabItems currentTab;
  final Function(TabItems) selectTab;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const BaseDivider(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 48),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => selectTab(TabItems.contacts),
                child: SvgPicture.asset(
                  'assets/icons/${currentTab == TabItems.contacts ? 'filled' : 'linear'}/contacts.svg',
                ),
              ),
              GestureDetector(
                onTap: () => selectTab(TabItems.chats),
                child: SvgPicture.asset(
                  'assets/icons/${currentTab == TabItems.chats ? 'filled' : 'linear'}/chats.svg',
                ),
              ),
              GestureDetector(
                onTap: () => selectTab(TabItems.setting),
                child: SvgPicture.asset(
                  'assets/icons/${currentTab == TabItems.setting ? 'filled' : 'linear'}/setting.svg',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
