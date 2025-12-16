import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:love/app/features/about/view/screens/about_page.dart';
import 'package:love/app/features/favorite%20&%20comment/view/screens/favorite_page.dart';
import 'package:love/app/features/home/view/controller/navigation_controller.dart';
import 'package:love/app/features/home/view/screens/subject_page.dart';
import 'package:love/app/features/home/view/widgets/bottom_navigation_bar.dart';
import 'package:love/app/features/home/view/widgets/custom_drawer.dart';
import 'package:love/app/features/search/view/screens/search_page.dart';
import 'package:love/app/features/setting/view/screens/setting_page.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final BottmNavigationController navigationController =
        Get.find<BottmNavigationController>();
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Row(
          children: [
            ZoomTapAnimation(
              onTap: () {
                scaffoldKey.currentState?.openDrawer();
              },
              child: SvgPicture.asset(
                'assets/svgs/menu-burger.svg',
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.onPrimary,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const Gap(10),
            Text(
              "الحبوة",
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        titleTextStyle: TextStyle(
          fontSize: 18,
          color: Colors.black,
          fontFamily: 'SegoeUI',
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
        shadowColor: Colors.black26,
        leading: null,
        actions: [
          ZoomTapAnimation(
            onTap: () {
              Get.to(SearchPage());
            },
            child: Container(
              margin: EdgeInsets.only(left: 10),
              child: SvgPicture.asset(
                'assets/svgs/search.svg',
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.onPrimary,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: CustomDrawer(sliderDrawerKey: scaffoldKey),
      body: SafeArea(
        top: false,
        bottom: true,
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Obx(
            () => PageView(
              controller: navigationController.pageController.value,
              onPageChanged: navigationController.animatedToPage,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                const SubjectPage(),
                SettingPage(isDrawer: false),
                AboutPage(isDrawer: false),
                FavoritePage(isDrawer: false),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CostumBottomNavigationBar(),
    );
  }
}
