import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_manager/Authentication/login_controller.dart';
import 'package:password_manager/Pages/password_add_controller.dart';
import 'package:password_manager/utils/my_colors.dart';
import 'package:password_manager/utils/my_snackbar.dart';
import 'package:password_manager/utils/my_text.dart';

class PasswordAddPage extends StatefulWidget {
  const PasswordAddPage({super.key});

  @override
  State<PasswordAddPage> createState() => _PasswordAddPageState();
}

class _PasswordAddPageState extends State<PasswordAddPage> {
  final passwordController = Get.find<PasswordAddController>();
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController notesCtrl = TextEditingController();
  final RxBool isEncrypting = false.obs;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: MyColors.background,
          appBar: AppBar(
            title: Text(
              "Add password",
              style: MyText.header.copyWith(color: MyColors.appbarTextPrimary),
            ),
            iconTheme: IconThemeData(color: MyColors.appbarTextPrimary),
            elevation: 0,
            backgroundColor: MyColors.kLightBlue,
          ),
          body: FadeInUp(
            child: Column(
              children: [
                Obx(
                  () => Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: MyColors.background,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        TextField(
                          controller: nameCtrl,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: MyColors.surface,
                            labelText: 'Name',
                            prefixIcon: Icon(
                              Icons.person,
                              color: MyColors.kDarkBlue,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: passwordCtrl,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: MyColors.surface,
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            prefixIcon: Icon(
                              Icons.key,
                              color: MyColors.kDarkBlue,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                passwordController.hidepass.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: MyColors.kDarkBlue,
                              ),
                              onPressed: () {
                                passwordController.hidepass.value =
                                    !passwordController.hidepass.value;
                              },
                            ),
                          ),
                          obscureText: passwordController.hidepass.value
                              ? true
                              : false,
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: notesCtrl,
                          maxLines: 2,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: MyColors.surface,
                            labelText: 'Notes',
                            prefixIcon: Icon(
                              Icons.note_alt,
                              color: MyColors.kDarkBlue,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onChanged: (value) {
                            if (nameCtrl.text.isNotEmpty &&
                                passwordCtrl.text.isNotEmpty &&
                                notesCtrl.text.isNotEmpty) {
                              passwordController.isValid.value = true;
                            } else {
                              passwordController.isValid.value = false;
                            }
                          },
                        ),
                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: passwordController.isValid.value
                                  ? MyColors.kLightBlue
                                  : MyColors.surface,
                              foregroundColor: passwordController.isValid.value
                                  ? MyColors.bodyText
                                  : MyColors.primaryBlack,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: passwordController.isValid.value
                                ? () async {
                                    final controller =
                                        Get.find<LoginController>();
                                    try {
                                      final name = nameCtrl.text.trim();
                                      final password = passwordCtrl.text.trim();
                                      final notes = notesCtrl.text.trim();

                                      isEncrypting.value = true;
                                      await Future.delayed(
                                        const Duration(seconds: 3),
                                      );

                                      await passwordController.addPassword(
                                        uid: controller.currentUser.value!.uid,
                                        name: name,
                                        password: password,
                                        notes: notes,
                                      );

                                      nameCtrl.clear();
                                      passwordCtrl.clear();
                                      notesCtrl.clear();

                                      Get.back();
                                    } catch (e) {
                                      MySnackBar.show(
                                        title: "Error",
                                        message: "Failed to save password: $e",
                                      );
                                    } finally {
                                      isEncrypting.value = false;
                                    }
                                  }
                                : null,
                            child: Text(
                              "Encrypt and Save",
                              style: MyText.header.copyWith(
                                fontSize: 15,
                                color: passwordController.isValid.value
                                    ? MyColors.bodyText
                                    : MyColors.primaryBlack,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Obx(() {
          if (!isEncrypting.value) return const SizedBox.shrink();
          return Container(
            color: Colors.black.withOpacity(0.6),
            child: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: MyColors.kLightBlue),
                  SizedBox(height: 20),
                  Text(
                    "Password is Encrypting...",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
