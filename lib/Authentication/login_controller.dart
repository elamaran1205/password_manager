import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:password_manager/Authentication/login_service.dart';
import 'package:password_manager/Authentication/user_model.dart';
import 'package:password_manager/Pages/home_page.dart';
import 'package:password_manager/utils/my_snackbar.dart';
import 'package:password_manager/utils/toast_message.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  Future<void> saveUid(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', uid);
  }

  Future<String?> getUid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('uid');
  }

  var loading = false.obs;
  Rxn<UserModel> currentUser = Rxn<UserModel>();
  Future<void> login() async {
    loading.value = true;
    final LoginService service = LoginService();
    try {
      print("controller started");
      final user = await service.signInwithGoogle();
      if (user != null) {
        saveUid(user.uid);
        final userdata = UserModel(
          photoUrl: user.photoURL ?? "",
          email: user.email ?? "",
          name: user.displayName ?? "",
          uid: user.uid,
        );
        currentUser.value = userdata;

        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .set(userdata.toMap(), SetOptions(merge: true));
        showtoaster("Sign up success");
        // Get.snackbar("Success Email logged", "succsess");
        Get.offAll(() => HomePage());
      } else if (user == null) {
        MySnackBar.show(title: "Cancelled", message: "Sign-in was cancelled");

        loading.value = false;
      } else {
        MySnackBar.show(title: "error", message: "try again");
      }
    } catch (e) {
      MySnackBar.show(title: "error", message: e.toString());
    } finally {
      loading.value = false;
    }
  }

  Future<void> clearUid() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('uid');
  }
}
