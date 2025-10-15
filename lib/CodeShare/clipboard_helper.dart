import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Not real keys
const _aesKey = '*****************';  // Must be 32 bytes padded/truncated
const _aesIV = '*****************';      // Must be 16 bytes padded/truncated

class ClipboardSettings {
  static const _ipKey = 'laptop_ip';

  static Future<void> setLaptopIP(String ip) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_ipKey, ip);
  }

  static Future<String?> getLaptopIP() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_ipKey);
  }
}

Future<bool> sendToLaptopClipboard(String text) async {
  final ip = await ClipboardSettings.getLaptopIP();
  if (ip == null) {
    print("IP not set");
    return false;
  }

  final url = Uri.parse('http://$ip:5000/clipboard');

  final encryptedText = aesEncrypt(text, _aesKey, _aesIV);

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'text': encryptedText}),
    ).timeout(const Duration(seconds: 2));

    if (response.statusCode == 200) {
      print('Text sent to clipboard!');
      return true;
    } else {
      print('Server responded with error: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('Exception sending to clipboard: $e');
    return false;
  }
}

String aesEncrypt(String plainText, String keyStr, String ivStr) {
  final key = encrypt.Key.fromUtf8(keyStr.padRight(32).substring(0, 32));
  final iv = encrypt.IV.fromUtf8(ivStr.padRight(16).substring(0, 16));
  final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
  final encrypted = encrypter.encrypt(plainText, iv: iv);
  return encrypted.base64;
}
