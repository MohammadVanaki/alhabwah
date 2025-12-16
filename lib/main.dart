import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:love/app/config/theme.dart';
import 'package:love/app/core/common/constants/constants.dart';
import 'package:love/app/core/init/init.dart';
import 'package:love/app/core/routes/routes.dart';
import 'package:love/app/features/setting/view/controller/settings_controller.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_api_availability/google_api_availability.dart';
import 'package:love/notif/firebase_notification_service.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await init();

  if (Platform.isAndroid) {
    try {
      await checkGooglePlayServices().timeout(const Duration(seconds: 4));
    } catch (e) {
      debugPrint(
        'Timeout: Google Play Services check took too long, skipping.',
      );
    }
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SettingsController());
    return Padding(
      padding: EdgeInsets.only(
        bottom: Platform.isAndroid
            ? MediaQuery.of(context).viewPadding.bottom
            : 0,
      ),
      child: Obx(() {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(1.0)),
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en'), Locale('ar')],
            locale: const Locale('ar'),
            title: Constants.appTitle,
            themeMode: ThemeMode.light,
            theme: MyThemes.lightTheme,
            darkTheme: MyThemes.darkTheme,
            initialRoute: Routes.splash,
            getPages: Routes.pages,
          ),
        );
      }),
    );
  }
}

Future<void> checkGooglePlayServices() async {
  GooglePlayServicesAvailability availability = await GoogleApiAvailability
      .instance
      .checkGooglePlayServicesAvailability();

  if (availability != GooglePlayServicesAvailability.success) {
    debugPrint('Google Play Services not available: $availability');

    debugPrint(
      'Google Play Services is not available: ${availability.toString()}',
    );
  } else {
    debugPrint('Google Play Services is available.');

    try {
      await Firebase.initializeApp().timeout(const Duration(seconds: 5));
    } catch (e) {
      debugPrint('Firebase init failed or timed out: $e');
    }

    FirebaseMessaging.onBackgroundMessage(handleFirebaseBackgroundMessage);

    await FirebaseNotificationService().initializeNotifications();
  }
}
