import 'package:current_data_panel/controller/data_controller.dart';
import 'package:current_data_panel/core/constant/app_color.dart';
import 'package:current_data_panel/core/constant/app_keys.dart';
import 'package:current_data_panel/core/constant/app_padding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PeriodBox extends StatelessWidget {
  PeriodBox({super.key, this.validator, this.onSaved});

  String? Function(String?)? validator;
  Function(String?)? onSaved;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double boxHeight = size.longestSide * 0.05;
    return SizedBox(
      height: boxHeight,
      width: size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              height: boxHeight,
              decoration: BoxDecoration(
                  color: AppColor.lightGrey,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5.0),
                      bottomLeft: Radius.circular(5.0))),
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: AppPadding.smallHorizontal(size),
                  child: GetBuilder<DataController>(builder: (dtc) {
                    return TextFormField(
                      initialValue: dtc.period != null ? dtc.period.toString() : '',
                      cursorColor: Colors.black54,
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                      validator: validator,
                      onSaved: onSaved,
                    );
                  }),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: boxHeight,
              decoration: BoxDecoration(
                  color: AppColor.blue,
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(5.0),
                      bottomRight: Radius.circular(5.0))),
              child: Align(
                alignment: Alignment.center,
                child: Text(AppKeys.second,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: size.longestSide * 0.02,
                        color: AppColor.white)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
