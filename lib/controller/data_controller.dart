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
  //Rx<String?> _tempPath = Rxn();
  //Rx<String?> _dataString = Rxn();
  //Rx<String?> _storageDataString = Rxn();
  Rx<int?> _period = 5.obs;
  Rx<int> _lineCount = 0.obs;
  //Rx<int> _tempLineCount = 0.obs;
  Rx<List<String?>?> _txtDataList = Rxn();
  Rx<List<String?>?> _tempTxtDataList = Rxn();
  Rx<List<Map<String, Object?>>?> _mapList = Rxn();

  String? get path => _path.value;
  // String? get tempPath => _tempPath.value;
  int? get period => _period.value;
  int get lineCount => _lineCount.value;
  // int get tempLineCount => _tempLineCount.value;
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
    //periodicCheck();
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
        //storageleri sıfırla
        //setStorages(null, null);
        terminateMapList();
        setPath(null);
        setDataKey(null);
      }
    });
  }

  // Timer.periodic(Duration(seconds: _period.value!), (timer) async {
  //     var txtFunc = await getTxtDataList(_path.value);
  //     if (_txtDataList.value != txtFunc) {
  //       _txtDataList.value = txtFunc;
  //       setLineCount(_path.value, true);
  //     }
  //   });

  syncMapLists(){
    _dc.syncMapLists(_mapList.value);
  }

  setPath(String? value) {
    //bunu validatedeki parametre ile dene, olmazsa özel metot oluştur
    _path.value = value;
    update();
  }

  setPathWithoutUpdate(String? value){
    _path.value = value;
  }

  setPeriod(int? value) {
    _period.value = value;
    update();
  }

  tempToPrime() {
    _path.value = _dc.tempPath;
    _lineCount.value = _dc.tempLineCount;
    // _path.value = _tempPath.value;
    // _lineCount.value = _tempLineCount.value;
    //update();
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

  //GET DATA STORAGE

  //uygulama açıldığında çalışacak
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

  //yalnızca kaydedilirken çalışacak
  mapToDataKey() {
    String text = '';
    for (int i = 0; i < _mapList.value!.length; i++) {
      text = text + jsonEncode(_mapList.value![i]);
      if (i == _mapList.value!.length - 1) continue;
      text = '$text/';
    }
    setDataKey(text);
  }

  //storage
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

  //txt seçildiğinde
  populateMapList() {
    _mapList.value = _dc.tempMapList;
    // _mapList.value = [];

    // for (int i = 0; i < _dc.tempLineCount; i++) { //_tempLineCount.value
    //   _mapList.value!.add({});
    // }
    // print('object');
  }

  terminateMapList(){
    _mapList.value = null;
      update();
    
  }

  //setMapIndexName(int index, String? value)
  //setMapIndexColor(int index, String? value)
  //setMapIndexTextColor(int index, String? value)

  //butona her basışta çalıştırma fikri çalışmazsa, farklı mapte tuttuğun bilgiyi save de asıl mape aktarmayı dene
  //data stringini storageye kaydetmeyi unutma

  setMapListIndexValue(int index, Map<String, Object> map) {
    _mapList.value![index] = map;
    //update();

    // final mod = index % 3;

    // switch (mod) {
    //   case 0:
    //     {
    //       _mapList.value![index]['name'] = value;
    //     }
    //     break;

    //   case 1:
    //     {
    //       _mapList.value![index]['color'] = value;
    //     }
    //     break;

    //   case 3:
    //     {
    //       _mapList.value![index]['textColor'] = value;
    //     }
    //     break;
    //   default:
    //     {
    //       log('Map list index value error');
    //     }
    //     break;
    // }

    // if (index % 3 == 0) {
    //   _mapList.value![index]['name'] = value;
    // } else if (index % 3 == 1) {
    //   _mapList.value![index]['color'] = value;
    // } else if (index % 3 == 2) {
    //   _mapList.value![index]['textColor'] = value;
    // }
  }

  // tempToPath() {
  //   _path.value = _tempPath.value;
  //   update();
  // }

  // tempToLine() {}

  setTempPath(String? value) {
    _dc.setTempPath(value);
    //_tempPath.value = value;
    //update();
  }

  Future<List<String>?> getTxtDataList(String? path) async {
    if (path == null) return null;

    File file = File(path);

    if (await file.exists()) {}
    try {
      var txtContent = await file.readAsString();
      return txtContent.split(RegExp(r'\s+'));
    } catch (e) {
      log('Read Error: $e');
    }
    return null;
  }

  setTxtDataList() async {
    _txtDataList.value = await getTxtDataList(_dc.tempPath);
    //update();
  }

  //true -> periodta
  //false -> browse
  setLineCount(String? path, bool bool) async {
    if (bool) {
      _lineCount.value = (await getTxtDataList(path))!.length;
    } else {
      _dc.setTempLineCount((await getTxtDataList(path))!.length);
      //_tempLineCount.value = (await getTxtDataList(path))!.length;
    }
    //update();
    //kaydet line = temp
  }

  //ayarlar açılırken çalışır
  setTempLineCount(int value) {
    _dc.setTempLineCount(value);
    //_tempLineCount.value = value;
  }

  setTempLineZero() {
    _dc.setTempLineCount(0);
    //_tempLineCount.value = 0;
    update();
  }

  setLineCountOnly(int value){
    _lineCount.value = value;
  }

  killTemps() {
    _dc.setTempPath(null);
    _dc.setTempLineCount(0);
    // _tempPath.value = null;
    // _tempLineCount.value = 0;
    //update();
  }
}
