import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:love/app/features/news/controller/news_detail_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/news_model.dart';

class NewsDetailPage extends StatelessWidget {
  final int newsId;
  final NewsModel? initialNews;

  const NewsDetailPage({super.key, required this.newsId, this.initialNews});

  @override
  Widget build(BuildContext context) {
    final NewsDetailController controller = Get.put(
      NewsDetailController(),
      tag: 'news_detail_$newsId',
    );

    if (initialNews != null) {
      controller.newsDetail.value = initialNews;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.newsDetail.value == null) {
        controller.fetchNewsDetail(newsId);
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الخبر'), centerTitle: true),
      body: Obx(() {
        if (controller.isLoading.value && controller.newsDetail.value == null) {
          return _buildLoading();
        }

        if (controller.error.value.isNotEmpty) {
          return _buildError(controller);
        }

        final news = controller.newsDetail.value;
        if (news == null) {
          return _buildNoData();
        }

        return _buildNewsDetail(context, news, controller);
      }),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('جاري تحميل التفاصيل...'),
        ],
      ),
    );
  }

  Widget _buildError(NewsDetailController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              controller.error.value,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[700], fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => controller.fetchNewsDetail(newsId),
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoData() {
    return const Center(child: Text('لا توجد تفاصيل للخبر'));
  }

  Widget _buildNewsDetail(
    BuildContext context,
    NewsModel news,
    NewsDetailController controller,
  ) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (news.imageUrl.isNotEmpty)
            Container(
              color: Colors.grey[200],
              child: CachedNetworkImage(
                imageUrl: news.imageUrl,
                width: double.infinity,
                fit: BoxFit.contain,
                placeholder: (context, url) => Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[200],
                  padding: const EdgeInsets.all(50),
                  child: const Icon(
                    Icons.broken_image,
                    size: 60,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      news.formattedDate,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Text(
                  news.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // const Text(
                      //   'محتوى الخبر:',
                      //   style: TextStyle(
                      //     fontSize: 16,
                      //     fontWeight: FontWeight.bold,
                      //     color: Colors.blue,
                      //   ),
                      // ),
                      // const SizedBox(height: 12),
                      Text(
                        controller.cleanHtml(news.content),
                        style: const TextStyle(
                          fontSize: 15,
                          height: 2,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _shareNews(context, news, controller);
                        },
                        icon: const Icon(Icons.share, size: 20),
                        label: const Text(
                          'مشاركة الخبر', // متن تغییر کرد
                          style: TextStyle(fontSize: 14),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back, size: 20),
                        label: const Text(
                          'رجوع',
                          style: TextStyle(fontSize: 14),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _shareNews(
    BuildContext context,
    NewsModel news,
    NewsDetailController controller,
  ) async {
    final cleanedContent = controller.cleanHtml(news.content);
    final shareText = '${news.title}\n\n$cleanedContent';

    try {
      await Share.share(shareText, subject: news.title);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('حدث خطأ في المشاركة'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
