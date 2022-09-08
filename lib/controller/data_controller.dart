import 'dart:async';
import 'dart:convert';
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
  Rx<String?> _dataString = Rxn();
  RxInt _period = 5.obs;
  Rx<List<String>?> _txtDataList = Rxn();
  Rx<List<Map<String, Object?>>?> _mapList = Rxn();
  Rx<List<Map<String, Object?>>?> _tempMapList = Rxn();
  //Rx<List<Map<String, Object>>?> _tempMapList = Rxn();
  Rx<List<String>?> _tempDataList =
      Rxn(); //txt deki girdilerin değişmedi sırada update edilmemesi için

  String? get path => _path.value;
  String? get dialogPathText => _dialogPathText.value;
  int? get period => _period.value;
  List<Map<String, Object?>>? get mapList => _mapList.value;
  List<Map<String, Object?>>? get tempMapList => _tempMapList.value;
  List<String>? get txtDataList => _txtDataList.value;

  @override
  void onInit() async {
    super.onInit();
    await getPathStorage();
    await getDataStorage();
    readTxtFile();
    populateMapList();
    //storageManager
  }

  @override
  void onReady() {
    super.onReady();
    periodicCheck();
  }

  setPath(String? value) {
    _path.value = value;
    print('_path.value : ${_path.value}');
    update();
  }

  setDataString(String? value) {
    _dataString.value = value;
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

  populateMapList() {
    if (_dataString.value == null) {
      _mapList.value = [];
      update();
      return;
    }

    List<Map<String, Object?>>? jsonObj = [];

    List<String> splittedList = _dataString.value!.split('/');

    for (int i = 0; i < splittedList.length; i++) {
      Map<String, Object?> map = jsonDecode(splittedList[i]);
      jsonObj.add(map);
    }

    _mapList.value = jsonObj;
    update();
  }

  setMapList(List<Map<String, Object>>? mapList) {
    _mapList.value = mapList;
    update();
  }

  setTempMapList(int? index, Map<String, Object> map) {
    _tempMapList.value![index!] = map;
  }

  //form sayfası açıldığında ve kaydetme işleminde
  //setDataStroge ile birlikte çalışacak
  //true -> real = temp
  //false -> temp = real
  synchronizeMapLists(bool value) {
    if (value) {
      _mapList.value = _tempMapList.value;
    } else {
      _tempMapList.value = _mapList.value;
    }
    update();
  }

  //ekle butonuna basıldığında
  addMap() {
    _tempMapList.value ??= [];
    _tempMapList.value!.add({});
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

        _txtDataList.value = txtContent.split(RegExp(r'\s+'));

        if (_tempDataList.value != txtDataList) update();
        _tempDataList.value = txtDataList;
      } catch (e) {
        log('Read Error: $e');
      }
    } else {
      setPathStorage(null);
    }
  }

  String pathKey = 'path';

  getPathStorage() {
    var value = box.read(pathKey);

    if (value == null) return; // || _dc.isDialogOpen

    setPath(value);
    setDialogPath(value);
  }

  String dataKey = 'dataKey';

  getDataStorage() {
    var value = box.read(dataKey);

    if (value == null) return; // || _dc.isDialogOpen

    setDataString(value);
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

  killTempMap() {
    _tempMapList.value?.clear();
    update();
  }

  //tempList null edilmeden önce çalıştır
  //kaydet butonuyla birlikte
  setDataStorage() {
    String text = '';
    for (int i = 0; i < _tempMapList.value!.length; i++) {
      text = text + jsonEncode(_tempMapList.value![i]);
      if (i == _tempMapList.value!.length - 1) continue;
      text = '$text/';
    }

    _dataString.value = text;
    //update();
  }
}
