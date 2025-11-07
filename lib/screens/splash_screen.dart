import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:password_manager/Authentication/app_lock.dart';
import 'package:password_manager/Authentication/login_controller.dart';
import 'package:password_manager/Authentication/login_page.dart';
import 'package:password_manager/Authentication/user_model.dart';
import 'package:password_manager/Pages/home_page.dart';
import 'package:password_manager/utils/my_colors.dart';
import 'package:password_manager/utils/my_snackbar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final controller = Get.find<LoginController>();

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Small delay for nice splash animation
    await Future.delayed(const Duration(seconds: 1));

    final firebaseUser = FirebaseAuth.instance.currentUser;
    final localUid = await controller.getUid();

    if (firebaseUser != null && localUid != null) {
      final userdata = UserModel(
        uid: firebaseUser.uid,
        name: firebaseUser.displayName ?? "",
        email: firebaseUser.email ?? "",
        photoUrl: firebaseUser.photoURL ?? "",
      );
      controller.currentUser.value = userdata;

      // Authenticate with biometrics (AppLock)
      final unlocked = await AppLock.authenticateUser();
      if (unlocked) {
        Get.offAll(() => const HomePage());
      } else {
        Get.snackbar(
          "Access Denied",
          "Unable to unlock CipherVault",
          snackPosition: SnackPosition.TOP,
        );
        await Future.delayed(const Duration(seconds: 2));
        SystemNavigator.pop();
      }
    } else {
      final unlocked = await AppLock.authenticateUser();
      if (unlocked) {
        Get.offAll(() => const HomePage());
      } else {
        MySnackBar.show(
          title: "Access Denied",
          message: "Unable to unlock CipherVault",
        );
        await Future.delayed(const Duration(seconds: 2));
        SystemNavigator.pop();
      }
      Get.offAll(() => const LoginPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background,
      body: const Center(
        child: CircularProgressIndicator(color: MyColors.kDarkBlue),
      ),
    );
  }
}
