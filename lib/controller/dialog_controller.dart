import 'package:current_data_panel/core/constant/app_color.dart';
import 'package:get/get.dart';

class DialogController extends GetxController {
  RxBool _isDialogOpen = false.obs;
  Rx<String?> _tempPath = Rxn();
  Rx<int> _tempLineCount = 0.obs;
  Rx<List<Map<String, Object?>>?> _tempMapList = Rxn();

  bool get isDialogOpen => _isDialogOpen.value;
  String? get tempPath => _tempPath.value;
  int get tempLineCount => _tempLineCount.value;
  List<Map<String, Object?>>? get tempMapList => _tempMapList.value;

  syncMapLists(List<Map<String, Object?>>? map){
    _tempMapList.value = map;
    update();
  }

  setDialogOpen(bool value) {
    _isDialogOpen.value = value;
    update();
  }

  setTempPath(String? value) {
    _tempPath.value = value;
    update();
  }

  killTempPathWithoutUpdate() {
    _tempPath.value = null;
  }

  setTempLineCount(int? value) {
    if (value != null) {
      _tempLineCount.value = value;
    } else {
      setTempLineCount(value);
    }
    update();
  }

  killTempLineWithoutUpdate() {
    _tempLineCount.value = 0;
  }

  populateTempMapList() {
    _tempMapList.value = [];

    for (int i = 0; i < _tempLineCount.value; i++) {
      //_tempLineCount.value
      _tempMapList.value!.add({});
    }
    print('object');
  }


  setDefaultTempMap(){
    for(var map in _tempMapList.value!){
      map['name'] = '';
      map['color'] = AppColor.blue.value.toRadixString(16);
      map['textColor'] = AppColor.black.value.toRadixString(16);
    }
  }

  setTempMapListIndexName(int index, String? value) {
    _tempMapList.value![index]['name'] = value;
  }

  setTempMapIndexColor(int index, String? value) {
    _tempMapList.value![index]['color'] = value;
    update();
  }

  setTempMapIndexTextColor(int index, String? value) {
    _tempMapList.value![index]['textColor'] = value;
    update();
  }

  setTempMapListIndexValue(int index, Map<String, Object> map) {
    _tempMapList.value![index] = map;
  }
}
