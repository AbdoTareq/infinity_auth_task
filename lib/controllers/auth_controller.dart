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

  RxString _token = ''.obs;
  get token => this._token.value;
  set token(value) => this._token.value = value;

  TextEditingController mailTextController;
  TextEditingController passwordTextController;

  FirebaseAuth _auth = FirebaseAuth.instance;
  Rx<User> _firebaseUser = Rx<User>();
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  @override
  void onInit() {
    super.onInit();
    token = storage.hasData('token') ? storage.read('token') : '';
    _firebaseUser.bindStream(_auth.authStateChanges());
    mailTextController = TextEditingController();
    passwordTextController = TextEditingController();
  }

  toggleLogin() => _isSignIn.toggle();

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

  void submit(Future<UserCredential> Function() authFun) async {
    if (formKey.currentState.validate()) {
      try {
        Get.dialog(Center(child: CircularProgressIndicator()), barrierDismissible: false);

        UserCredential credential = await authFun();
        storage.write('mail', credential.user.email);
        storage.write('token', await credential.user.getIdToken());
        token = await credential.user.getIdToken();
        logger.i("$token");

        storage.write('signMethod', 'mailPass');
        _resetFields();
      } catch (e) {
        Get.back();
        Get.snackbar("Error", e.message,
            duration: Duration(seconds: 6), backgroundColor: Colors.red, snackPosition: SnackPosition.BOTTOM, margin: EdgeInsets.all(8));
      } finally {
        if (Get.isDialogOpen) {
          Get.back();
        }
      }
    } else
      showWarningDialog(text: kFields_war.tr);
  }

  void signWithGoogle() async {
    Get.dialog(Center(child: CircularProgressIndicator()), barrierDismissible: false);

    try {
      // these for signing with google ther get data from google
      final GoogleSignInAccount googleUSer = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleUSer.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      // this to record the user into firebase accounts
      final UserCredential authResult = await _auth.signInWithCredential(credential);
      final User user = authResult.user;
      if (user != null) {
        assert(!user.isAnonymous);
        assert(await user.getIdToken() != null);

        final User currentUser = _auth.currentUser;
        assert(user.uid == currentUser.uid);
      }

      storage.write('mail', googleUSer.email);
      storage.write('signMethod', 'google');

      token = googleUSer.id;
      storage.write('token', googleSignInAuthentication.idToken);
      googleSignInAuthentication.printInfo();
      logger.i("${googleSignInAuthentication.idToken}");
    } catch (e) {
      Get.snackbar(
        "Error signing in",
        e.message,
        duration: Duration(seconds: 6),
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (Get.isDialogOpen) {
        Get.back();
      }
    }
  }

  void signOut() async {
    try {
      storage.read('signMethod') != 'google' ? await _auth.signOut() : await _googleSignIn.signOut();
      storage.remove('token');
      token = '';
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
