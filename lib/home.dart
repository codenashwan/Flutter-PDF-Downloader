import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool loading = false;
  var dio = Dio();

  Future download(String url, String filename) async {
    setState(() {
      loading = true;
    });
    try {
      Response response = await dio.get(
        url,
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      final params = SaveFileDialogParams(
        data: response.data as Uint8List,
        fileName: filename,
      );
      final filePath = await FlutterFileDialog.saveFile(params: params);
      print("file Saved to $filePath");
    } catch (e) {
      print(e);
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: loading
              ? CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () async {
                    download(
                      "https://unec.edu.az/application/uploads/2014/12/pdf-sample.pdf",
                      "nashwan.pdf",
                    );
                  },
                  child: Text('Download a PDF file'),
                ),
        ),
      ),
    );
  }
}
