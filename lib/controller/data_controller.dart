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
  Rx<int?> _period = 5.obs;
  Rx<int> _lineCount = 0.obs;
  Rx<List<String?>?> _txtDataList = Rxn();
  Rx<List<String?>?> _tempTxtDataList = Rxn();
  Rx<List<Map<String, Object?>>?> _mapList = Rxn();

  String? get path => _path.value;
  int? get period => _period.value;
  int get lineCount => _lineCount.value;
  List<String?>? get txtDataList => _txtDataList.value;
  List<Map<String, Object?>>? get mapList => _mapList.value;

  @override
  void onInit() async {
    super.onInit();
    getPathStorage();
    getPeriodStorage();
    dataKeyToMap();
  }

  @override
  void onReady() {
    super.onReady();
    periodicCheck();
  }

  periodicCheck() {
    Timer.periodic(Duration(seconds: _period.value!), (timer) async {
      if (_path.value == null) return;

      File file = File(_path.value!);

      if (await file.exists()) {
        try {
          _txtDataList.value = await getTxtDataList(_path.value);
          setLineCount(_path.value, true);

          if ((_txtDataList.value != _tempTxtDataList.value) &&
              !_dc.isDialogOpen) {
            update();
            log('update!!');
          }

          _tempTxtDataList.value = _txtDataList.value;
        } catch (e) {
          log('Periodic Check Error: $e');
        }
      } else {
        terminateMapList();
        setPath(null);
        setDataKey(null);
      }
    });
  }

  readTxtWithoutUpdate(String pathValue) async {
    _txtDataList.value = await getTxtDataList(pathValue);
  }

  syncMapLists() {
    _dc.syncMapLists(_mapList.value);
  }

  setPath(String? value) {
    _path.value = value;
    update();
  }

  setPathWithoutUpdate(String? value) {
    _path.value = value;
  }

  setPeriod(int? value) {
    _period.value = value;
    update();
  }

  tempToPrime() {
    _path.value = _dc.tempPath;
    _lineCount.value = _dc.tempLineCount;
  }

  String pathKey = 'pathKey';
  String periodKey = 'periodKey';
  String dataKey = 'dataKey';

  getPathStorage() {
    var value = box.read(pathKey);

    if (value == null) return;

    setPath(value);
  }

  getPeriodStorage() {
    var value = box.read(periodKey);

    if (value == null) return;

    setPeriod(value);
  }

  getDataKeyString() {
    var value = box.read(dataKey);

    if (value != null) return value;

    return null;
  }

  dataKeyToMap() {
    var dataKey = getDataKeyString();

    if (dataKey == null) return;

    List<Map<String, Object?>>? jsonObj = [];

    List<String> splittedList = dataKey.split('/');

    for (var splitted in splittedList) {
      Map<String, Object?> map = jsonDecode(splitted);
      jsonObj.add(map);
    }

    _mapList.value = jsonObj;
    update();
  }

  mapToDataKey() {
    String text = '';
    for (int i = 0; i < _mapList.value!.length; i++) {
      text = text + jsonEncode(_mapList.value![i]);
      if (i == _mapList.value!.length - 1) continue;
      text = '$text/';
    }
    setDataKey(text);
  }

  setStorages(String? pathValue, int? periodValue) {
    box.write(pathKey, pathValue);
    box.write(periodKey, periodValue);
  }

  setPathKey(String? pathValue) {
    box.write(pathKey, pathValue);
  }

  setDataKey(String? dataValue) {
    box.write(dataKey, dataValue);
  }

  populateMapList() {
    _mapList.value = _dc.tempMapList;
  }

  terminateMapList() {
    _mapList.value = null;
    update();
  }

  setTempPath(String? value) {
    _dc.setTempPath(value);

  }


  Future<List<String>?> getTxtDataList(String? path) async {
    if (path == null) return null;

    File file = File(path);

    if (await file.exists()) {
      try {
        var txtContent = await file.readAsString();

        return txtContent.split(RegExp(r'\s+'));
      } catch (e) {
        log('Read Error: $e');
      }
    }

    return null;
  }

  setTxtDataList() async {
    _txtDataList.value = await getTxtDataList(_dc.tempPath);
  }

  setLineCount(String? path, bool bool) async {
    if (bool) {
      _lineCount.value = (await getTxtDataList(path))!.length;
    } else {
      _dc.setTempLineCount((await getTxtDataList(path))!.length);
    }
  }

  setTempLineCount(int value) {
    _dc.setTempLineCount(value);
  }

  setTempLineZero() {
    _dc.setTempLineCount(0);
    update();
  }

  setLineCountOnly(int value) {
    _lineCount.value = value;
  }

  killTemps() {
    _dc.setTempPath(null);
    _dc.setTempLineCount(0);
  }
}
