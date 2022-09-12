import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';

class WindowController extends GetxController with WindowListener {
  @override
  void onInit() {
    super.onInit();
    windowManager.addListener(this);
  }

  @override
  void onWindowResize() {
    update();
  }

  @override
  void dispose() {
    super.dispose();
    windowManager.destroy();
  }

  bool isWidthShort300(Size size) => size.width <= 300;
  bool isWidthShort600(Size size) => size.width >= 300 && size.width <= 600;
  bool isWidthShort900(Size size) => size.width >= 600 && size.width <= 900;
  bool isWidthShort1200(Size size) => size.width >= 900 && size.width <= 1200;
  bool isWidthShort1500(Size size) => size.width >= 1200;

  double containerSize(Size size) => isWidthShort300(size)
      ? size.width
      : isWidthShort600(size)
          ? size.width / 2
          : isWidthShort900(size)
              ? size.width / 3
              : isWidthShort1200(size)
                  ? (size.width- 10) / 4
                  : (size.width - 10)/ 5;
}
