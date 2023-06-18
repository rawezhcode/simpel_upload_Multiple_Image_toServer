import 'package:dio/dio.dart';

class Api {
  static const apiUrl = 'http://192.168.x.x/upload_multi_imag';
  static final dio = Dio(
    BaseOptions(
      baseUrl: apiUrl,
      receiveDataWhenStatusError: true,
    ),
  );

  static Future<Response> uploadMultiFile({required List data}) async {
    FormData formData =
        FormData.fromMap({"submit": "submit", "name": "RawezhCode"});

    for (var image in data) {
      // upload to server using api
      formData.files.add(MapEntry(
        'images[]',
        await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ),
      ));
    }

    // print('formData: ${formData.fields}}');

    return dio.post(
      '/upload.php',
      data: formData,
      options: Options(
        contentType: 'application/json',
      ),
    );
  } //end of login
} //end of api
