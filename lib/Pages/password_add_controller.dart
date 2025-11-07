import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:password_manager/Encryption/encrypt_and_decrypt_functions.dart';
import 'package:password_manager/utils/my_snackbar.dart';
import 'package:password_manager/utils/toast_message.dart';

class PasswordAddController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var passwords = [].obs;
  var isListening = true;
  var isValid = false.obs;
  var hidepass = true.obs;
  var loading = false.obs;
  Future<void> addPassword({
    required String uid,
    required String name,
    required String password,
    required String notes,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('password')
          .add({
            'name': name,
            'password': EncryptionHelper.encryptText(password),
            'notes': notes,
            'createdAt': FieldValue.serverTimestamp(),
          })
          .then((value) {
            print("✅ Password saved at doc ID: ${value.id}");
          })
          .catchError((e) {
            print("❌ Firestore write failed: $e");
          });
      isValid.value = false;
      hidepass.value = true;
      showtoaster("Password Added");
    } catch (e) {
      MySnackBar.show(title: 'Error ', message: e.toString());
    }
  }

  Future<void> deletePassword({
    required String uid,
    required String docId,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('password')
          .doc(docId)
          .delete();

      showtoaster("Password Deleted");

      // Optional: refresh passwords
      fetchPasswords(uid);
    } catch (e) {
      MySnackBar.show(title: "Error", message: "Failed to delete password: $e");
    }
  }

  void fetchPasswords(String uid) {
    if (!isListening) return;
    try {
      loading.value = true;
      _firestore
          .collection('users')
          .doc(uid)
          .collection('password')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .listen((snapshot) {
            passwords.value = snapshot.docs;
          });
    } catch (e) {
      throw Exception();
    } finally {
      loading.value = false;
    }
  }
}
