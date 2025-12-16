import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:love/app/config/get_version.dart';
import 'package:love/app/config/launch_url.dart';
import 'package:love/app/config/share_app.dart';
import 'package:love/app/core/routes/routes.dart';
import 'package:love/app/features/about/view/screens/about_page.dart';
import 'package:love/app/features/favorite%20&%20comment/view/screens/favorite_page.dart';
import 'package:love/app/features/news/view/pages/news_page.dart';
import 'package:love/app/features/rawafid/view/screens/rawafid_page.dart';
import 'package:love/app/features/setting/view/screens/setting_page.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key, required this.sliderDrawerKey});
  final GlobalKey<ScaffoldState> sliderDrawerKey;

  @override
  Widget build(BuildContext context) {
    // final settingsController = Get.find<SettingsController>();

    final AppVersionController appVersionController =
        Get.find<AppVersionController>();

    final List<Map<String, dynamic>> drawerItemList = [
      {
        "title": 'الرئيسية',
        "icon": 'house',
        "onTap": () {
          sliderDrawerKey.currentState?.closeDrawer();
        },
      },

      {
        "title": 'حول التطبيق',
        "icon": 'clipboard-user',
        "onTap": () {
          Get.to(const AboutPage(isDrawer: true));
        },
      },

      // {"title": 'المفضلة', "icon": 'star', "onTap": () {}},
      {
        "title": 'الاعدادات',
        "icon": 'settings',
        "onTap": () {
          Get.to(SettingPage(isDrawer: true));
        },
      },
      {
        "title": 'سياسية الخصوصية',
        "icon": 'confidential-discussion',
        "onTap": () {
          urlLauncher(
            'https://dijlah.org/privacy_policy/privacy_alhabwah.html',
          );
        },
      },
      {
        "title": 'المفضلة والاشارات المرجعية',
        "icon": 'wishlist-star',
        "onTap": () {
          Get.to(FavoritePage(isDrawer: true));
        },
      },
      {
        "title": 'روافد',
        "icon": 'streaming',
        "onTap": () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RawafidPage()),
          );
        },
      },
      {
        "title": 'مستجدات',
        "icon": 'newspaper',
        "onTap": () {
          Get.back();
          Get.to(() => const NewsPage());
        },
      },
      {
        "title": 'مشاركة التطبيق',
        "icon": 'share-square',
        "onTap": () {
          shareApp(context);
        },
      },
    ];

    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.zero),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(child: Image.asset('assets/images/drawer_header.png')),

          ...List.generate(drawerItemList.length, (index) {
            return index < drawerItemList.length - 1
                ? drawerItemWidget(
                    title: drawerItemList[index]['title'],
                    icon: drawerItemList[index]['icon'],
                    onTap: drawerItemList[index]['onTap'],
                    totalItems: drawerItemList.length,
                    tag: index,
                    context: context,
                  )
                : Column(
                    children: [
                      const Divider(),
                      drawerItemWidget(
                        title: drawerItemList[index]['title'],
                        icon: drawerItemList[index]['icon'],
                        onTap: drawerItemList[index]['onTap'],
                        totalItems: drawerItemList.length,
                        tag: index,
                        context: context,
                      ),
                    ],
                  );
          }),
          // Obx(
          //   () => ListTile(
          //     leading: SvgPicture.asset(
          //       'assets/svgs/moon.svg',
          //       colorFilter: ColorFilter.mode(
          //         Theme.of(context).colorScheme.onPrimary,
          //         BlendMode.srcIn,
          //       ),
          //     ),
          //     title: const Text(
          //       'تبديل الوضع الليلي',
          //       style: TextStyle(fontSize: 14),
          //     ),
          //     // trailing: Transform.scale(
          //     //   scale: 0.75,
          //     //   child: Switch(
          //     //     value: settingsController.isDarkMode.value,
          //     //     onChanged: (value) {
          //     //       settingsController.isDarkMode.value = value;

          //     //       final ThemeColorScheme themeToUse = value
          //     //           ? settingsController.darkColorScheme
          //     //           : settingsController.selectedColorScheme.value;

          //     //       print('🌗 سوئیچ شد به حالت: ${value ? "تاریک" : "روشن"}');
          //     //       print('🎯 رنگ انتخاب‌شده برای تم:');
          //     //       print('🔹 primary: ${themeToUse.primary.value}');
          //     //       print('🔹 onPrimary: ${themeToUse.onPrimary.value}');
          //     //       print('🔹 surface: ${themeToUse.surface.value}');

          //     //       settingsController.setTheme(
          //     //         settingsController.themeColorSchemes[0],
          //     //         isDarkMode: value,
          //     //         themeindex: settingsController.themeIndex.value,
          //     //       );

          //     //       Constants.localStorage.write('isDarkMode', value);
          //     //     },
          //     //   ),
          //     // ),
          //     onTap: () {},
          //   ),
          // ),

          // Spacer(),
          Column(
            children: [
              const Gap(100),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: 'الاصدار: ', style: TextStyle(fontSize: 12)),
                    TextSpan(
                      text: appVersionController.version.value,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Gap(5),
              ZoomTapAnimation(
                onTap: () {
                  urlLauncher('https://dijlah.org');
                },
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Powered by ',
                        style: TextStyle(fontSize: 13),
                      ),
                      TextSpan(
                        text: 'DIjlah IT',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ListTile drawerItemWidget({
    required String title,
    required String icon,
    required int tag,
    required int totalItems,
    required Function() onTap,
    required BuildContext context,
  }) {
    bool isLastItem = tag == totalItems - 1;
    return ListTile(
      leading: SvgPicture.asset(
        'assets/svgs/$icon.svg',
        colorFilter: ColorFilter.mode(
          Theme.of(context).colorScheme.onPrimary,
          BlendMode.srcIn,
        ),
      ),
      title: Text(title, style: TextStyle(fontSize: 14)),
      trailing: !isLastItem
          ? SvgPicture.asset(
              'assets/svgs/angle-left.svg',
              width: 12,
              height: 12,
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.onPrimary,
                BlendMode.srcIn,
              ),
            )
          : const SizedBox(),
      onTap: onTap,
    );
  }
}
