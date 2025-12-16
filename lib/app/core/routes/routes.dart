import 'package:get/get.dart';
import 'package:love/app/features/home/view/screens/home_page.dart';
import 'package:love/app/features/splash/view/screens/splash_page.dart';

class Routes {
  static const String home = '/';
  static const String splash = '/splash';
  static const String onBording = '/onBording';
  static const String setting = '/setting';
  static const String subjectsPage = '/subjectsPage';

  static final List<GetPage> pages = [
    GetPage(name: splash, page: () => const SplashPage()),
    GetPage(name: home, page: () => HomePage()),
    // GetPage(name: setting, page: () => SettingPage()),
  ];
}
