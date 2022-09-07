import 'dart:developer';

import 'package:current_data_panel/controller/dialog_controller.dart';
import 'package:current_data_panel/core/constant/app_color.dart';
import 'package:current_data_panel/ui/widget/data_box.dart';
import 'package:current_data_panel/ui/widget/dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});

  final DialogController _dc = Get.find();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    log('width: ${size.width}');
    return Scaffold(
      body: GetBuilder<DialogController>(builder: (dc) {
        return Stack(
          children: [
            SizedBox(
              height: size.height,
              width: size.width,
              child: SingleChildScrollView(
                child: Wrap(
                  children: generateGrid(size),
                ),
              ),
            ),
            dc.isDialogOpen ? DialogWidget() : const SizedBox.shrink()
          ],
        );
      }),
      floatingActionButton: floatingButton(size),
    );
  }

  List<Widget> generateGrid(Size size) => List.generate(
      20,
      (index) => DataBox(
          color: Colors.red,
          num: '10',
          text: 'Product',
          textColor: Colors.white));

  Widget floatingButton(Size size) => GestureDetector(
        onTap: () {
          _dc.setDialogOpen(true);
        },
        child: Container(
          height: size.longestSide * 0.05,
          width: size.longestSide * 0.05,
          decoration: BoxDecoration(
              color: AppColor.grey, borderRadius: BorderRadius.circular(10.0)),
          child: Align(
            alignment: Alignment.center,
            child: Icon(Icons.settings,
                color: AppColor.white, size: size.longestSide * 0.03),
          ),
        ),
      );
}
