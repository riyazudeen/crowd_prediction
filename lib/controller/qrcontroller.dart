import 'package:get/get.dart';

class QRController extends GetxController {
  final data = ''.obs;
  final isLoading = false.obs;

  void generateQRCode() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 500));
    data.value = DateTime.now().toIso8601String();
    isLoading.value = false;
  }
}
