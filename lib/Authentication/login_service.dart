import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:password_manager/Authentication/login_controller.dart';
import 'package:password_manager/Authentication/login_page.dart';
import 'package:password_manager/Pages/password_add_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  GoogleSignIn get _googleSignIn => GoogleSignIn(
    scopes: ['email', 'profile'],
    forceCodeForRefreshToken: true,
  );

  Future<User?> signInwithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        debugPrint(" Google sign-in cancelled");
        return null;
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      debugPrint(" Google Sign-in successful");
      return userCredential.user;
    } on PlatformException catch (e) {
      debugPrint(" Sign-in platform exception: ${e.code}");
      return null;
    } catch (e) {
      debugPrint(" Google Sign-in Error: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      final passwordController = Get.find<PasswordAddController>();
      final logincontroller = Get.find<LoginController>();

      //  Stop any live Firestore stream before token invalidation
      passwordController.passwords.clear();
      passwordController.isListening = false;

      //  Sign out Firebase first
      await FirebaseAuth.instance.signOut();

      //  Then sign out from Google (don’t call disconnect)
      try {
        await _googleSignIn.signOut();
      } catch (e) {
        debugPrint("⚠️ Google Sign-out minor issue: $e");
      }

      //  Reset state
      logincontroller.currentUser.value = null;
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('uid');

      //  Small delay → safe navigation
      await Future.delayed(const Duration(milliseconds: 400));
      Get.offAll(() => const LoginPage());
    } catch (e) {
      debugPrint(" Sign-out crash caught: $e");
      Get.snackbar("Error", "Sign-out failed. Please restart the app.");
    }
  }
}
