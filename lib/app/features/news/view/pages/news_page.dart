// lib/app/features/news/view/pages/news_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:love/app/features/news/controller/news_controller.dart';
import '../widgets/news_item.dart';
import '../widgets/news_loading.dart';
import '../widgets/news_error.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final NewsController controller = Get.put(NewsController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        controller.loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مستجدات'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshNews,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.newsList.isEmpty) {
          return const NewsLoading();
        }

        if (controller.error.value.isNotEmpty && controller.newsList.isEmpty) {
          return NewsError(
            error: controller.error.value,
            onRetry: controller.refreshNews,
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            controller.refreshNews();
          },
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: controller.newsList.length + 1,
            itemBuilder: (context, index) {
              if (index < controller.newsList.length) {
                final news = controller.newsList[index];
                return NewsItem(news: news);
              } else {
                if (controller.hasMore.value) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: Text('تم تحميل جميع الأخبار')),
                  );
                }
              }
            },
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
