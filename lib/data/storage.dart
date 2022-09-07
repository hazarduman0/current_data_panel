// import 'dart:io';

// import 'package:current_data_panel/controller/data_controller.dart';
// import 'package:current_data_panel/controller/dialog_controller.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';

// class StorageManager {
//   final box = GetStorage();

//   final DialogController _dc = Get.find();
//   final DataController _dtc = Get.find();

//   String pathKey = 'path';

//   getPathStorage() {
//     var value = box.read(pathKey);

//     if (value == null || _dc.isDialogOpen) return;

//     _dtc.setPath(value);
//     _dtc.setDialogPath(value);
//   }

//   //pathi null yap fonksiyon çalıştıktan sonra
//   setPathStorage(String? value) async {
//     if (value != null) {
//       if (await File(value).exists()) {
//         box.write(pathKey, value);
//         getPathStorage();
//       }
//     } else {
//       box.remove(pathKey);
//       _dtc.setPath(value);
//     }
//   }
// }
