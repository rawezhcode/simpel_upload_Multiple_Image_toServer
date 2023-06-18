import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:upload_multi_img_to_server_php/api.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Upload(),
    );
  }
}

class Upload extends StatefulWidget {
  @override
  UploadState createState() => UploadState();
}

class UploadState extends State<Upload> {
  late List imagesList;
  late final Map<String, dynamic> _data = {};

  // Future<void> upload() async {
  //   FilePickerResult? result =
  //       await FilePicker.platform.pickFiles(allowMultiple: true);
  //   if (result != null) {
  //     List<File> files = result.paths.map((path) => File(path!)).toList();
  //     String fileName = result.files.first.name;
  //     uploadToServer(files[0].toString(), fileName);
  //     print('files: ${files[0]}');
  //     print('fileName: $fileName');
  //   } else {
  //     // User canceled the picker
  //   }
  // }

  // function get images from gallery and upload to server
  Future<void> upload() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    if (images.isNotEmpty) {
      // convert images to list of files
      imagesList = images.map((e) => File(e.path)).toList();
      // add data to map
      _data['submit'] = 'submit';
      _data['type'] = 'image/jpg';
      // loop through images list and add to multipart file
      for (var image in imagesList) {
        _data['images[]'] = await MultipartFile.fromFile(image.path);
        // upload to server using api
        uploadToServer(_data);
      }
    }
  }

  // function to upload images to server
  Future<void> uploadToServer(files) async {
    final response = await Api.uploadMultiFile(data: files);
    print('response: ${response.data}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Uploader"),
      ),
      body: const Center(child: Text("picked files container")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => upload(), //(upload function) modify latter (2)
        child: const Icon(Icons.add),
      ),
    );
  }
}
