// lib/app/features/news/controller/news_controller.dart
import 'package:get/get.dart';
import 'package:love/app/core/network/api_client.dart';
import '../data/models/news_model.dart';

class NewsController extends GetxController {
  final ApiClient _apiClient = Get.find();

  final RxList<NewsModel> newsList = <NewsModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final RxBool hasMore = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNews();
  }

  Future<void> fetchNews({int page = 1}) async {
    try {
      if (page == 1) {
        isLoading.value = true;
        newsList.clear();
      }

      error.value = '';

      final response = await _apiClient.get('/api/news', queryParameters: {});

      if (response['status'] == true) {
        final data = response['data'];
        final items = data['data'] as List;

        newsList.addAll(items.map((item) => NewsModel.fromJson(item)).toList());

        currentPage.value = data['current_page'] ?? 1;
        totalPages.value = data['last_page'] ?? 1;
        hasMore.value = currentPage.value < totalPages.value;
      } else {
        error.value = 'لا توجد أخبار';
      }
    } catch (e) {
      error.value = 'خطأ في جلب الأخبار: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void refreshNews() {
    fetchNews(page: 1);
  }

  void loadMore() {
    if (!isLoading.value && hasMore.value) {
      fetchNews(page: currentPage.value + 1);
    }
  }
}
