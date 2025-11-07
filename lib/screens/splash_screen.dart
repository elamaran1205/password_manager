import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_manager/Authentication/login_controller.dart';
import 'package:password_manager/Authentication/login_page.dart';
import 'package:password_manager/Authentication/user_model.dart';
import 'package:password_manager/Pages/home_page.dart';
import 'package:password_manager/utils/my_colors.dart';

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
    _initApp();
  }

  Future<void> _initApp() async {
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
      controller.currentUser.value = userdata; // rebuilds user object

      print("✅ Restored user: ${userdata.name}");
      Get.offAll(() => const HomePage());
    }
    // ⚠️ Case 2: No user session
    else {
      print("⚠️ No user found, redirecting to login...");
      Get.offAll(() => const LoginPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background,
      body: Center(child: CircularProgressIndicator(color: MyColors.kDarkBlue)),
    );
  }
}
