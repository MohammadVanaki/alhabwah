import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:love/app/core/common/widgets/custom_loading.dart';
import 'package:love/app/core/database/db_helper.dart';
import 'package:love/app/features/home/view/controller/content_controller.dart';
import 'package:love/app/features/home/view/screens/home_page.dart';
import 'package:love/app/features/update/controller/updated_pages_controller.dart';

// splash_page.dart
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _isCheckingUpdates = false;
  bool _updatesApplied = false;
  bool _controllerInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      print('🚀 Starting app initialization...');

      // 1. Initialize database
      print('📦 Initializing database...');
      await DBHelper.initDb();

      // 2. Initialize ContentController (الآن اینجا ثبتش میکنیم)
      await _initializeContentController();

      // 3. Start update check (async - don't await)
      _startUpdateCheck();

      // 4. Minimum splash time
      await Future.delayed(const Duration(seconds: 3));

      // 5. Navigate to home
      if (mounted && _controllerInitialized) {
        _navigateToHome();
      }
    } catch (e) {
      print('❌ Initialization error: $e');
      if (mounted) {
        _navigateToHome();
      }
    }
  }

  Future<void> _initializeContentController() async {
    try {
      print('🔄 Initializing ContentController...');

      // مطمئن شویم قبلاً ثبت نشده
      if (Get.isRegistered<ContentController>()) {
        print('⚠️ ContentController already exists, removing...');
        await Get.delete<ContentController>();
      }

      // ثبت ContentController با lazyPut و fenix: true
      Get.lazyPut(() => ContentController(), fenix: true);

      // منتظر شویم کنترلر ساخته شود
      final controller = Get.find<ContentController>();
      print('✅ ContentController initialized successfully');

      _controllerInitialized = true;
    } catch (e) {
      print('❌ Error initializing ContentController: $e');
      _controllerInitialized = false;
    }
  }

  Future<void> _startUpdateCheck() async {
    if (_isCheckingUpdates) return;

    _isCheckingUpdates = true;

    try {
      print('🔄 Checking for updates in background...');
      final updateController = Get.find<UpdatedPagesController>();

      // زمان‌بندی: منتظر کمی بمان تا UI لود شود
      await Future.delayed(const Duration(milliseconds: 800));

      // چک آپدیت را شروع کن (forceCheck: true برای اولین بار)
      await updateController.checkAndApplyUpdates(showUI: false);

      if (updateController.updatedPages.isNotEmpty) {
        _updatesApplied = true;
        print('✅ Background update completed successfully');
      }
    } catch (e) {
      print('❌ Background update error: $e');
    } finally {
      _isCheckingUpdates = false;
    }
  }

  void _navigateToHome() {
    if (mounted) {
      // کمی تأخیر برای اطمینان
      Future.delayed(const Duration(milliseconds: 300), () {
        Get.off(() => HomePage());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: Get.width,
        height: Get.height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/images/b_al7aboah002.jpg',
              width: Get.width,
              height: Get.height,
              fit: BoxFit.fill,
            ),

            Positioned(
              bottom: 100,
              child: Column(
                children: [
                  const CustomLoading(color: Colors.white),
                  const SizedBox(height: 20),

                  Text(
                    _controllerInitialized
                        ? (_updatesApplied ? '✅ تم التحديث' : 'جاهز...')
                        : 'جاري التحميل...',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),

                  if (!_controllerInitialized)
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        'جاري تحميل المحتوى...',
                        style: TextStyle(color: Colors.yellow, fontSize: 12),
                      ),
                    ),

                  if (_isCheckingUpdates)
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        'جاري التحقق من التحديثات...',
                        style: TextStyle(color: Colors.yellow, fontSize: 12),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
