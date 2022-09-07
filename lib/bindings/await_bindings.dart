import 'package:current_data_panel/controller/data_controller.dart';
import 'package:current_data_panel/controller/dialog_controller.dart';
import 'package:current_data_panel/controller/window_controller.dart';
import 'package:get/get.dart';

class AwaitBindings extends Bindings {
  @override
  Future<void> dependencies() async {
    await Get.putAsync(() async => WindowController(), permanent: true);
    await Get.putAsync(() async => DialogController(), permanent: true);
    await Get.putAsync(() async => DataController(), permanent: true);
  }
}