import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template/constants.dart';
import 'package:flutter_template/utils/langs/lang_keys.dart';
import 'package:flutter_template/view/pages/auth_page.dart';
import 'package:flutter_template/view/pages/home_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

// used in 3 screens(LoginScreen, ForgetPassScreen, VerifyScreen)
class AuthController extends GetxController {
  // used for signup or login
  RxBool _isSignIn = true.obs;
  bool get isSignIn => this._isSignIn.value;

  final storage = GetStorage();
  final GlobalKey<FormState> formKey = GlobalKey();
  

  TextEditingController mailTextController;
  TextEditingController passwordTextController;

  FirebaseAuth _auth = FirebaseAuth.instance;
  Rx<User> _firebaseUser = Rx<User>();
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  @override
  void onInit() {
    super.onInit();
    _firebaseUser.bindStream(_auth.authStateChanges());
    mailTextController = TextEditingController();
    passwordTextController = TextEditingController();
  }

  toggleLogin() => _isSignIn.toggle();

  void submit(Future<UserCredential> Function() authFun) async {
    if (formKey.currentState.validate()) {
      try {
        UserCredential credential = await authFun();
        storage.write('mail', credential.user.email);
        storage.write('signMethod', 'mailPass');
        _resetFields();
        Get.offAll(HomePage());
      } catch (e) {
        Get.back();
        Get.snackbar("Error", e.message,
            duration: Duration(seconds: 6), backgroundColor: Colors.red, snackPosition: SnackPosition.BOTTOM, margin: EdgeInsets.all(8));
      }
    } else
      showWarningDialog(text: kFields_war.tr);
  }

  void signup() async {
    submit(() {
      return _auth.createUserWithEmailAndPassword(email: mailTextController.text.trim(), password: passwordTextController.text);
    });
  }

  void _resetFields() {
    mailTextController.text = '';
    passwordTextController.text = '';
  }

  void signin() async {
    submit(() {
      return _auth.signInWithEmailAndPassword(email: mailTextController.text.trim(), password: passwordTextController.text);
    });
  }

  void signWithGoogle() async {
    Get.dialog(Center(child: CircularProgressIndicator()), barrierDismissible: false);

    try {
      final GoogleSignInAccount googleUSer = await _googleSignIn.signIn();
      storage.write('mail', googleUSer.email);
      storage.write('signMethod', 'google');
      Get.offAll(HomePage());
      Get.snackbar(
        "Success",
        googleUSer.toString(),
        duration: Duration(seconds: 6),
        backgroundColor: Colors.green,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.back();
      Get.snackbar(
        "Error signing in",
        e.message,
        duration: Duration(seconds: 6),
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void signOut() async {
    try {
      storage.read('signMethod') != 'google' ? await _auth.signOut() : await _googleSignIn.signOut();
      Get.offAll(AuthPage());
      storage.remove('mail');
    } catch (e) {
      Get.snackbar(
        "Error signing out",
        e.message,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // username & pass aren't disposed as I need them in more than a screen
  @override
  void onClose() {
    super.onClose();
  }
}
