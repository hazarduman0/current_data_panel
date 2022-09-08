import 'package:current_data_panel/core/constant/app_color.dart';
import 'package:current_data_panel/core/constant/app_keys.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  AppButton({super.key, required this.text, this.onPressed});

  String text;
  Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.07,
      width: size.width * 0.7,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 0.0, backgroundColor: AppColor.blue),
        onPressed: onPressed,
        child: Center(
            child: Text(AppKeys.save,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: size.longestSide * 0.02, color: AppColor.white))),
      ),
    );
  }
}
