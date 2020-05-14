import 'package:flutter/material.dart';

class ResponsiveTheme {
  final Size mediaSize;
  ResponsiveTheme(Size size) : mediaSize = size;

  double get headline1 => mediaSize.height / 1000 * 40;
  double get headline2 => mediaSize.height / 1000 * 35;
  double get subtitle1 => mediaSize.height / 1000 * 30;
  double get subtitle2 => mediaSize.height / 1000 * 27;
  double get body1 => mediaSize.height / 1000 * 24;
  double get body2 => mediaSize.height / 1000 * 21;
  double get caption => mediaSize.height / 1000 * 18;
  double get overline => mediaSize.height / 1000 * 14;

  double get ruleBox => mediaSize.height / 1000 * 60;
  double get historyBox => mediaSize.height / 1000 * 80;
}
