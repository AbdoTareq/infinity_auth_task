import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template/controllers/app_binding.dart';
import 'package:flutter_template/utils/langs/my_translation.dart';
import 'package:flutter_template/view/pages/auth_page.dart';
import 'package:flutter_template/view/animated_splash.dart';
import 'package:flutter_template/view/pages/home_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';

import 'constants.dart';
import 'controllers/auth_controller.dart';

Future<void> main() async {
  await GetStorage.init();
  await Firebase.initializeApp();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: kPrimaryColor // status bar color
      ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // this for alice debugging network calls
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Infinity Auth Task',
      // this for auto detect device language
      locale: Get.window.locale,
      fallbackLocale: Locale('en'),
      translations: MyTranslation(),
      initialBinding: AppBinding(),
      theme: ThemeData(
        primarySwatch: kPrimaryColor,
        fontFamily: 'Cairo',
      ),
      home: AnimatedSplash(
        imagePath: 'assets/images/logo.png',
        title: 'Infinity Auth Task',
        home: GetX<AuthController>(
          init: AuthController(),
          builder: (controller) {
            return controller.token.isEmpty ? AuthPage() : HomePage();
          },
        ),
        duration: 2500,
        type: AnimatedSplashType.StaticDuration,
      ),
    );
  }
}
