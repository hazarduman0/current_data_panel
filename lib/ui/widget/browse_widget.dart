import 'package:current_data_panel/controller/data_controller.dart';
import 'package:current_data_panel/core/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BrowseWidget extends StatelessWidget {
  const BrowseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double boxHeight = size.longestSide * 0.05;
    return GetBuilder<DataController>(builder: (dtc) {
      return SizedBox(
        height: boxHeight,
        width: size.width,
        child: Row(
          children: [
            Expanded(
                flex: 3,
                child: Container(
                  height: boxHeight,
                  decoration: BoxDecoration(
                    color: AppColor.lightGrey,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(5.0),
                        bottomLeft: Radius.circular(5.0)),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(dtc.path ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontSize: size.longestSide * 0.04))),
                  ),
                )),
            Expanded(
                flex: 1,
                child: Container(
                  height: boxHeight,
                  decoration: BoxDecoration(
                    color: AppColor.blue,
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(5.0),
                        bottomRight: Radius.circular(5.0)),
                  ),
                )),
          ],
        ),
      );
    });
  }
}
