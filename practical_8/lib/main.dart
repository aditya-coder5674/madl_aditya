import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const PracticalEightApp());
}

class PracticalEightApp extends StatelessWidget {
  const PracticalEightApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'File Storage Practical',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const FileStoragePage(),
    );
  }
}

class FileStoragePage extends StatefulWidget {
  const FileStoragePage({super.key});

  @override
  State<FileStoragePage> createState() => _FileStoragePageState();
}

class _FileStoragePageState extends State<FileStoragePage> {
  static const _fileName = 'practical_8_sample.txt';
  static const _sampleText =
      'This text was written to device storage by the Flutter app.';

  late Future<String> _fileContent;

  @override
  void initState() {
    super.initState();
    _fileContent = _writeAndReadFile();
  }

  Future<String> _writeAndReadFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_fileName');

      debugPrint('Application documents directory: ${directory.path}');
      debugPrint('Text file path: ${file.path}');

      await file.writeAsString(_sampleText);
      return await file.readAsString();
    } catch (error) {
      throw Exception('Could not access the text file: $error');
    }
  }

  void _reloadFile() {
    setState(() {
      _fileContent = _writeAndReadFile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Storage'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: FutureBuilder<String>(
          future: _fileContent,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return _FileStateMessage(
                title: 'File error',
                message: snapshot.error.toString(),
                icon: Icons.error_outline,
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Text file content',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'The app locates its documents directory, writes a sample '
                  'file, and reads it back asynchronously.',
                ),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      snapshot.data ?? 'No content found.',
                      style: const TextStyle(fontSize: 18, height: 1.5),
                    ),
                  ),
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: _reloadFile,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Write and read again'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _FileStateMessage extends StatelessWidget {
  const _FileStateMessage({
    required this.title,
    required this.message,
    required this.icon,
  });

  final String title;
  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48),
          const SizedBox(height: 12),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}