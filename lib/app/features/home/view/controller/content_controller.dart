// content_controller.dart

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:love/app/config/functions.dart';
import 'package:love/app/config/status.dart';
import 'package:love/app/core/common/constants/constants.dart';
import 'package:love/app/core/database/db_helper.dart';
import 'package:love/app/features/home/repository/content_repository.dart';
import 'package:love/app/features/setting/view/controller/settings_controller.dart';

class ContentController extends GetxController {
  ContentController();
  var showWebView = true.obs;
  RxBool showAudio = false.obs;
  var bookInfo = Rxn<Map<String, dynamic>>();
  final settingsController = Get.find<SettingsController>();
  final ContentRepository repository = ContentRepository();
  var searchQuery = ''.obs;

  var pages = <Map<String, dynamic>>[].obs;
  var groups = <Map<String, dynamic>>[].obs;
  var currentPage = 1.0.obs;
  var scrollPosetion = 1.0.obs;
  var htmlContent = ''.obs;
  var status = Status.init.obs;
  RxBool showContentSettings = false.obs;
  final isBookmarked = false.obs;

  // متغیر برای مانیتورینگ تغییرات
  var lastUpdateTime = DateTime.now().obs;

  late InAppWebViewController inAppWebViewController;
  List<Map<String, dynamic>> get filteredGroups {
    if (searchQuery.isEmpty) return groups;
    return groups
        .where(
          (item) => (item['title'] ?? '').toString().toLowerCase().contains(
            searchQuery.value.toLowerCase(),
          ),
        )
        .toList();
  }

  @override
  void onInit() async {
    super.onInit();
    final bookmarks = Constants.localStorage.read('bookmarks') ?? {};
    final allComments = Constants.localStorage.read('allBookComments') ?? {};
    status.value = Status.loading;
    await _loadData();
    htmlContent.value = await buildHtmlContent();

    // گوش دادن به تغییرات دیتابیس
    _listenForUpdates();
  }

  // گوش دادن به تغییرات دیتابیس
  void _listenForUpdates() {
    ever(lastUpdateTime, (DateTime time) async {
      print('📢 Database update detected, refreshing content...');
      await refreshContent();
    });
  }

  // متد برای refresh کردن محتوا
  Future<void> refreshContent() async {
    try {
      print('🔄 Refreshing content data...');
      status.value = Status.loading;
      update(); // notify listeners

      // دوباره از دیتابیس بخوان
      await _loadData();

      // HTML جدید بساز
      htmlContent.value = await buildHtmlContent();

      status.value = Status.success;
      print('✅ Content refreshed successfully');
    } catch (e) {
      print('❌ Error refreshing content: $e');
      status.value = Status.error;
    }
  }

  // متد عمومی برای force refresh از خارج
  Future<void> forceRefreshFromDatabase() async {
    try {
      print('🔁 Force refreshing from database...');
      await refreshContent();
    } catch (e) {
      print('❌ Force refresh error: $e');
    }
  }

  Future<void> _loadData() async {
    try {
      print('📥 Loading data from database...');
      final repository = Repository();
      final dbPath = await repository.getDatabasePath();
      final loadedPages = await repository.getPages(dbPath);
      final loadedGroups = await repository.getGroups(dbPath);

      // لاگ برای دیباگ
      print('📄 Loaded ${loadedPages.length} pages');
      print('📚 Loaded ${loadedGroups.length} groups');

      // اگر صفحات رو داریم، لاگ صفحه اول رو نشون بده
      if (loadedPages.isNotEmpty && loadedPages[0].containsKey('_text')) {
        final firstPageText = loadedPages[0]['_text'] ?? '';
        print('📝 Page 1 preview: ${firstPageText.length} characters');
      }

      pages.assignAll(loadedPages);
      groups.assignAll(loadedGroups);

      status.value = Status.success;
    } catch (e) {
      print("❌ Database load error: $e");
      status.value = Status.error;
    }
  }

  /// Returns map of book info like sound_url, title, writer, img

  /// Builds the full HTML content to be displayed in the WebView
  Future<String> buildHtmlContent() async {
    final StringBuffer buffer = StringBuffer();

    final bool vertical = settingsController.verticalScroll.value;
    print('vertical ====>$vertical');
    final String bookText = vertical
        ? 'book_text_vertical'
        : 'book_text_horizontal';
    final String bookContainer = vertical
        ? 'book-container-vertical'
        : 'book-container-horizontal';
    final String bookPage = vertical
        ? 'BookPage-vertical book-page-vertical'
        : 'BookPage-horizontal book-page-horizontal';

    List<dynamic> bookmarks = [];
    final String? savedBookmarks = Constants.localStorage.read('bookmark');
    if (savedBookmarks != null) {
      try {
        final decoded = jsonDecode(savedBookmarks);
        bookmarks = decoded is List ? decoded : [decoded];
      } catch (e) {
        print('❌ Error parsing bookmarks: $e');
      }
    }

    for (int i = 0; i < pages.length; i++) {
      bool isBookmarked = bookmarks.any((b) => b['pageNumber'] == i);

      final String bgColor = settingsController.backgroundColor.value
          .toCssHex();

      buffer.write("""
        <div class='$bookPage book_page' data-page='$i' style='color: black !important; background-color: $bgColor !important;' id='page_$i'>
          ${isBookmarked ? "<div class='book-mark add_fav' id='book-mark_$i'></div>" : "<div class='book-mark' id='book-mark_$i'></div>"}
          <div class='comment-button'></div>
          <span class='page-number'>${i + 1}</span>
          <br>
          <div class='$bookText text_style' id='page___$i' style="font-size:${settingsController.fontSize}px !important; line-height:${settingsController.lineHeight} !important;">
            <div style='text-align:center;'><img class='pageLoading' src='asset://images/loader.gif'></div>
          </div>
        </div>
      """);
    }

    final fontCss = await loadFont();

    return '''
      <!DOCTYPE html>
      <html lang="en">
      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>$fontCss</style>
        <link rel="stylesheet" href="asset://web/css/bootstrap.rtl.min.css">
        <link rel="stylesheet" href="asset://web/css/mhebooks.css">
        <link rel="stylesheet" href="asset://web/all.min.css">
      </head>
      <body onload="replaceContent()" dir="rtl">
        <div class="$bookContainer">
          ${buffer.toString()}
        </div>
        <script src="asset://web/js/jquery-3.5.1.min.js"></script>
        <script src="asset://web/js/bootstrap.bundle.min.js"></script>
        <script src="asset://web/js/main.js"></script>
      </body>
      </html>
    ''';
  }

  /// Loads font files from assets and returns CSS rules to embed them in HTML
  Future<String> loadFont() async {
    String fontPath = 'assets/fonts/SegoeUI.woff2';
    String fontMime = 'font/woff2';

    switch (settingsController.fontFamily.value) {
      case 'لوتوس':
        fontPath = 'assets/fonts/Lotus-Light.woff2';
        break;
      case 'البهيج':
        fontPath = 'assets/fonts/BahijMuna-Bold.woff2';
        break;
      case 'دجلة':
      default:
        fontPath = 'assets/fonts/SegoeUI.woff2';
    }

    final ByteData mainFont = await rootBundle.load(fontPath);
    final ByteData aboFont = await rootBundle.load('assets/fonts/abo.ttf');

    final String mainFontBase64 = _getFontUriAsBase64(mainFont, fontMime);
    final String aboFontBase64 = _getFontUriAsBase64(aboFont, 'font/truetype');

    return '''
      @font-face {
        font-family: "${settingsController.fontFamily.value}";
        src: url("$mainFontBase64") format('woff2');
      }
      @font-face {
        font-family: "AboThar";
        src: url("$aboFontBase64") format('truetype');
      }
      .AboThar {
        font-family: "AboThar" !important;
          color: #4caf50 !important;
        font-size: 20px;
      }
      body, p, div, span {
        font-family: "${settingsController.fontFamily.value}" !important;
        direction: rtl;
      }
    ''';
  }

  /// Converts binary font data into Base64 URI
  String _getFontUriAsBase64(ByteData data, String mime) {
    final buffer = data.buffer;
    return "data:$mime;charset=utf-8;base64,${base64Encode(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes))}";
  }

  Future<void> handleBack() async {
    showWebView.value = false;
    await Future.delayed(const Duration(milliseconds: 50));
    Get.back();
  }

  // متد برای به‌روزرسانی زمان (از UpdatedPagesController صدا زده می‌شود)
  void notifyDatabaseUpdated() {
    lastUpdateTime.value = DateTime.now();
    print('📢 ContentController notified of database update');
  }
}

String applyTextReplacements(String text) {
  text = text.replaceAll(
    "<p style='color: blue;font-size: 67%'",
    "<hr><p style='color: blue;font-size: 14px !important'",
  );
  text = text.replaceAll("(عليهم السلام)", "<span class =AboThar></span>");
  text = text.replaceAll("(عليهم السّلام)", "<span class =AboThar></span>");
  text = text.replaceAll("(عليها السلام)", "<span class =AboThar></span>");
  text = text.replaceAll("(عليهالسلام)", "<span class =AboThar></span>");
  text = text.replaceAll(
    "(عَلَيْهَا السَّلَامُ)",
    "<span class =AboThar></span>",
  );
  text = text.replaceAll("(عليه السلام)", "<span class =AboThar></span>");
  text = text.replaceAll("(علیه السلام)", "<span class =AboThar></span>");
  text = text.replaceAll("(ع)", "<span class =AboThar></span>");

  text = text.replaceAll(
    "(صلّى الله عليه وآله)",
    "<span class =AboThar></span>",
  );
  text = text.replaceAll("صلى اله عليه وسلم", "<span class =AboThar></span>");
  text = text.replaceAll(
    "(صلى لله عليه وآله)",
    "<span class =AboThar></span>",
  );
  text = text.replaceAll(
    "(صَلَّى اللَّهُ عَلَيْهِ وَ آلِهِ)",
    "<span class =AboThar></span>",
  );
  text = text.replaceAll(
    "(صلي الله عليه وآله)",
    "<span class =AboThar></span>",
  );
  text = text.replaceAll(
    "(صلى الله عليه و اله)",
    "<span class =AboThar></span>",
  );
  text = text.replaceAll(
    "(صلي الله عليه و آله)",
    "<span class =AboThar></span>",
  );
  text = text.replaceAll(
    "(صلى الله عليه و آله)",
    "<span class =AboThar></span>",
  );
  text = text.replaceAll(
    "(صلى الله عليه وآله)",
    "<span class =AboThar></span>",
  );
  text = text.replaceAll(
    "(صلي الله عليه وسلم)",
    "<span class =AboThar></span>",
  );
  text = text.replaceAll(
    "(صلی الله علیه و آله و سلم)",
    "<span class =AboThar></span>",
  );
  text = text.replaceAll(
    "(صلى الله عليه وآله وسلم)",
    "<span class =AboThar></span>",
  );
  text = text.replaceAll("(ص)", "<span class =AboThar></span>");

  text = text.replaceAll("(رحمه الله)", "<span class =AboThar></span>");
  text = text.replaceAll(
    "(عجل الله تعالي و فرجه)",
    "<span class =AboThar></span>",
  );
  text = text.replaceAll(
    "(عجل الله فرجه الشريف)",
    "<span class =AboThar></span>",
  );
  text = text.replaceAll(
    "(عجل الله تعالى و فرجه)",
    "<span class =AboThar></span>",
  );
  text = text.replaceAll(
    "(عجل الله تعالى فرجه)",
    "<span class =AboThar></span>",
  );
  text = text.replaceAll(
    "(عجل الله تعالى فرجه الشريف)",
    "<span class =AboThar></span>",
  );
  text = text.replaceAll("(عج)", "<span class =AboThar></span>");
  text = text.replaceAll(
    "(عجل الله تعالي فرجه)",
    "<span class =AboThar></span>",
  );
  text = text.replaceAll("(عجل الله فرجه)", "<span class =AboThar></span>");

  text = text.replaceAll("(رضي الله عنه)", "<span class =AboThar></span>");
  text = text.replaceAll("(قدس سره)", "<span class =AboThar></span>");
  text = text.replaceAll("﴿", "<span class=AboThar></span>");
  text = text.replaceAll("﴾", "<span class=AboThar></span>");
  text = text.replaceAll("{", "<span class=AboThar></span>");
  text = text.replaceAll("}", "<span class=AboThar></span>");

  return text;
}
