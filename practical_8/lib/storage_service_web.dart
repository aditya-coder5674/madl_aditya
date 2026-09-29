import 'dart:html' as html;

Future<String> writeAndReadFile({
  required String fileName,
  required String sampleText,
}) async {
  final storageKey = 'practical_8/$fileName';
  final storage = html.window.localStorage;

  storage[storageKey] = sampleText;
  print('Browser local storage key: $storageKey');

  return storage[storageKey] ?? 'No content found.';
}