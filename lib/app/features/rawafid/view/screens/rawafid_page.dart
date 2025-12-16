// lib/app/features/rawafid/view/pages/rawafid_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/rawafid_controller.dart';
import '../widgets/rawafid_item.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';

class RawafidPage extends StatelessWidget {
  final RawafidController controller = Get.put(RawafidController());

  RawafidPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('روافد'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshData,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const RawafidLoading();
        }

        if (controller.error.value.isNotEmpty) {
          return RawafidError(
            error: controller.error.value,
            onRetry: controller.refreshData,
          );
        }

        if (controller.rawafidList.isEmpty) {
          return const Center(child: Text('لا توجد بيانات'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.rawafidList.length,
          itemBuilder: (context, index) {
            final rawafid = controller.rawafidList[index];
            return RawafidItem(rawafid: rawafid);
          },
        );
      }),
    );
  }
}
