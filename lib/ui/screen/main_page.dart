import 'dart:developer';

import 'package:current_data_panel/controller/data_controller.dart';
import 'package:current_data_panel/controller/dialog_controller.dart';
import 'package:current_data_panel/core/constant/app_color.dart';
import 'package:current_data_panel/core/constant/app_keys.dart';
import 'package:current_data_panel/ui/widget/data_box.dart';
import 'package:current_data_panel/ui/widget/dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});

  final DialogController _dc = Get.find();
  final DataController _dtc = Get.find();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    log('width: ${size.width}');
    return Scaffold(
      body: GetBuilder<DataController>(builder: (dtc) {
        return Stack(
          children: [
            SizedBox(
              height: size.height,
              width: size.width,
              child: dtc.path != null
                  ? SingleChildScrollView(
                      child: Wrap(
                        children: generateGrid(size, dtc),
                      ),
                    )
                  : Center(child: Text(AppKeys.pickTxtFile)),
            ),
            GetBuilder<DialogController>(builder: (dc) {
              return dc.isDialogOpen ? DialogWidget() : const SizedBox.shrink();
            })
          ],
        );
      }),
      floatingActionButton: floatingButton(size),
    );
  }

  List<Widget> generateGrid(Size size, DataController dtc) => List.generate(
      dtc.lineCount,
      (index) => DataBox(
            color: Color(
                int.parse(dtc.mapList![index]['color'] as String, radix: 16)),
            num: dtc.txtDataList![index]!,
            text: dtc.mapList![index]['name'] as String,
            textColor: Color(int.parse(
                dtc.mapList![index]['textColor'] as String,
                radix: 16)),
          ));

  Widget floatingButton(Size size) =>
      GetBuilder<DataController>(builder: (dtc) {
        return GestureDetector(
          onTap: () {
            if (dtc.path != null) {
              dtc.setTempPath(dtc.path);
              dtc.setLineCount(dtc.path, false);
              dtc.syncMapLists();
            }
            _dc.setDialogOpen(true);
          },
          child: Container(
            height: size.longestSide * 0.05,
            width: size.longestSide * 0.05,
            decoration: BoxDecoration(
                color: AppColor.grey,
                borderRadius: BorderRadius.circular(10.0)),
            child: Align(
              alignment: Alignment.center,
              child: Icon(Icons.settings,
                  color: AppColor.white, size: size.longestSide * 0.03),
            ),
          ),
        );
      });
}
