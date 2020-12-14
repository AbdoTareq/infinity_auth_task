import 'package:flutter/material.dart';
import 'package:flutter_template/utils/langs/lang_keys.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/HomePage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(kLogout.tr),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/images/logo.png'),
        ),
      ),
    );
  }
}
