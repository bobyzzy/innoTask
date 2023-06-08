import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart' as kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _dir;
  bool? downloanding;

  //final String _zipPath = 'https://github.com/Polymer/shop.git';
  void _donwloadFileWithPlugin() async {
    final baseStorage = await getExternalStorageDirectory();
    final id = await FlutterDownloader.enqueue(
        url: 'https://github.com/Polymer/shop/archive/refs/heads/master.zip',
        showNotification: true,
        openFileFromNotification: true,
        savedDir: baseStorage!.path,
        fileName: 'project');
  }

  @override
  void initState() {
    _initDir();
    super.initState();
  }

  void _initDir() async {
    if (null == _dir) {
      Directory dir = await getApplicationDocumentsDirectory();
      _dir = dir.path;
    }
  }

  Future<File> _downloadFile(String url, String fileName) async {
    // HttpClientRequest request = await HttpClient().getUrl(Uri.parse(_zipPath));
    // final response = request.close();
    var req = await http.Client().get(Uri.parse(url));
    var file = File("$_dir/$fileName");
    print(file.path);

    return file.writeAsBytes(req.bodyBytes);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      debugShowCheckedModeBanner: true,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Git Repo Download App'),
          actions: [
            IconButton(
              onPressed: null,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: Center(
          child: Container(
            width: 600,
            child: Column(
              children: [
                SizedBox(height: 200),
                const Text(
                  "Нажмите для загрузки гит репозитория ",
                  style: TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 100),
                TextButton(
                    onPressed: () {
                      _downloadFile(
                              'https://github.com/Polymer/shop/archive/refs/heads/master.zip',
                              'project.zip')
                          .whenComplete(() => print('complete'));
                    },
                    child: Text('download')),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _donwloadFileWithPlugin,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

