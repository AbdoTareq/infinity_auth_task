import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template/utils/my_translation.dart';
import 'package:flutter_template/view/HomePage.dart';
import 'package:flutter_template/view/animated_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'constants.dart';

Future<void> main() async {
  await GetStorage.init();
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: kPrimaryColor // status bar color
          ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
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
      title: 'Flutter Demo',
      // locale: egyptianArabic,
      translations: MyTranslation(),
      // defaultTransition: Transition.leftToRight,
      theme: ThemeData(
        primarySwatch: kPrimaryColor,
        fontFamily: 'Cairo',
      ),
      home: AnimatedSplash(
        imagePath: 'assets/images/logo.png',
        title: 'Digital clinic',
        home: HomePage(),
        duration: 2500,
        type: AnimatedSplashType.StaticDuration,
      ),
    );
  }
}
