import 'package:dio/dio.dart';

class Api {
  static const apiUrl = 'http://192.168.x.x/upload_multi_imag';
  static final dio = Dio(
    BaseOptions(
      baseUrl: apiUrl,
      receiveDataWhenStatusError: true,
    ),
  );

  static Future<Response> uploadMultiFile(
      {required Map<String, dynamic> data}) async {
    FormData formData = FormData.fromMap(data);

    print('formData: ${formData.fields}}');

    return dio.post(
      '/upload.php',
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
      ),
    );
  } //end of login
} //end of api
