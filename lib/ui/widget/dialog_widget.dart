import 'package:current_data_panel/controller/data_controller.dart';
import 'package:current_data_panel/controller/dialog_controller.dart';
import 'package:current_data_panel/core/constant/app_color.dart';
import 'package:current_data_panel/core/constant/app_keys.dart';
import 'package:current_data_panel/core/constant/app_padding.dart';
import 'package:current_data_panel/ui/widget/app_button.dart';
import 'package:current_data_panel/ui/widget/browse_widget.dart';
import 'package:current_data_panel/ui/widget/data_forms_widget.dart';
import 'package:current_data_panel/ui/widget/period_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogWidget extends StatelessWidget {
  DialogWidget({super.key});

  final DialogController _dc = Get.find();
  final DataController _dtc = Get.find();

  final _formKey = GlobalKey<FormState>();

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
              borderRadius: BorderRadius.circular(5.0),
              color: AppColor.white,
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26, blurRadius: 1.0, spreadRadius: 1.0)
              ]),
          child: Column(
            children: [
              header(size, context),
              const Divider(),
              body(size, context)
            ],
          ),
        ),
      ),
    );
  }

  Widget formHeader(Size size, BuildContext context, String text) => Text(text,
      style: Theme.of(context)
          .textTheme
          .headline4!
          .copyWith(fontSize: size.longestSide * 0.025, color: AppColor.black));

  Widget header(Size size, BuildContext context) => SizedBox(
        height: size.height * 0.1 - 8,
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
                      .copyWith(fontSize: size.longestSide * 0.03),
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      _dtc.killTemps();
                      _dc.setDialogOpen(false);
                    },
                    splashColor: Colors.transparent,
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
        height: size.height * 0.7 - 8,
        width: size.width,
        child: SingleChildScrollView(
          child: Padding(
            padding: AppPadding.standartHorizontal(size),
            child: Form(
              key: _formKey,
              child: GetBuilder<DataController>(builder: (dtc) {
                return GetBuilder<DialogController>(builder: (dc) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: size.height * 0.01),
                      formHeader(size, context, AppKeys.sourceFile),
                      BrowseWidget(),
                      SizedBox(height: size.height * 0.02),
                      dc.tempLineCount >= 1
                          ? formHeader(size, context, AppKeys.addPeriod)
                          : const SizedBox.shrink(),
                      dc.tempLineCount >= 1
                          ? PeriodBox(
                              validator: (value) {
                                if (value == null) {
                                   Get.snackbar('Geçersiz girdi',
                                      AppKeys.periodValidator1);
                                      return '';
                                }

                                if (value.isEmpty) {
                                  Get.snackbar('Geçersiz girdi',
                                      AppKeys.periodValidator1);
                                      return '';
                                } else if (!RegExp(r'^[0-9]+$')
                                    .hasMatch(value)) {
                                  Get.snackbar('Geçersiz girdi',
                                      AppKeys.periodValidator2);
                                      return '';
                                } else if (int.parse(value) <= 0) {
                                  Get.snackbar('Geçersiz girdi',
                                      AppKeys.periodValidator3);
                                      return '';
                                }
                              },
                              onSaved: (value) {
                                dtc.setPeriod(int.parse(value!));
                              },
                            )
                          : const SizedBox.shrink(),
                      SizedBox(height: size.height * 0.02),
                      dc.tempLineCount >= 1
                          ? Padding(
                              padding: AppPadding.smallHorizontal(size),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: formList(size, dtc, dc),
                              ),
                            )
                          : const SizedBox.shrink(),
                      SizedBox(height: size.height * 0.02),
                      Align(
                          alignment: Alignment.center,
                          child: AppButton(
                            text: AppKeys.save,
                            onPressed: () => validateAndSave(dtc, dc),
                          ))
                    ],
                  );
                });
              }),
            ),
          ),
        ),
      );

  List<Widget> formList(Size size, DataController dtc, DialogController dc) =>
      List.generate(
          dc.tempLineCount,
          (index) => Padding(
                padding: AppPadding.smallVertical(size),
                child: DataForms(
                  index: index,
                  initialValue: dc.tempMapList?[index]['name'] as String?,
                  colorString: dc.tempMapList?[index]['color'] as String?,
                  textColor: dc.tempMapList?[index]['textColor'] as String?,
                  onChanged: (value) {
                    dc.setTempMapListIndexName(index, value);
                  },
                ),
              ));

  validateAndSave(DataController dtc, DialogController dc) async {
    final _isValid = _formKey.currentState!.validate() && dc.tempPath != null;
    if (_isValid) {
      _formKey.currentState!.save();

      _dtc.setLineCountOnly(dc.tempLineCount);
      _dtc.setPathWithoutUpdate(dc.tempPath);
      _dtc.setStorages(dc.tempPath, dtc.period);

      dtc.setTxtDataList();
      _dc.killTempLineWithoutUpdate();

      _dtc.populateMapList();

      _dc.killTempPathWithoutUpdate();

      _dtc.mapToDataKey();
      _dc.setDialogOpen(false);
    }
  }
}
