import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../controller/qrcontroller.dart';

class QRPage extends StatelessWidget {
  const QRPage({super.key});

  @override
  Widget build(BuildContext context) {
    final QRController controller = Get.put(QRController());

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() {
              return controller.isLoading.value
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : controller.data.isNotEmpty
                      ? QrImageView(
                          data: controller.data.value,
                          version: QrVersions.auto,
                          size: 320,
                          gapless: false,
                          embeddedImage: const AssetImage(
                              'assets/images/my_embedded_image.png'),
                          embeddedImageStyle: const QrEmbeddedImageStyle(
                            size: Size(80, 80),
                          ),
                          eyeStyle: const QrEyeStyle(
                            eyeShape: QrEyeShape.square,
                            color: Colors.white,
                          ),
                          dataModuleStyle: const QrDataModuleStyle(
                            color: Colors.white,
                            dataModuleShape: QrDataModuleShape.square,
                          ),
                        )
                      : SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.85,
                          child: const Text(
                            "This code allows you to enter and leave your club.Its personal and non-transferable.Use it responsibly",
                            style: TextStyle(color: Colors.white),
                          ),
                        );
            }),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: controller.generateQRCode,
              child: const Text(
                'Generate new QR Code',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
