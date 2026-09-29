import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'storage_service.dart';

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
  int _readCount = 0;
  String _status = 'Preparing the file...';
  DateTime? _lastReadAt;

  @override
  void initState() {
    super.initState();
    _startFileOperation();
  }

  Future<String> _writeAndReadFile() async {
    try {
      return await writeAndReadFile(
        fileName: _fileName,
        sampleText: _sampleText,
      );
    } catch (error) {
      throw Exception('Could not access the text file: $error');
    }
  }

  void _startFileOperation() {
    final operation = _writeAndReadFile();

    if (mounted) {
      setState(() {
        _status = 'Writing and reading the file...';
        _fileContent = operation;
      });
    } else {
      _fileContent = operation;
    }

    operation.then((_) {
      if (!mounted) return;
      setState(() {
        _readCount++;
        _lastReadAt = DateTime.now();
        _status = 'File written and read successfully';
      });
    });
  }

  void _reloadFile() {
    _startFileOperation();
  }

  String get _storageDescription {
    return kIsWeb
        ? 'Browser local storage (web preview)'
        : 'Application documents directory';
  }

  String get _lastReadDescription {
    final time = _lastReadAt;
    if (time == null) return 'Not read yet';

    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
  }

  Widget _buildOperationDetails() {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_status, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Storage: $_storageDescription'),
            Text('File: $_fileName'),
            Text('Read operations: $_readCount'),
            Text('Last read: $_lastReadDescription'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Device Storage')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: FutureBuilder<String>(
          future: _fileContent,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildOperationDetails(),
                  const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ],
              );
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
                const SizedBox(height: 20),
                _buildOperationDetails(),
                const SizedBox(height: 4),
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
