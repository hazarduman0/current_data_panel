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
                      _dtc.killTempMap();
                      print(_dtc.tempMapList);
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
            child: Form(
              key: _formKey,
              child: GetBuilder<DataController>(builder: (dtc) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.height * 0.05),
                    formHeader(size, context, AppKeys.sourceFile),
                    BrowseWidget(),
                    SizedBox(height: size.height * 0.05),
                    formHeader(size, context, AppKeys.addPeriod),
                    PeriodBox(
                      validator: (value) {},
                      onSaved: (value) {
                        dtc.setPeriod(int.parse(value!));
                      },
                    ),
                    SizedBox(height: size.height * 0.05),
                    dtc.tempMapList!.isNotEmpty /////////////////////////
                        ? Padding(
                            padding: AppPadding.smallHorizontal(size),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: formList(size, dtc),
                            ),
                          )
                        : const SizedBox.shrink(),
                    SizedBox(height: size.height * 0.02),
                    addButton,
                    SizedBox(height: size.height * 0.02),
                    Align(
                        alignment: Alignment.center,
                        child: AppButton(
                          text: AppKeys.save,
                          onPressed: () => validateAndSave(),
                        ))
                  ],
                );
              }),
            ),
          ),
        ),
      );

  Widget get addButton => TextButton(
      onPressed: () {
        _dtc.addMap();
      },
      child: Text('+ ${AppKeys.add}'));

  List<Widget> formList(Size size, DataController dtc) => List.generate(
      dtc.tempMapList!.length,
      (index) => Padding(
            padding: AppPadding.smallVertical(size),
            child: DataForms(
              validator: (value) {
                if (value!.isEmpty) {
                  return;
                }
              },
              onSaved: (value) {
                dtc.setTempMapList(index, {
                  'name': value!,
                  'color': 'color',
                  'textColor': 'textColor'
                });
              },
            ),
          ));

  validateAndSave() {
    final _isValid = _formKey.currentState!.validate();
    if (_isValid) {
      _formKey.currentState!.save();
      _dtc.synchronizeMapLists(true);
      _dtc.setDataStorage();
      _dtc.killTempMap();
      _dc.setDialogOpen(false);
    }
  }
}
