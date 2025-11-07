import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_manager/utils/my_colors.dart';
import 'package:password_manager/utils/my_text.dart';

class MySnackBar {
  static void show({
    required String title,
    required String message,
    Color? backgroundColor,
    Color? textColor,
    SnackPosition position = SnackPosition.TOP,
    IconData? icon,
  }) {
    Get.closeAllSnackbars();

    Get.snackbar(
      title,
      message,
      snackPosition: position,
      margin: const EdgeInsets.all(12),
      backgroundColor: backgroundColor ?? MyColors.kLightBlue,
      colorText: textColor ?? MyColors.bodyText,
      borderRadius: 15,
      icon: icon != null
          ? Icon(icon, color: textColor ?? MyColors.bodyText)
          : null,
      duration: const Duration(seconds: 4),
      animationDuration: const Duration(milliseconds: 300),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeIn,
      messageText: Text(
        message,
        style: MyText.body.copyWith(
          color: textColor ?? MyColors.bodyText,
          fontSize: 13,
        ),
      ),
      titleText: Text(
        title,
        style: MyText.header.copyWith(
          color: textColor ?? MyColors.bodyText,
          fontSize: 15,
        ),
      ),
    );
  }
}
