import 'package:current_data_panel/controller/data_controller.dart';
import 'package:current_data_panel/core/constant/app_color.dart';
import 'package:current_data_panel/core/constant/app_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class ItemInputWidget extends StatelessWidget {
  const ItemInputWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.longestSide * 0.25,
      width: size.longestSide * 0.8,
      decoration: BoxDecoration(
          color: AppColor.white, borderRadius: BorderRadius.circular(5.0)),
      child: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: AppPadding.standartHorizontal(size),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Align(
                    alignment: Alignment.center, child: browseWidget(size)),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  children: [],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget browseWidget(Size size) => GetBuilder<DataController>(builder: (dtc) {
        return GestureDetector(
          onTap: () {},
          child: Row(
            children: [
              Expanded(
                  flex: 4,
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColor.white,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(5.0),
                            bottomLeft: Radius.circular(5.0))),
                  )),
              Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColor.blue,
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(5.0),
                            bottomRight: Radius.circular(5.0))),
                  )),
            ],
          ),
        );
      });
}
