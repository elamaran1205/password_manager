import 'package:local_auth/local_auth.dart';
import 'package:get/get.dart';

class AppLock {
  static final LocalAuthentication auth = LocalAuthentication();

  static Future<bool> authenticateUser() async {
    try {
      final isAvailable = await auth.canCheckBiometrics;
      if (!isAvailable) return false;

      final didAuthenticate = await auth.authenticate(
        localizedReason: 'Authenticate to unlock Cipher Vault',
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );
      return didAuthenticate;
    } catch (e) {
      Get.snackbar("Error", "Authentication failed: $e");
      print(e.toString());
      return false;
    }
  }
}
