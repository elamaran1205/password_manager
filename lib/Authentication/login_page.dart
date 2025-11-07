import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_manager/Authentication/login_controller.dart';
import 'package:password_manager/utils/my_colors.dart';
import 'package:password_manager/utils/my_text.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final controller = Get.find<LoginController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 20,
            children: [
              Image.asset("assets/icon.png", height: 200),
              Text(
                "Cipher Vault",
                style: MyText.header,
                textAlign: TextAlign.center,
              ),
              Text(
                "Keep your passwords in a secure private encrypted vault and simply access thm with one click",
                style: MyText.body,
                textAlign: TextAlign.center,
              ),
              Container(
                height: 45,
                margin: EdgeInsets.all(20),
                // padding: EdgeInsets.all(5),
                width: double.infinity,
                decoration: BoxDecoration(
                  // border: Border.all(width: 2, color: MyColors.secondaryBlack),
                  borderRadius: BorderRadius.circular(20),
                  color: MyColors.kDarkBlue,
                ),
                child: Obx(
                  () => controller.loading.value
                      ? Center(
                          child: CircularProgressIndicator(
                            color: MyColors.bodyText,
                          ),
                        )
                      : TextButton(
                          onPressed: () async {
                            await controller.login();
                          },
                          child: Text(
                            "Continue with Google",
                            style: MyText.header.copyWith(
                              fontSize: 15,
                              color: MyColors.bodyText,
                            ),
                          ),
                        ),
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
