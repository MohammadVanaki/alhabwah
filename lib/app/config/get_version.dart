import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppVersionController extends GetxController {
  final version = ''.obs;
  final buildNumber = ''.obs;

  @override
  void onInit() {
    super.onInit();
    initVersionControl();
  }

  // کنترل نسخه: گرفتن نسخه و بررسی تغییر
  Future<void> initVersionControl() async {
    await getAppVersion(); // همیشه اطلاعات نسخه رو بگیر
  }

  // گرفتن نسخه اپ از package_info_plus
  Future<void> getAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      version.value = packageInfo.version;
      buildNumber.value = packageInfo.buildNumber;
      print('✅ App Version: ${version.value}');
      print('✅ Build Number: ${buildNumber.value}');
    } catch (e) {
      print('❌ Failed to get app version: $e');
    }
  }
}
