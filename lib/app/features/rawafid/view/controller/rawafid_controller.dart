// lib/app/features/rawafid/controller/rawafid_controller.dart
import 'package:get/get.dart';
import 'package:love/app/core/network/api_client.dart';
import 'package:love/app/features/rawafid/data/models/rawafid_model.dart';

class RawafidController extends GetxController {
  final ApiClient _apiClient = Get.find();

  final RxList<RawafidModel> rawafidList = <RawafidModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRawafid();
  }

  Future<void> fetchRawafid() async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await _apiClient.get(
        '/api/rawafid',
        queryParameters: {},
      );

      if (response['status'] == true) {
        final data = response['data']['data'] as List;
        rawafidList.value = data
            .map((item) => RawafidModel.fromJson(item))
            .toList();
      } else {
        error.value = 'لا توجد بيانات';
      }
    } catch (e) {
      error.value = 'خطأ في جلب البيانات: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void refreshData() {
    fetchRawafid();
  }
}
