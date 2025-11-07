import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import 'package:password_manager/Authentication/login_service.dart';
import 'package:password_manager/utils/my_colors.dart';
import 'package:password_manager/utils/my_snackbar.dart';
import 'package:password_manager/utils/my_text.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final LoginService signout = LoginService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background,
      appBar: AppBar(
        backgroundColor: MyColors.kLightBlue,
        title: Text(
          "Settings",
          style: MyText.header.copyWith(color: MyColors.appbarTextPrimary),
        ),
        iconTheme: IconThemeData(color: MyColors.appbarTextPrimary),
        elevation: 0,
      ),
      body: FadeInUp(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSettingsTile(
              icon: Icons.info_outline,
              title: "How to Use",
              subtitle: "Learn how to add, view and manage passwords.",
              onTap: () {
                MySnackBar.show(
                  title: "Info",
                  message: "Coming soon — simple user guide!",
                );
              },
            ),

            _buildSettingsTile(
              icon: Icons.help_outline,
              title: "Help & Support",
              subtitle: "Report bugs or ask for assistance.",
              onTap: () {
                MySnackBar.show(
                  title: "Help",
                  message: "You can reach out at: support@pwm.com",
                );
              },
            ),

            _buildSettingsTile(
              icon: Icons.logout,
              title: "Sign Out",
              subtitle: "Log out from your Google account.",
              onTap: () async {
                await signout.signOut();
              },
              color: Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: MyColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: color ?? MyColors.kDarkBlue, size: 28),
        title: Text(title, style: MyText.header.copyWith(fontSize: 16)),
        subtitle: Text(subtitle, style: MyText.body.copyWith(fontSize: 13)),
        onTap: onTap,
      ),
    );
  }
}
