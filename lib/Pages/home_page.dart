import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:password_manager/Authentication/app_lock.dart';
import 'package:password_manager/Authentication/login_controller.dart';
import 'package:password_manager/Encryption/encrypt_and_decrypt_functions.dart';
import 'package:password_manager/Pages/password_add_controller.dart';
import 'package:password_manager/Pages/password_add_page.dart';
import 'package:password_manager/Pages/settings_page.dart';
import 'package:password_manager/utils/my_colors.dart';
import 'package:password_manager/utils/my_snackbar.dart';
import 'package:password_manager/utils/my_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Get.find<LoginController>();
  final passwordController = Get.put(PasswordAddController());

  @override
  void initState() {
    super.initState();
    passwordController.loading.value = true;
    Future.delayed(const Duration(seconds: 2), () async {
      final String? userid = await controller.getUid();
      passwordController.fetchPasswords(userid.toString());
      passwordController.loading.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: MyColors.headerBlack,
      onRefresh: () async {
        passwordController.fetchPasswords(controller.currentUser.value!.uid);
      },
      child: FadeIn(
        child: Scaffold(
          backgroundColor: MyColors.kLightBlue,
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                expandedHeight: 150,
                pinned: false,
                floating: true,
                snap: true,
                backgroundColor: MyColors.kLightBlue,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                    padding: const EdgeInsets.only(
                      top: 40,
                      left: 16,
                      right: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundImage: NetworkImage(
                                controller.currentUser.value!.photoUrl,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.currentUser.value!.name,
                                  style: MyText.header.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: MyColors.appbarTextPrimary,
                                    letterSpacing: 0.8,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  controller.currentUser.value!.email,
                                  style: MyText.body.copyWith(
                                    fontSize: 13,
                                    color: MyColors.appbarTextSecondary,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () =>
                                  Get.to(() => const SettingsPage()),
                              icon: Icon(
                                Icons.settings_rounded,
                                color: MyColors.appbarTextSoftWhite,
                                size: 26,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Text(
                          "Store your",
                          style: MyText.body.copyWith(
                            fontSize: 14,
                            color: MyColors.appbarTextSecondary,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          "Passwords Securely ",
                          style: MyText.header.copyWith(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: MyColors.appbarTextPrimary,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            body: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: MyColors.background,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Obx(() {
                      if (passwordController.loading.value) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: MyColors.kLightBlue,
                          ),
                        );
                      }
                      final data = passwordController.passwords;

                      if (data.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              addpasscard2(),
                              Text(
                                "No passwords saved yet",
                                style: MyText.body,
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: data.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return addpasscard();
                          }

                          final doc = data[index - 1];
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: MyColors.background,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.07),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: Text(
                                doc['name'] ?? '',
                                style: MyText.header.copyWith(fontSize: 15),
                              ),
                              trailing: IconButton(
                                onPressed: () async {
                                  await passwordController.deletePassword(
                                    uid: controller.currentUser.value!.uid,
                                    docId: doc.id,
                                  );
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: MyColors.kDarkBlue,
                                ),
                              ),
                              onTap: () {
                                String decryptedPassword = '';
                                bool showPassword = false;

                                Get.dialog(
                                  StatefulBuilder(
                                    builder: (context, setState) {
                                      try {
                                        decryptedPassword =
                                            EncryptionHelper.decryptText(
                                              doc['password'],
                                            );
                                      } catch (e) {
                                        decryptedPassword =
                                            '•••••• (decryption failed)';
                                      }

                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                        backgroundColor: MyColors.background,
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              doc['name'] ?? 'Password Info',
                                              style: MyText.header.copyWith(
                                                color: MyColors.primaryBlack,
                                                fontSize: 15,
                                              ),
                                            ),
                                            Text(
                                              doc['notes']?.isEmpty ?? true
                                                  ? 'No notes added'
                                                  : doc['notes'],
                                              style: MyText.body.copyWith(
                                                fontSize: 13,
                                              ),
                                            ),
                                            const SizedBox(height: 15),
                                            Text(
                                              "Decrypted Password:",
                                              style: MyText.header.copyWith(
                                                fontSize: 13,
                                                color: MyColors.kDarkBlue,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    showPassword
                                                        ? decryptedPassword
                                                        : "••••••••••••",
                                                    style: MyText.header
                                                        .copyWith(fontSize: 14),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: Icon(
                                                    showPassword
                                                        ? Icons.visibility_off
                                                        : Icons.visibility,
                                                    color:
                                                        MyColors.kPrimaryBlue,
                                                  ),
                                                  onPressed: () async {
                                                    final unlock =
                                                        await AppLock.authenticateUser();
                                                    if (unlock) {
                                                      setState(() {
                                                        showPassword =
                                                            !showPassword;
                                                      });
                                                    }
                                                  },
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.copy,
                                                    color: MyColors.kLightBlue,
                                                  ),
                                                  onPressed: () {
                                                    if (!decryptedPassword
                                                        .startsWith('••')) {
                                                      Clipboard.setData(
                                                        ClipboardData(
                                                          text:
                                                              decryptedPassword,
                                                        ),
                                                      );
                                                      MySnackBar.show(
                                                        title: "Copied",
                                                        message:
                                                            "Password copied to clipboard",
                                                      );
                                                    } else {
                                                      MySnackBar.show(
                                                        title: "Error",
                                                        message:
                                                            "Cannot decrypt this password",
                                                      );
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget addpasscard() {
  return Container(
    margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      // borderRadius: BorderRadius.circular(20),
      color: Colors.transparent,
    ),
    child: InkWell(
      onTap: () => Get.to(() => const PasswordAddPage()),
      child: Row(
        children: [
          Text(
            "Add Password",
            style: MyText.header.copyWith(
              color: MyColors.kDarkBlue,
              fontSize: 18,
            ),
          ),
          const Spacer(),
          Icon(Icons.add, color: MyColors.kDarkBlue, size: 30),
          SizedBox(width: 25),
        ],
      ),
    ),
  );
}

Widget addpasscard2() {
  return Container(
    margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      // borderRadius: BorderRadius.circular(20),
      color: Colors.transparent,
    ),
    child: InkWell(
      onTap: () => Get.to(() => const PasswordAddPage()),
      child: Text(
        "Add Password",
        style: MyText.header.copyWith(color: MyColors.kDarkBlue, fontSize: 18),
      ),
    ),
  );
}
