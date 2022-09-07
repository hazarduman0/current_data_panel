import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:current_data_panel/controller/dialog_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DataController extends GetxController {
  final box = GetStorage();

  final DialogController _dc = Get.find();

  Rx<String?> _path = Rxn();
  Rx<String?> _dialogPathText = Rxn();
  RxInt _period = 5.obs;
  Rx<List<String>?> _dataList = Rxn();
  Rx<List<String>?> _tempDataList = Rxn();

  String? get path => _path.value;
  String? get dialogPathText => _dialogPathText.value;
  int? get period => _period.value;
  List<String>? get dataList => _dataList.value;

  @override
  void onInit() async {
    super.onInit();
    await getPathStorage();
    readTxtFile();
    //storageManager
  }

  @override
  void onReady() {
    super.onReady();
    periodicCheck();
  }

  setPath(String? value) {
    _path.value = value;
    update();
  }

  setDialogPath(String? value) {
    _dialogPathText.value = value;
    update();
  }

  setPeriod(int value) {
    _period.value = value;
    update();
  }

  periodicCheck() {
    Timer.periodic(Duration(seconds: _period.value), (timer) {
      readTxtFile();
    });
  }

  readTxtFile() async {
    if (_path.value == null) return;

    File file = File(_path.value!);

    if (await file.exists()) {
      try {
        var txtContent = await file.readAsString();

        _dataList.value = txtContent.split(RegExp(r'\s+'));

        if (_tempDataList.value != _dataList.value) update();
      } catch (e) {
        log('Read Error: $e');
      }
    } else {setPathStorage(null);
    }

    _tempDataList.value = _dataList.value;
  }

  String pathKey = 'path';

  getPathStorage() {
    var value = box.read(pathKey);

    if (value == null || _dc.isDialogOpen) return;

    setPath(value);
    setDialogPath(value);
  }

  //pathi null yap fonksiyon çalıştıktan sonra
  setPathStorage(String? value) async {
    if (value != null) {
      if (await File(value).exists()) {
        box.write(pathKey, value);
        getPathStorage();
      }
    } else {
      box.remove(pathKey);
      setPath(value);
    }
  }
}
