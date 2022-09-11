import 'dart:developer';

import 'package:current_data_panel/controller/data_controller.dart';
import 'package:current_data_panel/controller/dialog_controller.dart';
import 'package:current_data_panel/core/constant/app_color.dart';
import 'package:current_data_panel/core/constant/app_keys.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BrowseWidget extends StatelessWidget {
  BrowseWidget({super.key});

  final DataController _dtc = Get.find();
  final DialogController _dc = Get.find();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double boxHeight = size.longestSide * 0.05;
    return GetBuilder<DataController>(builder: (dtc) {
      return GestureDetector(
        onTap: () {
          _pickFile();
        },
        child: SizedBox(
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
                          child: GetBuilder<DialogController>(
                            builder: (dc) {
                              return Text(dc.tempPath ?? '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          fontSize: size.longestSide * 0.02));
                            }
                          )),
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
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(AppKeys.browse,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  fontSize: size.longestSide * 0.02,
                                  color: AppColor.white)),
                    ),
                  )),
            ],
          ),
        ),
      );
    });
  }

  void _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          dialogTitle: 'Select txt',
          type: FileType.custom,
          allowedExtensions: ['txt']);

      if (result == null) return;

      PlatformFile platformFile = result.files.single;

      //tempPath
      await _dtc.setTempPath(platformFile.path.toString());

      //txtDataList

      //lineCount
      await _dtc.setLineCount(platformFile.path.toString(), false);

      //populateMapList
      _dc.populateTempMapList();

      _dc.setDefaultTempMap();
      

      //kaydet butonunda çalışacak;
      //_app.setStorage(platformFile.path.toString());

      //_dtc.setPath(platformFile.path.toString());

      // _dtc.setDialogPath(platformFile.path.toString());

      // await _dtc.readTxtWhenBrowsing();

      // _dtc.setTempMapListLength();

      log(platformFile.path.toString());
    } catch (e) {
      log('error : $e');
    }
  }
}
