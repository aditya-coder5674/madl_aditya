import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> writeAndReadFile({
  required String fileName,
  required String sampleText,
}) async {
  final storageKey = 'practical_8/$fileName';
  final storage = await SharedPreferences.getInstance();

  await storage.setString(storageKey, sampleText);
  debugPrint('Browser local storage key: $storageKey');

  return storage.getString(storageKey) ?? 'No content found.';
}