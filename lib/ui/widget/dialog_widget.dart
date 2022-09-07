import 'package:current_data_panel/controller/dialog_controller.dart';
import 'package:current_data_panel/core/constant/app_color.dart';
import 'package:current_data_panel/core/constant/app_keys.dart';
import 'package:current_data_panel/core/constant/app_padding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogWidget extends StatelessWidget {
  DialogWidget({super.key});

  final DialogController _dc = Get.find();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      width: size.width,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          height: size.height * 0.8,
          width: size.width * 0.85,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0), color: AppColor.white),
          child: Padding(
            padding: AppPadding.standartHorizontal(size),
            child: Column(
              children: [
                SizedBox(
                  height: size.longestSide * 0.1,
                  width: size.width,
                  child: Align(
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Text(
                          AppKeys.settings,
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(fontSize: size.longestSide * 0.035),
                        ),
                        const Spacer(),
                        IconButton(
                            onPressed: () {
                              _dc.setDialogOpen(false);
                            },
                            icon: Icon(
                              Icons.clear,
                              size: size.longestSide * 0.035,
                            ))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
