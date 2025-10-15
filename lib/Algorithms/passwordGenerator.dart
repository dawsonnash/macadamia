import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

String generatePassword({
  required String basePassword,
  required String siteKey,
  String version = '1',
  int length = 16,
  String charRule = 'full',
}) {
  // Step 1: Combine inputs
  final combinedKey = '${siteKey.toLowerCase()}_v$version';
  final combined = utf8.encode('$basePassword::$combinedKey');

  // Step 2: SHA-256 hash and base64-url encode
  final digest = sha256.convert(combined).bytes;
  final b64 = base64Url.encode(digest).replaceAll('=', '');

  // Step 3: Character pools
  const upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  const lower = 'abcdefghijklmnopqrstuvwxyz';
  const digits = '0123456789';
  const fullSpecial = '!@#\$%^&*()-_=+[]{}';
  const limitedSpecial = '!';

  List<String> pools;
  switch (charRule.toLowerCase()) {
    case 'strict':
      pools = [upper, lower, digits];
      break;
    case 'limited':
      pools = [upper, lower, digits, limitedSpecial];
      break;
    default:
      pools = [upper, lower, digits, fullSpecial];
  }

  // Step 4: Build password from digest
  final b64Clean = b64.codeUnits;
  final password = StringBuffer();

  for (int i = 0; i < length; i++) {
    final pool = pools[i % pools.length];
    final index = b64Clean[i % b64Clean.length] % pool.length;
    password.write(pool[index]);
  }

  return password.toString();
}

