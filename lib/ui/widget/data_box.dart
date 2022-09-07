import 'package:current_data_panel/controller/window_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DataBox extends StatelessWidget {
  DataBox(
      {super.key,
      required this.color,
      required this.num,
      required this.text,
      required this.textColor});

  //model
  Color color;
  Color textColor;
  String num;
  String text;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double longestSide = size.longestSide;
    return GetBuilder<WindowController>(builder: (wc) {
      return Container(
        height: wc.containerSize(size),
        width: wc.containerSize(size),
        color: color,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(num,
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                      color: textColor, fontSize: longestSide * 0.08)),
              Text(text,
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(color: textColor, fontSize: longestSide * 0.03))
            ],
          ),
        ),
      );
    });
  }
}
