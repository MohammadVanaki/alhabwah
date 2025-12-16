import 'package:flutter/material.dart';
import 'package:get/get.dart';

// 💡 Controller for managing bottom navigation bar state
class BottomNavigationController extends GetxController {
  // Reactive selected index
  final RxInt selectedIndex = 0.obs;

  // Called when a navigation item is tapped
  void onItemTapped(int index) {
    selectedIndex.value = index;
  }

  final List<IconData> icons = const [
    Icons.home_rounded,
    Icons.info_outline_rounded,
    Icons.settings_rounded,
    Icons.favorite_rounded,
  ];
}
