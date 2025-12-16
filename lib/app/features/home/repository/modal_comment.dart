// اصلاح شده
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:love/app/core/common/constants/constants.dart';
import 'package:love/app/features/favorite%20&%20comment/view/controller/comment_controller.dart';

class ModalComment {
  static void show(
    BuildContext context, {
    required int idBook,
    required String bookname,
    required int idPage,
    required bool updateMode,
    required int id,
    String? oldTitle,
    String? oldComment,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        // دریافت کنترلر کامنت
        final CommentController commentController =
            Get.find<CommentController>();

        TextEditingController titleController = TextEditingController(
          text: oldTitle ?? '',
        );
        TextEditingController controller = TextEditingController(
          text: oldComment ?? '',
        );

        return Obx(() {
          return Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "تعليقك على ص $idPage من كتاب: $bookname",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'عنوان التعليق',
                      labelStyle: TextStyle(color: Colors.black45),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.onPrimary,
                          width: 2,
                        ),
                      ),
                    ),
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: controller,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: 'التعليق',
                      labelStyle: TextStyle(color: Colors.black45),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.onPrimary,
                          width: 2,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 10,
                      ),
                    ),
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),

                  // نمایش خطا
                  if (commentController.error.value.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        commentController.error.value,
                        style: TextStyle(color: Colors.red, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: commentController.isSubmitting.value
                            ? null
                            : () async {
                                if (controller.text.isEmpty ||
                                    titleController.text.isEmpty) {
                                  Get.snackbar(
                                    'خطأ',
                                    'يرجى ملء جميع الحقول.',
                                    colorText: Colors.white,
                                    backgroundColor: Colors.redAccent.withAlpha(
                                      100,
                                    ),
                                    icon: Icon(
                                      Icons.error_outline,
                                      color: Colors.white,
                                    ),
                                    snackPosition: SnackPosition.BOTTOM,
                                    duration: Duration(seconds: 3),
                                    margin: EdgeInsets.all(16),
                                    borderRadius: 10,
                                  );
                                } else {
                                  String title = titleController.text.trim();
                                  String comment = controller.text.trim();

                                  if (updateMode) {
                                    // حالت آپدیت
                                    await commentController.updateComment(
                                      id: id,
                                      title: title,
                                      content: comment,
                                      pageNumber: idPage,
                                    );

                                    // فقط اگر موفق بود، localStorage رو هم آپدیت کن
                                    if (commentController
                                        .success
                                        .value
                                        .isNotEmpty) {
                                      _updateLocalStorage(
                                        idBook: idBook,
                                        bookname: bookname,
                                        idPage: idPage,
                                        title: title,
                                        comment: comment,
                                      );
                                    }
                                  } else {
                                    // حالت جدید
                                    await commentController.submitComment(
                                      title: title,
                                      content: comment,
                                      pageNumber: idPage,
                                    );

                                    // فقط اگر موفق بود، localStorage رو هم ذخیره کن
                                    if (commentController
                                        .success
                                        .value
                                        .isNotEmpty) {
                                      _saveToLocalStorage(
                                        idBook: idBook,
                                        bookname: bookname,
                                        idPage: idPage,
                                        title: title,
                                        comment: comment,
                                      );
                                    }
                                  }

                                  // اگر ارسال موفق بود، مدال رو ببند
                                  if (commentController
                                      .success
                                      .value
                                      .isNotEmpty) {
                                    await Future.delayed(
                                      const Duration(milliseconds: 500),
                                    );
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                    }
                                  }
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: commentController.isSubmitting.value
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(updateMode ? 'تحديث' : 'إرسال'),
                      ),
                      OutlinedButton(
                        onPressed: commentController.isSubmitting.value
                            ? null
                            : () {
                                Navigator.pop(context);
                              },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.onPrimary,
                            width: 1,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'إلغاء',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(20),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  // تابع کمکی برای ذخیره در localStorage
  static Future<void> _saveToLocalStorage({
    required int idBook,
    required String bookname,
    required int idPage,
    required String title,
    required String comment,
  }) async {
    String allCommentsKey = 'allBookComments';
    List<dynamic> existingComments =
        Constants.localStorage.read(allCommentsKey) ?? [];

    // چک کن که آیا کامنت قبلی برای همین کتاب و صفحه وجود دارد
    int existingIndex = existingComments.indexWhere(
      (c) => c['idBook'] == idBook && c['idPage'] == idPage,
    );

    if (existingIndex != -1) {
      existingComments.removeAt(existingIndex);
    }

    // ایجاد کامنت جدید
    Map<String, dynamic> newComment = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'idBook': idBook,
      'bookName': bookname,
      'idPage': idPage,
      'title': title,
      'comment': comment,
      'createdAt': DateTime.now().toIso8601String(),
    };

    existingComments.add(newComment);

    await Constants.localStorage.write(allCommentsKey, existingComments);
  }

  // تابع کمکی برای آپدیت localStorage
  static Future<void> _updateLocalStorage({
    required int idBook,
    required String bookname,
    required int idPage,
    required String title,
    required String comment,
  }) async {
    String allCommentsKey = 'allBookComments';
    List<dynamic> existingComments =
        Constants.localStorage.read(allCommentsKey) ?? [];

    int existingIndex = existingComments.indexWhere(
      (c) => c['idBook'] == idBook && c['idPage'] == idPage,
    );

    if (existingIndex != -1) {
      existingComments[existingIndex] = {
        ...existingComments[existingIndex],
        'title': title,
        'comment': comment,
        'updatedAt': DateTime.now().toIso8601String(),
      };
    }

    await Constants.localStorage.write(allCommentsKey, existingComments);
  }
}
