import 'package:current_data_panel/controller/dialog_controller.dart';
import 'package:current_data_panel/core/constant/app_color.dart';
import 'package:current_data_panel/core/constant/app_keys.dart';
import 'package:current_data_panel/core/constant/app_padding.dart';
import 'package:current_data_panel/ui/widget/browse_widget.dart';
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
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                header(size, context),
                const Divider(),
                body(size, context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget formHeader(Size size, BuildContext context, String text) => Text(text,
      style: Theme.of(context)
          .textTheme
          .headline4!
          .copyWith(fontSize: size.longestSide * 0.04));

  Widget header(Size size, BuildContext context) => SizedBox(
        height: size.longestSide * 0.05,
        width: size.width,
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: AppPadding.standartHorizontal(size),
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
        ),
      );

  Widget body(Size size, BuildContext context) => SizedBox(
        height: size.longestSide * 0.75,
        width: size.width,
        child: SingleChildScrollView(
          child: Padding(
            padding: AppPadding.standartHorizontal(size),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: size.height * 0.05),
                formHeader(size, context, AppKeys.sourceFile),
                BrowseWidget()
              ],
            ),
          ),
        ),
      );
}
