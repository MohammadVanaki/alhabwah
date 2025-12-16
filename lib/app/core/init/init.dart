import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:love/app/config/error_widget.dart';
import 'package:love/app/config/get_version.dart';
import 'package:love/app/core/database/db_helper.dart';
import 'package:love/app/core/network/api_client.dart';
import 'package:love/app/features/favorite%20&%20comment/view/controller/comment_controller.dart';
import 'package:love/app/features/home/view/controller/content_controller.dart';
import 'package:love/app/features/home/view/controller/navigation_controller.dart';
import 'package:love/app/features/setting/view/controller/settings_controller.dart';
import 'package:love/app/features/update/controller/updated_pages_controller.dart';

Future<void> init() async {
  // Initialize storage first
  await GetStorage.init();

  // Initialize controllers
  Get.put(ApiClient());
  Get.lazyPut(() => UpdatedPagesController(), fenix: true);
  Get.put(AppVersionController());
  Get.put(CommentController());
  Get.put(SettingsController());

  Get.put(BottmNavigationController(), permanent: true);

  // Custom error widget
  CustomErrorWidget.initialize();

  // Initialize database factory (فقط اینجا)
  DBHelper.initializeDatabaseFactory();

  // Set default last update time if not exists
  final storage = GetStorage();
  final lastUpdateKey = 'last_book_update_timestamp';
  if (!storage.hasData(lastUpdateKey)) {
    // Set to 24 hours ago for first check
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    await storage.write(lastUpdateKey, yesterday.toIso8601String());
    print('📅 Set default last update time: $yesterday');
  }

  print('✅ App initialization complete');
}
