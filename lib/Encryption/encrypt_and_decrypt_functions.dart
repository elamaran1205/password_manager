import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionHelper {
  // Must be 16, 24, or 32 chars exactly (AES key sizes)
  static final _key = encrypt.Key.fromUtf8('my16charSecret!!'); // 16 chars ✅

  // Fixed IV (must always be the same, 16 chars)
  static final _iv = encrypt.IV.fromUtf8('my16charInitVect'); // 16 chars ✅

  static String encryptText(String text) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    final encrypted = encrypter.encrypt(text, iv: _iv);
    return encrypted.base64;
  }

  static String decryptText(String encryptedText) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    final decrypted = encrypter.decrypt64(encryptedText, iv: _iv);
    return decrypted;
  }
}
