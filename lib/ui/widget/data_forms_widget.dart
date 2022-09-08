import 'package:current_data_panel/core/constant/app_keys.dart';
import 'package:flutter/material.dart';

class DataForms extends StatelessWidget {
  DataForms({super.key, this.color, this.validator, this.onSaved});

  Color? color;
  String? Function(String?)? validator;
  Function(String?)? onSaved;

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
                        decoration: formDecoration,
                        cursorColor: Colors.black87,
                        validator: validator,
                        onSaved: onSaved,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
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
                          decoration: colorDecoration(),
                        ),
                      ),
                    )
                  ],
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
                          decoration: colorDecoration(color: Colors.black87),
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
