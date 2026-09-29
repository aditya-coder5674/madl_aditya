import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<String> writeAndReadFile({
  required String fileName,
  required String sampleText,
}) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/$fileName');

  print('Application documents directory: ${directory.path}');
  print('Text file path: ${file.path}');

  await file.writeAsString(sampleText);
  return file.readAsString();
}