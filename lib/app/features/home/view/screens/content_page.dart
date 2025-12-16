import 'dart:convert';

import 'package:another_xlider/another_xlider.dart';
import 'package:another_xlider/enums/tooltip_direction_enum.dart';
import 'package:another_xlider/models/handler.dart';
import 'package:another_xlider/models/tooltip/tooltip.dart';
import 'package:another_xlider/models/trackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:love/app/config/status.dart';
import 'package:love/app/core/common/constants/constants.dart';
import 'package:love/app/core/common/widgets/custom_loading.dart';
import 'package:love/app/core/common/widgets/empty_widget.dart';
import 'package:love/app/features/home/repository/modal_comment.dart';
import 'package:love/app/features/home/repository/save_dialog.dart';
import 'package:love/app/features/home/view/controller/content_controller.dart';
import 'package:love/app/features/home/view/controller/search_content_controller.dart';
import 'package:love/app/features/setting/view/controller/settings_controller.dart';

import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class ContentPage extends StatelessWidget {
  final int bookId;
  final String bookName;
  final String searchWord;
  final double scrollPosetion;
  const ContentPage({
    super.key,
    required this.bookId,
    required this.bookName,
    required this.searchWord,
    required this.scrollPosetion,
  });

  @override
  Widget build(BuildContext context) {
    final SettingsController settingsController = Get.put(SettingsController());
    final SearchContentController searchContentController = Get.put(
      SearchContentController(),
    );
    final ContentController contentController = Get.find<ContentController>();

    final bool verticalScroll = settingsController.verticalScroll.value;

    return WillPopScope(
      onWillPop: () async {
        // if (contentController.currentPage.value > 10 &&
        //     contentController.currentPage.value <
        //         contentController.pages.length) {
        //   showSaveBookDialog(
        //     context,
        //     bookName,
        //     contentController.currentPage.value.toInt(),
        //     bookId,
        //     contentController.pages.length,
        //   );
        // }
        // await contentController.handleBack();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: null,
          automaticallyImplyLeading: false,
          actions: [
            Expanded(
              child: Row(
                children: [
                  const Gap(10),
                  ZoomTapAnimation(
                    onTap: () {
                      // Show dialog when tapped
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          // Title of the popup
                          title: const Text(
                            "تعريف بالرموز المستعملة:",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          // Content text
                          content: SingleChildScrollView(
                            child: Column(
                              children: [
                                Table(
                                  border: TableBorder.all(
                                    color: Colors.grey.withAlpha(
                                      40,
                                    ), // Color of borders
                                    width: 1, // Border thickness
                                  ),
                                  // Defines the table with two equal columns
                                  columnWidths: const {
                                    0: FlexColumnWidth(1),
                                    1: FlexColumnWidth(2),
                                  },
                                  // Table rows
                                  children: const [
                                    TableRow(
                                      children: [
                                        Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("الرمز"),
                                          ),
                                        ),
                                        Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("معناه"),
                                          ),
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              "📚",
                                              style: TextStyle(fontSize: 22),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            "بداية مجموعة من المسائل المترابطة أكثر مع بعضها",
                                          ),
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              "🌟",
                                              style: TextStyle(fontSize: 22),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            "توضع قبل عنوان مسألة، للتزيين، وإبراز عنوان المسألة أكثر.",
                                          ),
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              "8️⃣",
                                              style: TextStyle(fontSize: 22),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            "(التغييرات) التي حدثت ضمن الإصدار الثامن",
                                          ),
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              "9️⃣",
                                              style: TextStyle(fontSize: 22),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            "(التغييرات) التي حدثت ضمن الإصدار التاسع",
                                          ),
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              "🔄",
                                              style: TextStyle(fontSize: 22),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            '''يوجد شيء مما يوهم التعارض في الفتوى، مع عدم جزمي بوجه الجمع بين العبارات أو الفتاوى.''',
                                          ),
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              "💡",
                                              style: TextStyle(fontSize: 22),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text('''الحبوة'''),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Close button
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                "اغلاق",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: SvgPicture.asset(
                      'assets/svgs/index-book.svg',
                      width: 22,
                      height: 22,
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).colorScheme.onPrimary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  const Gap(10),
                  Obx(
                    () => ZoomTapAnimation(
                      onTap: () {
                        if (searchContentController.showSearcResult.value &&
                            !searchContentController.showSearch.value) {
                          searchContentController.showSearch.value = false;
                          searchContentController.showSearcResult.value = false;

                          contentController.inAppWebViewController
                              .evaluateJavascript(source: "clearHighlights();");

                          searchContentController.searchController.text = '';
                        } else {
                          searchContentController.showSearch.value =
                              !searchContentController.showSearch.value;
                          // searchContentController.showSearcResult.value =
                          //     !searchContentController.showSearcResult.value;
                        }
                      },
                      child: SvgPicture.asset(
                        !searchContentController.showSearcResult.value
                            ? 'assets/svgs/search.svg'
                            : 'assets/svgs/not-found-alt.svg',
                        width: 22,
                        height: 22,
                        colorFilter: ColorFilter.mode(
                          searchContentController.showSearcResult.value
                              ? Colors.red
                              : Theme.of(context).colorScheme.onPrimary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                    child: Center(
                      child: Text(
                        bookName,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                  const Gap(10),
                  ZoomTapAnimation(
                    onTap: () {
                      contentController.showContentSettings.value =
                          !contentController.showContentSettings.value;
                    },
                    child: SvgPicture.asset(
                      'assets/svgs/settings.svg',
                      width: 22,
                      height: 22,
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).colorScheme.onPrimary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),

                  const Gap(10),
                  ZoomTapAnimation(
                    onTap: () async {
                      Get.back();
                    },
                    child: SvgPicture.asset(
                      'assets/svgs/angle-left.svg',
                      width: 20,
                      height: 20,
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).colorScheme.onPrimary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  const Gap(10),
                ],
              ),
            ),
          ],
        ),
        body: Obx(() {
          if (contentController.status.value == Status.loading) {
            return const Center(child: CustomLoading());
          }

          if (contentController.pages.isEmpty) {
            return const Center(child: EmptyWidget(title: 'لا يوجد صفحة'));
          }

          if (contentController.status.value == Status.success &&
              contentController.htmlContent.value.isEmpty) {
            return const Center(child: CustomLoading());
          }
          return contentController.showWebView.value
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    Flex(
                      direction: verticalScroll
                          ? Axis.horizontal
                          : Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      textDirection: TextDirection.ltr,
                      children: [
                        const Gap(5),
                        Expanded(
                          child: SizedBox(
                            width: verticalScroll ? Get.width - 40 : Get.width,
                            child: InAppWebView(
                              initialSettings: InAppWebViewSettings(
                                useShouldInterceptRequest: true,
                                javaScriptEnabled: true,
                                domStorageEnabled: true,
                                allowFileAccessFromFileURLs: true,
                                allowUniversalAccessFromFileURLs: true,
                                useShouldOverrideUrlLoading: true,
                                javaScriptCanOpenWindowsAutomatically: true,
                                horizontalScrollBarEnabled: false,
                                verticalScrollBarEnabled: false,
                                supportZoom: false,
                                builtInZoomControls: false,
                                displayZoomControls: false,
                                pageZoom: 1,
                                maximumZoomScale: 1,
                                minimumZoomScale: 1,
                                useOnLoadResource: true,
                              ),
                              initialData: InAppWebViewInitialData(
                                data: contentController.htmlContent.value,
                                mimeType: "text/html",
                                encoding: "utf-8",
                              ),
                              onWebViewCreated: (controller) async {
                                contentController.inAppWebViewController =
                                    controller;
                              },
                              shouldInterceptRequest:
                                  (controller, request) async {
                                    String url = request.url.toString();
                                    print("Intercepted URL: $url");

                                    if (url.startsWith("asset://")) {
                                      String assetFileName = url.replaceFirst(
                                        "asset://",
                                        "",
                                      );

                                      try {
                                        ByteData assetData = await rootBundle
                                            .load("assets/$assetFileName");
                                        Uint8List bytes = assetData.buffer
                                            .asUint8List();
                                        String contentType = "text/plain";

                                        if (assetFileName.endsWith(".css")) {
                                          contentType = "text/css";
                                        } else if (assetFileName.endsWith(
                                          ".gif",
                                        )) {
                                          contentType = "image/gif";
                                        }

                                        return WebResourceResponse(
                                          data: bytes,
                                          statusCode: 200,
                                          reasonPhrase: "OK",
                                          contentType: contentType,
                                          headers: {
                                            "Access-Control-Allow-Origin": "*",
                                          },
                                        );
                                      } catch (e) {
                                        print("Error loading asset: $e");
                                      }
                                    }

                                    return null;
                                  },
                              onLoadStop: (controller, url) async {
                                await controller.evaluateJavascript(
                                  source: '''
                                  document.documentElement.style.scrollbarWidth = 'none';
                                  document.body.style.msOverflowStyle = 'none';
                                  document.documentElement.style.overflow = 'auto';
                                  document.body.style.overflow = 'auto';

                                  var style = document.createElement('style');
                                  style.innerHTML = '::-webkit-scrollbar { display: none; }';
                                  document.head.appendChild(style);
                                ''',
                                );

                                final bgColor = Theme.of(
                                  context,
                                ).colorScheme.surface;
                                final hexColor =
                                    '#${bgColor.value.toRadixString(16).substring(2)}';

                                await controller.evaluateJavascript(
                                  source:
                                      "document.body.style.backgroundColor = '$hexColor';",
                                );
                                final jsonData = jsonEncode(
                                  contentController.pages.map((item) {
                                    final originalText = item['_text'] ?? '';
                                    var processedText = applyTextReplacements(
                                      originalText,
                                    );

                                    // لیست اسامی برای بولد کردن
                                    final namesToBold = [
                                      'السيد الخامنئي',
                                      'السيد الخوئي',
                                      'السيد السيستاني',
                                      'الشيخ الفياض',
                                      'السيد صادق',
                                      'السيد الزنجاني',
                                      'الشيخ المكارم',
                                      'الشيخ الخراساني',
                                    ];

                                    // بولد کردن همه اسامی در متن
                                    for (final name in namesToBold) {
                                      if (name.trim().isNotEmpty) {
                                        final regex = RegExp(
                                          RegExp.escape(name.trim()),
                                          caseSensitive: false,
                                          dotAll: true,
                                        );
                                        processedText = processedText
                                            .replaceAllMapped(
                                              regex,
                                              (match) => '<b>${match[0]}</b>',
                                            );
                                      }
                                    }

                                    // Highlight the searchWord if it's not empty (بعد از بولد کردن)
                                    if (searchWord.isNotEmpty) {
                                      final regex = RegExp(
                                        RegExp.escape(searchWord),
                                        caseSensitive: false,
                                      );
                                      processedText = processedText.replaceAllMapped(
                                        regex,
                                        (match) {
                                          // اگر قبلاً بولد شده بود، highlight را در داخل تگ <b> قرار بده
                                          if (match[0]!.contains('<b>')) {
                                            return match[0]!.replaceAllMapped(
                                              RegExp(
                                                r'<b>(.*?)</b>',
                                                caseSensitive: false,
                                              ),
                                              (innerMatch) =>
                                                  '<b><span class="highlight">${innerMatch[1]}</span></b>',
                                            );
                                          }
                                          return '<span class="highlight">${match[0]}</span>';
                                        },
                                      );
                                    }

                                    return processedText;
                                  }).toList(),
                                );

                                await controller.evaluateJavascript(
                                  source:
                                      '''
                                      (function() {
                                        var data = $jsonData;
                                        for (var i = 0; i < data.length; i++) {
                                          var el = document.getElementById("page___" + i);
                                          if (el) el.innerHTML = data[i];
                                        }
                                      })();
                                    ''',
                                );

                                controller.addJavaScriptHandler(
                                  handlerName: 'CommentEvent',
                                  callback: (args) async {
                                    int pageNumber = args[0] + 1;

                                    ModalComment.show(
                                      context,
                                      updateMode: false,
                                      id: pageNumber,
                                      idPage: pageNumber,
                                      idBook: bookId,
                                      bookname: bookName,
                                    );
                                  },
                                );

                                controller.addJavaScriptHandler(
                                  handlerName: 'onSearchPositionChanged',
                                  callback: (args) {
                                    print("======2>>" + args.toString());
                                    if (args.length == 2) {
                                      searchContentController
                                              .currentMatchIndex
                                              .value =
                                          args[0];
                                      searchContentController
                                              .totalMatchCount
                                              .value =
                                          args[1];
                                    }
                                  },
                                );

                                controller.addJavaScriptHandler(
                                  handlerName: 'bookmarkToggled',
                                  callback: (args) async {
                                    var pageNumber = args[0];
                                    var bookmarkData = {
                                      'bookId': bookId,
                                      'pageNumber': pageNumber,
                                      'bookName': bookName,
                                    };

                                    String? savedBookmarks = Constants
                                        .localStorage
                                        .read('bookmark');
                                    List<dynamic> bookmarks = [];
                                    if (savedBookmarks != null) {
                                      var decodedData = jsonDecode(
                                        savedBookmarks,
                                      );

                                      if (decodedData is List) {
                                        bookmarks = decodedData;
                                      } else if (decodedData is Map) {
                                        bookmarks = [decodedData];
                                      }
                                    }

                                    var existingBookmarkIndex = bookmarks
                                        .indexWhere(
                                          (bookmark) =>
                                              bookmark['bookId'] == bookId &&
                                              bookmark['pageNumber'] ==
                                                  pageNumber,
                                        );

                                    if (existingBookmarkIndex != -1) {
                                      bookmarks.removeAt(existingBookmarkIndex);
                                      print('Bookmark removed');
                                    } else {
                                      bookmarks.add(bookmarkData);
                                      print('Bookmark saved: $bookmarkData');
                                    }

                                    Constants.localStorage.write(
                                      'bookmark',
                                      jsonEncode(bookmarks),
                                    );
                                  },
                                );

                                // Scroll SPY
                                if (verticalScroll) {
                                  await controller.evaluateJavascript(
                                    source:
                                        '''
                                      if (${contentController.scrollPosetion.value} != 0) {
                                        var y = getOffset(document.getElementById('book-mark_${contentController.scrollPosetion.value == 0 ? contentController.scrollPosetion.value : contentController.scrollPosetion.value.floor() - 1}')).top;
                                        window.scrollTo(0, y);
                                      };
                                      ''',
                                  );
                                  controller.evaluateJavascript(
                                    source: r"""
                                                $(window).on('scroll', function() {
                                            var currentTop = $(window).scrollTop();
                                            var elems = $('.BookPage-vertical');
                                            elems.each(function(index) {
                                                var elemTop = $(this).offset().top;
                                                var elemBottom = elemTop + $(this).height();
                                                if (currentTop >= elemTop && currentTop <= elemBottom) {
                                                    var page = $(this).attr('data-page');
                                                    window.flutter_inappwebview.callHandler('scrollSpy', page);
                                                }
                                            });
                                                });
                                              """,
                                  );
                                  await controller.evaluateJavascript(
                                    source:
                                        '''
                                      var scrollPosition = ${scrollPosetion == 0 ? 0 : scrollPosetion.floor()};
                                      var element = document.getElementById('book-mark_' + scrollPosition);
                                      if (element != null) {
                                        var y = getOffset(element).top;
                                        window.scrollTo(0, y);
                                      }
                                    ''',
                                  );
                                } else {
                                  controller.evaluateJavascript(
                                    source: r"""
                                    $(document).ready(function () {
                                      var container = $('.book-container-horizontal');

                                      container.on('scroll', function () {
                                        var containerScrollLeft = container.scrollLeft();
                                        var containerWidth = container.width();

                                        $('.BookPage-horizontal').each(function () {
                                          var $page = $(this);
                                          var pageLeft = $page.position().left;
                                          var pageWidth = $page.outerWidth();
                                          var pageRight = pageLeft + pageWidth;

                                          // Check if page is in view
                                          if (
                                            pageLeft < containerWidth &&
                                            pageRight > 0
                                          ) {
                                            var page = $page.attr('data-page');
                                            window.flutter_inappwebview.callHandler('scrollSpy', page);
                                            return false; // break after finding the first visible page
                                          }
                                        });
                                      });
                                    });
                                                """,
                                  );
                                  await controller.evaluateJavascript(
                                    source:
                                        '''
                                      var scrollPosition = ${scrollPosetion == 0 ? 0 : scrollPosetion.floor()};
                                      var element = document.getElementById('book-mark_' + scrollPosition);
                                      var container = document.querySelector('.book-container-horizontal');

                                      if (element && container) {
                                        var elementRect = element.getBoundingClientRect();
                                        var containerRect = container.getBoundingClientRect();
                                        var scrollX = elementRect.left - containerRect.left + container.scrollLeft;
                                        container.scrollTo({ left: scrollX, behavior: 'smooth' });
                                      }
                                    ''',
                                  );
                                }
                                controller.addJavaScriptHandler(
                                  handlerName: 'scrollSpy',
                                  callback: (arguments) {
                                    if (arguments.isNotEmpty &&
                                        double.tryParse(arguments[0]) != null) {
                                      double page = double.parse(arguments[0]);
                                      if (contentController.currentPage.value !=
                                              page &&
                                          page > 0) {
                                        contentController.currentPage.value =
                                            double.parse(arguments[0]);
                                      }
                                      debugPrint("$arguments <<<<=======SPY");
                                    } else {
                                      debugPrint(
                                        "Invalid arguments: $arguments",
                                      );
                                    }
                                  },
                                );
                                controller.evaluateJavascript(
                                  source: r'''
                              $(function () {
                                  $('[data-toggle="tooltip"]').tooltip({
                                    placement: 'bottom',
                                    html: true
                                  });
                                });
                                ''',
                                );

                                await controller.evaluateJavascript(
                                  source: '''
  (function() {
    const targetDivs = document.querySelectorAll('.text_style');
    
    if (!targetDivs || targetDivs.length === 0) return;
    
    targetDivs.forEach(function(targetDiv) {
      let currentScale = 1;
      const minScale = 0.5;
      const maxScale = 3;
      
      // ذخیره استایل اصلی
      const originalStyle = targetDiv.style.cssText;
      const originalContent = targetDiv.innerHTML;
      
      // ایجاد container برای زوم
      const zoomContainer = document.createElement('div');
      zoomContainer.style.width = '100%';
      zoomContainer.style.height = '100%';
      zoomContainer.style.overflow = 'hidden';
      zoomContainer.style.position = 'relative';
      
      // ایجاد wrapper برای محتوا
      const contentWrapper = document.createElement('div');
      contentWrapper.style.transformOrigin = '0 0';
      contentWrapper.style.transition = 'transform 0.1s ease';
      contentWrapper.style.width = '100%';
      contentWrapper.style.height = '100%';
      contentWrapper.innerHTML = targetDiv.innerHTML;
      
      // جایگزینی محتوا
      targetDiv.innerHTML = '';
      zoomContainer.appendChild(contentWrapper);
      targetDiv.appendChild(zoomContainer);
      
      // متغیرهای هندلر
      let initialDistance = 0;
      let initialScale = 1;
      let initialCenterX = 0;
      let initialCenterY = 0;
      let initialScrollLeft = 0;
      let initialScrollTop = 0;
      let isZooming = false;
      let lastTouchEnd = 0;
      
      // محاسبه مرکز بین دو انگشت
      function getCenter(touches) {
        return {
          x: (touches[0].clientX + touches[1].clientX) / 2,
          y: (touches[0].clientY + touches[1].clientY) / 2
        };
      }
      
      // هندلر touchstart
      targetDiv.addEventListener('touchstart', function(e) {
        if (e.touches.length === 2) {
          isZooming = true;
          initialDistance = Math.hypot(
            e.touches[0].clientX - e.touches[1].clientX,
            e.touches[0].clientY - e.touches[1].clientY
          );
          initialScale = currentScale;
          
          // ذخیره مرکز اولیه
          const center = getCenter(e.touches);
          initialCenterX = center.x;
          initialCenterY = center.y;
          
          // ذخیره موقعیت اسکرول فعلی
          initialScrollLeft = zoomContainer.scrollLeft;
          initialScrollTop = zoomContainer.scrollTop;
          
          e.preventDefault();
        }
      }, { passive: false });
      
      // هندلر touchmove
      targetDiv.addEventListener('touchmove', function(e) {
        if (e.touches.length === 2 && isZooming) {
          e.preventDefault();
          e.stopPropagation();
          
          const currentDistance = Math.hypot(
            e.touches[0].clientX - e.touches[1].clientX,
            e.touches[0].clientY - e.touches[1].clientY
          );
          
          if (initialDistance > 0) {
            // محاسبه scale جدید
            let scale = initialScale * (currentDistance / initialDistance);
            scale = Math.min(Math.max(scale, minScale), maxScale);
            
            // محاسبه تغییر scale
            const scaleChange = scale / currentScale;
            
            // محاسبه مرکز فعلی
            const currentCenter = getCenter(e.touches);
            
            // تنظیم transform-origin بر اساس مرکز لمسی
            const rect = zoomContainer.getBoundingClientRect();
            const originX = ((currentCenter.x - rect.left) / rect.width) * 100;
            const originY = ((currentCenter.y - rect.top) / rect.height) * 100;
            
            contentWrapper.style.transformOrigin = originX + '% ' + originY + '%';
            
            // اعمال scale
            currentScale = scale;
            contentWrapper.style.transform = 'scale(' + scale + ')';
            
            // تنظیم ابعاد wrapper
            contentWrapper.style.width = (100 / scale) + '%';
            contentWrapper.style.height = (100 / scale) + '%';
            
            // تنظیم موقعیت اسکرول برای حفظ مرکز
            const scrollLeft = initialScrollLeft + 
              (currentCenter.x - initialCenterX) * (scaleChange - 1);
            const scrollTop = initialScrollTop + 
              (currentCenter.y - initialCenterY) * (scaleChange - 1);
            
            zoomContainer.scrollLeft = scrollLeft;
            zoomContainer.scrollTop = scrollTop;
          }
        }
      }, { passive: false });
      
      // هندلر touchend
      targetDiv.addEventListener('touchend', function(e) {
        if (e.touches.length < 2) {
          isZooming = false;
          initialDistance = 0;
          
          // تشخیص دبل تاپ
          const currentTime = new Date().getTime();
          if (currentTime - lastTouchEnd < 300) {
            // دبل تاپ - بازگشت به اندازه اصلی با انیمیشن
            contentWrapper.style.transition = 'transform 0.3s ease';
            currentScale = 1;
            contentWrapper.style.transform = 'scale(1)';
            contentWrapper.style.transformOrigin = 'center center';
            contentWrapper.style.width = '100%';
            contentWrapper.style.height = '100%';
            
            // ریست اسکرول
            zoomContainer.scrollLeft = 0;
            zoomContainer.scrollTop = 0;
            
            // حذف transition بعد از انیمیشن
            setTimeout(() => {
              contentWrapper.style.transition = 'transform 0.1s ease';
            }, 300);
          }
          lastTouchEnd = currentTime;
        }
      }, { passive: false });
    });
    
    console.log('Enhanced zoom handlers added');
  })();
''',
                                );

                                // await controller.evaluateJavascript(source: '''
                                //   // اضافه کردن CSS برای بهبود تجربه زوم
                                //   const style = document.createElement('style');
                                //   style.textContent = `
                                //     .book_page {
                                //       -webkit-user-select: none;
                                //       user-select: none;
                                //       -webkit-touch-callout: none;
                                //       -webkit-tap-highlight-color: transparent;
                                //       touch-action: pan-y pinch-zoom;
                                //     }

                                //     .book_page * {
                                //       -webkit-user-select: none;
                                //       user-select: none;
                                //     }
                                //   `;
                                //   document.head.appendChild(style);
                                // ''');
                              },
                              onLoadStart: (controller, url) async {},
                            ),
                          ),
                        ),
                        const Gap(5),
                        SizedBox(
                          width: verticalScroll ? 15 : Get.width,
                          height: verticalScroll ? Get.height : 15,
                          child: Obx(() {
                            return FlutterSlider(
                              axis: verticalScroll
                                  ? Axis.vertical
                                  : Axis.horizontal,
                              rtl: verticalScroll ? false : true,
                              values: [contentController.currentPage.value],
                              max: contentController.pages.length.toDouble(),
                              min: 1,
                              tooltip: FlutterSliderTooltip(
                                disabled: false,
                                direction: verticalScroll
                                    ? FlutterSliderTooltipDirection.left
                                    : FlutterSliderTooltipDirection.top,
                                disableAnimation: false,
                                custom: (value) => Padding(
                                  padding: const EdgeInsets.only(right: 0),
                                  child: Card(
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        bottomRight: Radius.circular(8),
                                      ),
                                    ),
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        value.toStringAsFixed(0),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              trackBar: FlutterSliderTrackBar(
                                activeTrackBar: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                ),
                              ),
                              handler: FlutterSliderHandler(
                                child: const SizedBox(),
                              ),
                              onDragCompleted:
                                  (handlerIndex, lower, upper) async {
                                    final controller = contentController
                                        .inAppWebViewController;
                                    if (verticalScroll) {
                                      await controller.evaluateJavascript(
                                        source:
                                            '''
                                          window.scrollTo(0, 0);
                                          var y = getOffset( document.querySelector('[data-page="${lower.floor() - 1}"]') ).top;
                                          window.scrollTo(0, y);
                                          ''',
                                      );
                                    } else {
                                      await controller.evaluateJavascript(
                                        source:
                                            '''
                                  var x = getOffset(document.querySelector('[data-page="${lower.floor() - 1}"]')).left;
                                  horizontal_container.scrollLeft = x;
                                ''',
                                      );
                                    }
                                  },
                            );
                          }),
                        ),
                        const Gap(5),
                      ],
                    ),

                    //  Search Box
                    Obx(() {
                      return AnimatedPositioned(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        top: searchContentController.showSearch.value ? 0 : -70,
                        left: 0,
                        right: 0,
                        height: 70,
                        child: Container(
                          height: 70,
                          color: Theme.of(context).colorScheme.surface,
                          padding: EdgeInsets.all(10),
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onPrimary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Form(
                              key: searchContentController.searchFormKey,
                              child: Row(
                                children: [
                                  // search box
                                  Expanded(
                                    child: TextFormField(
                                      controller: searchContentController
                                          .searchController,
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return 'لا يمكن أن يكون نص البحث فارغاً';
                                        }
                                        if (value.trim().length < 3) {
                                          return 'الرجاء إدخال 3 أحرف على الأقل';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'البحث',
                                        hintStyle: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                          fontSize: 14,
                                        ),
                                      ),
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                    ),
                                  ),

                                  ZoomTapAnimation(
                                    child: SvgPicture.asset(
                                      'assets/svgs/search.svg',
                                      colorFilter: ColorFilter.mode(
                                        Theme.of(context).colorScheme.primary,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    onTap: () {
                                      if (searchContentController
                                          .searchFormKey
                                          .currentState!
                                          .validate()) {
                                        final searchText =
                                            searchContentController
                                                .searchController
                                                .text
                                                .trim();
                                        contentController.inAppWebViewController
                                            .evaluateJavascript(
                                              source:
                                                  "highlight_search('$searchText','highlight')",
                                            );
                                        searchContentController
                                                .showSearcResult
                                                .value =
                                            true;
                                        searchContentController
                                                .showSearch
                                                .value =
                                            false;
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),

                    //  buttons search
                    Obx(
                      () => AnimatedPositioned(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        bottom: searchContentController.showSearcResult.value
                            ? 0
                            : -70,
                        child: Container(
                          width: Get.width,
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: Constants.containerBoxDecoration(context)
                              .copyWith(
                                borderRadius: BorderRadius.circular(0),
                                color: Theme.of(context).colorScheme.surface,
                              ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ZoomTapAnimation(
                                onTap: () {
                                  contentController.inAppWebViewController
                                      .evaluateJavascript(
                                        source: "goToPrevMatchPage();",
                                      );
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: Constants.containerBoxDecoration(
                                    context,
                                  ),
                                  width: 35,
                                  height: 35,
                                  child: SvgPicture.asset(
                                    'assets/svgs/angle-double-right.svg',
                                    width: 12,
                                    height: 12,
                                    colorFilter: ColorFilter.mode(
                                      Colors.white,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                              Obx(
                                () => Text(
                                  '${searchContentController.currentMatchIndex} من ${searchContentController.totalMatchCount}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                              ZoomTapAnimation(
                                onTap: () {
                                  contentController.inAppWebViewController
                                      .evaluateJavascript(
                                        source: "goToNextMatchPage();",
                                      );
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: Constants.containerBoxDecoration(
                                    context,
                                  ),
                                  width: 35,
                                  height: 35,
                                  child: RotatedBox(
                                    quarterTurns: 2,
                                    child: SvgPicture.asset(
                                      'assets/svgs/angle-double-right.svg',
                                      width: 12,
                                      height: 12,
                                      colorFilter: ColorFilter.mode(
                                        Colors.white,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    //  Setting Container
                    Obx(() {
                      return contentController.showContentSettings.value
                          ? GestureDetector(
                              onTap: () {
                                contentController.showContentSettings.value =
                                    false;
                              },
                              child: Container(
                                width: Get.width,
                                height: Get.height,
                                decoration: BoxDecoration(
                                  color: Colors.black38,
                                ),
                                alignment: Alignment.center,
                                child: Container(
                                  constraints: BoxConstraints(maxWidth: 400),
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.surface,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.all(20),
                                  margin: EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Font Size Slider
                                      Text("حجم الخط:"),
                                      SliderTheme(
                                        data: SliderTheme.of(context).copyWith(
                                          trackHeight: 2,
                                          thumbShape: RoundSliderThumbShape(
                                            enabledThumbRadius: 8,
                                          ),
                                          overlayShape: RoundSliderOverlayShape(
                                            overlayRadius: 12,
                                          ),
                                          activeTrackColor: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                          inactiveTrackColor:
                                              Colors.grey.shade300,
                                          thumbColor: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                        child: Slider(
                                          value:
                                              settingsController.fontSize.value,
                                          min: 10,
                                          max: 30,
                                          divisions: 20,
                                          label: settingsController
                                              .fontSize
                                              .value
                                              .round()
                                              .toString(),
                                          onChanged: (value) {
                                            settingsController
                                                    .isApplying
                                                    .value =
                                                true;
                                            settingsController.setFontSize(
                                              value,
                                            );

                                            Future.delayed(
                                              Duration(milliseconds: 500),
                                              () {
                                                contentController
                                                    .inAppWebViewController
                                                    .evaluateJavascript(
                                                      source:
                                                          """
                                                  document.querySelectorAll('.text_style').forEach(function(el) {
                                                    el.style.setProperty('font-size', '${value}px', 'important');
                                                    });
                                                  """,
                                                    )
                                                    .whenComplete(() {
                                                      settingsController
                                                              .isApplying
                                                              .value =
                                                          false;
                                                    });
                                              },
                                            );
                                          },
                                        ),
                                      ),

                                      const Gap(20),
                                      const Text("تباعد الأسطر:"),
                                      SliderTheme(
                                        data: SliderTheme.of(context).copyWith(
                                          trackHeight: 2,
                                          thumbShape: RoundSliderThumbShape(
                                            enabledThumbRadius: 8,
                                          ),
                                          overlayShape: RoundSliderOverlayShape(
                                            overlayRadius: 12,
                                          ),
                                          activeTrackColor: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                          inactiveTrackColor:
                                              Colors.grey.shade300,
                                          thumbColor: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                        child: Slider(
                                          value: settingsController
                                              .lineHeight
                                              .value,
                                          min: 1,
                                          max: 3,
                                          divisions: 10,
                                          label: settingsController
                                              .lineHeight
                                              .value
                                              .toStringAsFixed(1),
                                          onChanged: (value) {
                                            settingsController
                                                    .isApplying
                                                    .value =
                                                true;
                                            settingsController.setLineHeight(
                                              value,
                                            );
                                            Future.delayed(
                                              Duration(milliseconds: 300),
                                              () {
                                                contentController
                                                    .inAppWebViewController
                                                    .evaluateJavascript(
                                                      source:
                                                          """
                                                document.querySelectorAll('.text_style').forEach(function(el) {
                                                  el.style.setProperty('line-height', '$value', 'important');
                                                });
                                              """,
                                                    )
                                                    .whenComplete(() {
                                                      settingsController
                                                              .isApplying
                                                              .value =
                                                          false;
                                                    });
                                              },
                                            );
                                          },
                                        ),
                                      ),

                                      const Gap(20),
                                      const Text("نوع الخط:"),
                                      const Gap(10),
                                      // Font Type Dropdown
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: Colors.grey.shade300,
                                            width: 1,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 4,
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            value: settingsController
                                                .fontFamily
                                                .value,
                                            isExpanded: true,
                                            items: const [
                                              DropdownMenuItem(
                                                value: 'لوتوس',
                                                child: Text("لوتوس"),
                                              ),
                                              DropdownMenuItem(
                                                value: 'البهيج',
                                                child: Text("البهيج"),
                                              ),
                                              DropdownMenuItem(
                                                value: 'دجلة',
                                                child: Text("دجلة"),
                                              ),
                                            ],
                                            onChanged: (value) async {
                                              settingsController.setFontFamily(
                                                value!,
                                              );
                                              settingsController
                                                      .isApplying
                                                      .value =
                                                  true;

                                              final css =
                                                  await contentController
                                                      .loadFont();

                                              Future.delayed(
                                                Duration(milliseconds: 500),
                                                () async {
                                                  await contentController
                                                      .inAppWebViewController
                                                      .evaluateJavascript(
                                                        source:
                                                            """
                                                    var style = document.getElementById('customFontStyle');
                                                    if (!style) {
                                                      style = document.createElement('style');
                                                      style.id = 'customFontStyle';
                                                      document.head.appendChild(style);
                                                    }
                                                    style.innerHTML = `$css`;

                                                    document.querySelectorAll('.text_style').forEach(function(el) {
                                                      el.style.setProperty('font-family', '$value', 'important');
                                                    });
                                                  """,
                                                      );
                                                  settingsController
                                                          .isApplying
                                                          .value =
                                                      false;
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ),

                                      const Gap(20),

                                      // Background Color Selection
                                      const Text("لون الخلفية:"),
                                      const Gap(10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          _buildColorCircle(
                                            Colors.white,
                                            settingsController,
                                            contentController,
                                          ),
                                          _buildColorCircle(
                                            Color(0xFFDAD0A7),
                                            settingsController,
                                            contentController,
                                          ),
                                          _buildColorCircle(
                                            Colors.grey,
                                            settingsController,
                                            contentController,
                                          ),
                                        ],
                                      ),
                                      const Gap(10),
                                      Obx(
                                        () =>
                                            settingsController.isApplying.value
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 8,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: 16,
                                                      height: 16,
                                                      child: CustomLoading(),
                                                    ),
                                                    SizedBox(width: 8),
                                                    Text(
                                                      "جاري تطبيق التغييرات...",
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : SizedBox.shrink(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : SizedBox.shrink();
                    }),

                    //  Comment

                    //            showModalBottomSheet(
                    //   context: context,
                    //   isScrollControlled: true,
                    //   builder: (context) {
                    //     return Text('Hello from Modal');
                    //   },
                    // );
                  ],
                )
              : SizedBox.shrink();
        }),
      ),
    );
  }
}

Widget _buildColorCircle(
  Color color,
  SettingsController settingsController,
  ContentController contentController,
) {
  return GestureDetector(
    onTap: () {
      settingsController.isApplying.value = true;
      settingsController.setBackgroundColor(color);
      final hexColor = '#${color.value.toRadixString(16).substring(2)}';

      Future.delayed(Duration(milliseconds: 300), () {
        contentController.inAppWebViewController
            .evaluateJavascript(
              source:
                  """
        document.querySelectorAll('.book_page').forEach(function(el) {
          el.style.setProperty('background-color', '$hexColor', 'important');
        });
      """,
            )
            .whenComplete(() {
              settingsController.isApplying.value = false;
            });
      });
    },
    child: Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: settingsController.backgroundColor.value == color
                  ? Colors.red
                  : Colors.grey,
              width: 1,
            ),
          ),
        ),
      ],
    ),
  );
}
