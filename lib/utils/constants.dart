import 'package:flutter/material.dart';

// Colors
const Color primaryColor = Color(0xFF6667AB);
const Color greyTextColor = Color(0xFF6A6A6A);
const Color dividerColor = Color(0xFFC9C9C9);

// Text
const double footNoteTextSize = 13;
const double calloutTextSize = 16;
const double subHeaderTextSize = 15;
const double bodyTextSize = 17;
const TextStyle title3TextStyle =
    TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
const TextStyle displayNameTextStyle =
    TextStyle(fontSize: 13, fontWeight: FontWeight.w300);

// Type
enum TabItems { contacts, chats, setting }

enum SearchState { beforeSearching, empty, hasResult }

// Layouts
const EdgeInsets appBarPadding =
    EdgeInsets.symmetric(vertical: 12, horizontal: 16);
