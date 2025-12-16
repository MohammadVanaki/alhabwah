// lib/app/features/update/controller/updated_pages_controller.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:love/app/core/common/constants/api_constants.dart';
import 'package:love/app/core/network/api_client.dart';
import 'package:love/app/models/updated_page_model.dart';
import 'package:love/app/core/database/db_helper.dart';
import 'package:love/app/features/home/view/controller/content_controller.dart'; // اضافه شده

class UpdatedPagesController extends GetxController {
  final ApiClient _apiClient = Get.find();
  final GetStorage _storage = GetStorage();

  final RxList<UpdatedPageModel> updatedPages = <UpdatedPageModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isUpdating = false.obs;
  final RxString error = ''.obs;
  final RxString success = ''.obs;
  final RxInt updatedCount = 0.obs;

  static const String _lastUpdateKey = 'last_book_update_timestamp';
  static const String _lastBookIdKey = 'last_checked_book_id';
  static const String _updateEnabledKey = 'auto_update_enabled';

  DateTime? getLastUpdateTime() {
    final timestamp = _storage.read<String>(_lastUpdateKey);
    if (timestamp != null && timestamp.isNotEmpty) {
      try {
        return DateTime.parse(timestamp);
      } catch (e) {
        print('Error parsing stored timestamp: $e');
        return null;
      }
    }
    return null;
  }

  Future<void> saveLastUpdateTime(DateTime time) async {
    await _storage.write(_lastUpdateKey, time.toIso8601String());
  }

  int getLastCheckedBookId() {
    return _storage.read<int>(_lastBookIdKey) ?? 3;
  }

  // ذخیره bookId
  Future<void> saveLastCheckedBookId(int bookId) async {
    await _storage.write(_lastBookIdKey, bookId);
  }

  // فعال/غیرفعال کردن آپدیت خودکار
  bool get isAutoUpdateEnabled {
    return _storage.read<bool>(_updateEnabledKey) ?? true;
  }

  Future<void> setAutoUpdateEnabled(bool enabled) async {
    await _storage.write(_updateEnabledKey, enabled);
  }

  Future<void> fetchUpdatedPages({
    int bookId = 3,
    bool forceCheck = false,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';
      updatedPages.clear();
      success.value = '';

      // دریافت آخرین زمان به‌روزرسانی
      final lastUpdate = getLastUpdateTime();
      String fromDate = '2024-01-01 00:00:00'; // تاریخ پیش‌فرض

      if (forceCheck || lastUpdate == null) {
        // از 24 ساعت قبل چک کن
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        final year = yesterday.year;
        final month = yesterday.month.toString().padLeft(2, '0');
        final day = yesterday.day.toString().padLeft(2, '0');
        // final hour = yesterday.hour.toString().padLeft(2, '0');
        // final minute = yesterday.minute.toString().padLeft(2, '0');
        // final second = yesterday.second.toString().padLeft(2, '0');

        fromDate = '$year-$month-$day';
        print('Force check or first time - checking from: $fromDate');
      } else {
        // از آخرین آپدیت چک کن
        final year = lastUpdate.year;
        final month = lastUpdate.month.toString().padLeft(2, '0');
        final day = lastUpdate.day.toString().padLeft(2, '0');
        // final hour = lastUpdate.hour.toString().padLeft(2, '0');
        // final minute = lastUpdate.minute.toString().padLeft(2, '0');
        // final second = lastUpdate.second.toString().padLeft(2, '0');

        fromDate = '$year-$month-$day';
        print('Checking updates from last update: $fromDate');
      }

      final encodedDate = fromDate.replaceAll(' ', '%20');
      final url =
          '${ApiConstants.baseUrl}/api/book/$bookId/updated-pages?from_date=$encodedDate';

      print('API URL: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('API Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == true) {
          final pagesData = data['data'] as List;
          final pages = pagesData
              .map((item) => UpdatedPageModel.fromJson(item))
              .toList();

          // فیلتر کردن صفحات خالی
          updatedPages.value = pages
              .where(
                (page) =>
                    page.content != null && page.content.trim().isNotEmpty,
              )
              .toList();

          updatedCount.value = updatedPages.length;

          if (updatedPages.isNotEmpty) {
            success.value = 'تم العثور على ${updatedCount.value} صفحة محدثة';
            print('✅ Found ${updatedPages.length} updated pages');
          } else {
            success.value = 'لا توجد صفحات محدثة';
            print('📭 No updated pages found');
          }

          await saveLastCheckedBookId(bookId);
        } else {
          error.value = 'فشل في جلب الصفحات المحدثة';
          print('❌ API returned false status');
        }
      } else {
        error.value = 'خطأ في الخادم: ${response.statusCode}';
        print('❌ Server error: ${response.statusCode}');
      }
    } catch (e) {
      error.value = 'خطأ في الاتصال بالخادم: $e';
      print('❌ Error fetching updated pages: $e');

      if (!Get.isSnackbarOpen) {
        Get.snackbar(
          'خطأ',
          'تعذر الاتصال بالخادم',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  // 🔴 این قسمت اصلی که باید اضافه شود - متد updateDatabaseWithNewPages
  Future<void> updateDatabaseWithNewPages({bool showSnackbar = true}) async {
    try {
      if (updatedPages.isEmpty) {
        success.value = 'لا توجد صفحات جديدة للتحديث';
        return;
      }

      isUpdating.value = true;
      error.value = '';

      int successCount = 0;
      int errorCount = 0;

      final db = await DBHelper.initDb();

      await db.transaction((txn) async {
        for (final page in updatedPages) {
          try {
            final existing = await txn.query(
              'b38_pages',
              where: 'page = ?',
              whereArgs: [page.page],
            );

            if (existing.isNotEmpty) {
              await txn.update(
                'b38_pages',
                {'_text': page.content},
                where: 'page = ?',
                whereArgs: [page.page],
              );
              print('📝 Page ${page.page} updated');
            } else {
              await txn.insert('b38_pages', {
                'page': page.page,
                '_text': page.content,
              });
              print('📄 Page ${page.page} inserted');
            }

            successCount++;
          } catch (e) {
            print('❌ Error updating page ${page.page}: $e');
            errorCount++;
          }
        }
      });

      // 🔴 اینجا: ذخیره زمان آپدیت
      await saveLastUpdateTime(DateTime.now());

      // 🔴 اینجا: اطلاع به ContentController برای refresh کردن
      try {
        if (Get.isRegistered<ContentController>()) {
          final contentController = Get.find<ContentController>();
          await contentController.refreshContent();
          print('✅ ContentController notified of update');
        }
      } catch (e) {
        print('⚠️ Could not notify ContentController: $e');
      }

      if (showSnackbar && successCount > 0) {
        Get.snackbar(
          '✅ تم التحديث',
         'تمت المزامنة وتحديث البيانات بنجاح',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }

      print(
        '🎉 Update completed: $successCount successful, $errorCount failed',
      );

      // 🔴 پاک کردن لیست آپدیت شده‌ها
      updatedPages.clear();
      updatedCount.value = 0;
    } catch (e) {
      error.value = 'خطأ في تحديث قاعدة البيانات: $e';
      print('❌ Error updating database: $e');

      if (showSnackbar) {
        Get.snackbar(
          '❌ خطأ',
          'فشل في تحديث قاعدة البيانات',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } finally {
      isUpdating.value = false;
    }
  }

  // متد برای چک آپدیت و اعمال آن
  Future<void> checkAndApplyUpdates({
    int bookId = 3,
    bool showUI = false,
  }) async {
    try {
      print('🔍 Starting update check...');

      await fetchUpdatedPages(bookId: bookId, forceCheck: true);

      if (updatedPages.isNotEmpty) {
        print('✅ Found updates, applying...');
        await updateDatabaseWithNewPages(showSnackbar: showUI);

        if (showUI && !Get.isSnackbarOpen) {
          Get.snackbar(
            '✅ تم التحديث',
            'تم تحديث ${updatedPages.length} صفحة',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
        }
      } else {
        print('📭 No updates found');
      }
    } catch (e) {
      print('❌ Error in checkAndApplyUpdates: $e');
    }
  }

  Future<void> checkForUpdates({int bookId = 3, bool showUI = true}) async {
    try {
      print('Checking for updates...');

      await fetchUpdatedPages(bookId: bookId);

      if (updatedPages.isNotEmpty) {
        print('Found ${updatedPages.length} pages to update');

        if (showUI) {
          await updateDatabaseWithNewPages(showSnackbar: showUI);
        } else {
          await updateDatabaseWithNewPages(showSnackbar: false);
        }
      } else {
        print('No updates found');
      }
    } catch (e) {
      print('Error in checkForUpdates: $e');
    }
  }

  Future<void> manualCheckForUpdates({int bookId = 3}) async {
    try {
      // ریست وضعیت
      updatedPages.clear();
      error.value = '';
      success.value = '';

      print('Manual update check started...');

      // دریافت صفحات
      await fetchUpdatedPages(bookId: bookId);

      if (updatedPages.isNotEmpty) {
        // پرسش از کاربر برای تأیید آپدیت
        bool shouldUpdate = await _showUpdateConfirmationDialog();

        if (shouldUpdate) {
          await updateDatabaseWithNewPages();
        }
      } else if (error.value.isEmpty) {
        Get.snackbar(
          'معلومات',
          'لا توجد تحديثات جديدة',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error in manualCheckForUpdates: $e');
    }
  }

  Future<bool> _showUpdateConfirmationDialog() async {
    return await Get.dialog<bool>(
          AlertDialog(
            title: const Text('تحديث الصفحات'),
            content: Text(
              'تم العثور على ${updatedCount.value} صفحة محدثة. هل ترغب في التحديث الآن؟',
              textDirection: TextDirection.rtl,
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () => Get.back(result: true),
                child: const Text('تحديث'),
              ),
            ],
          ),
        ) ??
        false;
  }

  // پاک کردن cache
  Future<void> clearUpdateCache() async {
    await _storage.remove(_lastUpdateKey);
    await _storage.remove(_lastBookIdKey);
    updatedPages.clear();
    updatedCount.value = 0;
    error.value = '';
    success.value = '';

    Get.snackbar(
      'تم',
      'تم مسح ذاكرة التحديثات',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // دریافت اطلاعات وضعیت
  Map<String, dynamic> getUpdateStatus() {
    final lastUpdate = getLastUpdateTime();
    final bookId = getLastCheckedBookId();

    return {
      'last_update':
          lastUpdate?.toLocal().toString() ?? 'لم يتم التحديث مسبقًا',
      'book_id': bookId,
      'auto_update': isAutoUpdateEnabled,
      'pending_updates': updatedPages.length,
      'last_check': DateTime.now().toLocal().toString(),
    };
  }
}
