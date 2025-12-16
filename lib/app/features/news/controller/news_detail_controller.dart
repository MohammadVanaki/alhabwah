// lib/app/features/news/controller/news_detail_controller.dart
import 'package:get/get.dart';
import 'package:love/app/core/network/api_client.dart';
import '../data/models/news_model.dart';

class NewsDetailController extends GetxController {
  final ApiClient _apiClient = Get.find();

  final Rx<NewsModel?> newsDetail = Rx<NewsModel?>(null);
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;

  Future<void> fetchNewsDetail(int newsId) async {
    try {
      isLoading.value = true;
      error.value = '';
      newsDetail.value = null;

      final response = await _apiClient.get(
        '/api/news/$newsId',
        queryParameters: {},
      );

      if (response['status'] == true) {
        final data = response['data'];
        if (data is List && data.isNotEmpty) {
          newsDetail.value = NewsModel.fromJson(data[0]);
        } else if (data is Map<String, dynamic>) {
          newsDetail.value = NewsModel.fromJson(data);
        }
      } else {
        error.value = 'لا يمكن تحميل تفاصيل الخبر';
      }
    } catch (e) {
      error.value = 'خطأ في تحميل التفاصيل: $e';
      print('Error fetching news detail: $e');
    } finally {
      isLoading.value = false;
    }
  }

  String cleanHtml(String html) {
    return html
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}
