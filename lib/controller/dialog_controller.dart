import 'package:get/get.dart';

class DialogController extends GetxController {
  RxBool _isDialogOpen = false.obs;

  bool get isDialogOpen => _isDialogOpen.value;

  setDialogOpen(bool value) {
    _isDialogOpen.value = value;
    update();
  }
}
