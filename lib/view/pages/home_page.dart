import 'package:flutter/material.dart';
import 'package:flutter_template/controllers/auth_controller.dart';
import 'package:flutter_template/view/widgets/submit_btn.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/HomePage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                GetStorage().read('mail'),
                style: TextStyle(fontSize: 24),
              ),
              SubmitBtn(text: 'signout', function: Get.find<AuthController>().signOut),
            ],
          ),
        ),
      ),
    );
  }
}
