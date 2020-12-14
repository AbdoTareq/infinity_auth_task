import 'package:flutter/material.dart';
import 'package:flutter_template/controllers/auth_controller.dart';
import 'package:flutter_template/utils/langs/lang_keys.dart';
import 'package:flutter_template/view/widgets/pass_field.dart';
import 'package:flutter_template/view/widgets/submit_btn.dart';
import 'package:flutter_template/view/widgets/username_field.dart';
import 'package:get/get.dart';

import '../../constants.dart';

class AuthPage extends GetView<AuthController> {
  static const routeName = '/AuthPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Form(
            key: controller.formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  UsernameField(
                    tEController: controller.mailTextController,
                  ),
                  PassField(
                    passwordTextController: controller.passwordTextController,
                    hint: kPass,
                    spaceAfter: true,
                    function: controller.isSignIn ? controller.signin : controller.signup,
                    validate: (value) => value.isEmpty ? kPassWar.tr : null,
                  ),
                  SizedBox(
                    width: 160,
                    child: Obx(() => SubmitBtn(
                          function: controller.isSignIn ? controller.signin : controller.signup,
                          text: controller.isSignIn ? kLogin.tr : kSignup.tr,
                        )),
                  ),
                  Obx(() => InkWell(
                        onTap: () => controller.toggleLogin(),
                        child: Text(
                          !controller.isSignIn ? kLogin.tr : kSignup.tr,
                          style: TextStyle(color: kPrimaryColor, fontSize: 20),
                        ),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: controller.signWithGoogle,
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/g_logo.png'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
