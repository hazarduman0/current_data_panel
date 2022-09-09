import 'package:current_data_panel/controller/dialog_controller.dart';
import 'package:current_data_panel/core/constant/app_color.dart';
import 'package:current_data_panel/core/constant/app_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';

class DataForms extends StatelessWidget {
  DataForms(
      {super.key,
      this.index,
      this.colorString,
      this.validator,
      this.onSaved,
      this.initialValue,
      this.textColor});

  int? index;
  String? initialValue;
  String? colorString;
  String? textColor;
  String? Function(String?)? validator;
  Function(String?)? onSaved;

  final DialogController _dc = Get.find();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height * 0.1;
    double formHeight = height * 0.5;
    double eachColumnWidth = size.width * 0.1;
    return SizedBox(
      height: height,
      width: size.width,
      child: Align(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: height,
                width: eachColumnWidth,
                child: Column(
                  children: [
                    Text(
                      AppKeys.dataName,
                      style: textStyle(context, size),
                    ),
                    SizedBox(
                      height: formHeight,
                      width: eachColumnWidth,
                      child: TextFormField(
                        initialValue: initialValue ?? '',
                        decoration: formDecoration,
                        cursorColor: Colors.black87,
                        validator: validator,
                        onSaved: onSaved,
                      ),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => pickColor(context),
                child: SizedBox(
                  height: height,
                  width: eachColumnWidth,
                  child: Column(
                    children: [
                      Text(AppKeys.color, style: textStyle(context, size)),
                      Container(
                        height: formHeight,
                        width: eachColumnWidth,
                        decoration: boxDecoration,
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            height: formHeight * 0.8,
                            width: eachColumnWidth * 0.9,
                            decoration: colorDecoration(color: colorString != null ? Color(int.parse(colorString!, radix: 16)) : AppColor.blue),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height,
                width: eachColumnWidth,
                child: Column(
                  children: [
                    Text(AppKeys.textColor, style: textStyle(context, size)),
                    Container(
                      height: formHeight,
                      width: eachColumnWidth,
                      decoration: boxDecoration,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: formHeight * 0.8,
                          width: eachColumnWidth * 0.9,
                          decoration: colorDecoration(color: textColor != null ? Color(int.parse(textColor!, radix: 16)) : AppColor.black),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }

  void pickColor(BuildContext context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Pick Your Color'),
          content: Column(
            children: [
              builColorPicker(),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Select')),
            ],
          ),
        ),
      );

  Widget builColorPicker() => ColorPicker(
        pickerColor: AppColor.blue,
        onColorChanged: (value) {
          final grayscale = (0.299 * value.red) +
              (0.587 * value.green) +
              (0.114 * value.blue);
          _dc.setMapIndexColor(index!, value.value.toRadixString(16));
          _dc.setMapIndexTextColor(
              index!,
              grayscale > 128
                  ? Colors.black.value.toRadixString(16)
                  : Colors.white.value.toRadixString(16));
        },
      );

  BoxDecoration colorDecoration({Color? color = Colors.blue}) => BoxDecoration(
        borderRadius: formRadius,
        color: color,
      );

  InputDecoration get formDecoration => InputDecoration(
      enabledBorder: outLineInputBorder, focusedBorder: outLineInputBorder);

  BoxDecoration get boxDecoration => BoxDecoration(
      borderRadius: formRadius,
      border: Border.all(
        color: Colors.black54,
        width: 1.0,
      ));

  OutlineInputBorder get outLineInputBorder => OutlineInputBorder(
      borderRadius: formRadius,
      borderSide: const BorderSide(
        color: Colors.black54,
        width: 1.0,
      ));

  BorderRadius get formRadius => const BorderRadius.all(Radius.circular(4.0));

  TextStyle textStyle(BuildContext context, Size size) => Theme.of(context)
      .textTheme
      .bodyMedium!
      .copyWith(fontSize: size.longestSide * 0.015);
}
