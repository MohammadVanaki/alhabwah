import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:love/app/features/home/view/controller/navigation_controller.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class CostumBottomNavigationBar extends StatelessWidget {
  final BottmNavigationController navigationController =
      Get.find<BottmNavigationController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width - 80,
      height: 60,
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(4, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _bottomAppBarItem(
            icon: 'house',
            page: 0,
            context: context,
            selectIcon: 'fill/house-chimney',
            title: 'الرئيسية',
          ),
          _bottomAppBarItem(
            icon: 'settings',
            page: 1,
            context: context,
            selectIcon: 'fill/settings',
            title: 'الاعدادات',
          ),
          _bottomAppBarItem(
            icon: 'info',
            page: 2,
            context: context,
            selectIcon: 'fill/info',
            title: 'حول التطبيق',
          ),
          _bottomAppBarItem(
            icon: 'star',
            page: 3,
            context: context,
            selectIcon: 'fill/star-fill',
            title: 'اشارات',
          ),
        ],
      ),
    );
  }

  Widget _bottomAppBarItem({
    required String icon,
    required String title,
    required String selectIcon,
    required int page,
    required BuildContext context,
  }) {
    return ZoomTapAnimation(
      onTap: () {
        navigationController.goToPage(page);
      },
      child: Obx(() {
        final isSelected = navigationController.currentPage.value == page;
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: Center(
                child: SvgPicture.asset(
                  'assets/svgs/${isSelected ? selectIcon : icon}.svg',
                  colorFilter: ColorFilter.mode(
                    isSelected
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(
                            context,
                          ).colorScheme.onPrimary.withAlpha(120),
                    BlendMode.srcIn,
                  ),
                  width: 25,
                  height: 25,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 8,
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(
                            context,
                          ).colorScheme.onPrimary.withAlpha(120),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
