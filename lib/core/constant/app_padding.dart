import 'package:flutter/cupertino.dart';

class AppPadding {
  static EdgeInsets standartPadding(Size size) => EdgeInsets.symmetric(
      horizontal: size.longestSide * 0.02, vertical: size.longestSide * 0.02);
  static EdgeInsets itemStandartPadding(Size size) => EdgeInsets.symmetric(
      horizontal: size.longestSide * 0.005, vertical: size.longestSide * 0.005);  
  static EdgeInsets standartHorizontal(Size size) =>
      EdgeInsets.symmetric(horizontal: size.longestSide * 0.05);
  static EdgeInsets standartVertical(Size size) =>
      EdgeInsets.symmetric(vertical: size.longestSide * 0.05);
}
