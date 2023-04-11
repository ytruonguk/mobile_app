import 'dart:convert';
import 'dart:io';

import 'package:blackhole/Data/Core/pref_db.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum HttpMethod { GET, POST, PUT, DELETE, PATCH }

const String HOST_NAME = 'baotuyensinh.edu.vn';

class ApiClient {
  ///Configs
  static const int _CONNECT_TIMEOUT = 30000; //millisecond

  static ApiClient get instance => ApiClient();

//  Dio dio = new Dio();

  Future<bool> downloadFile(
      Uri uri, File file, ProgressCallback callBack) async {
    return _downloadFile(uri, file, callBack);
  }

  ///Open method
  Future<Map<String, dynamic>?> getRequest(Uri uri,
      {Map<String, dynamic>? query}) async {
    return _callRequest(HttpMethod.GET, uri, query: query);
  }

  ///[uri]
  Future<Map<String, dynamic>?> postRequest(Uri uri,
      {Map<String, dynamic>? query, Map<String, dynamic>? body}) async {
    return _callRequest(HttpMethod.POST, uri, query: query, body: body);
  }

//Download file
  Future<Map<String, dynamic>?> putRequest(Uri uri,
      {Map<String, dynamic>? query, Map<String, dynamic>? body}) async {
    return _callRequest(HttpMethod.PUT, uri, query: query, body: body);
  }

  /// Routine to invoke the Web Server to get answers
  Future<Map<String, dynamic>?> _callRequest(HttpMethod method, Uri uri,
      {Map<String, dynamic>? query, Map<String, dynamic>? body}) async {
    Response response;
    final Dio dio = Dio()..options.baseUrl = 'https://$HOST_NAME/';
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String appDocPath = appDocDir.path;
    final CookieJar cookieJar = PersistCookieJar(storage: FileStorage('$appDocPath/.cookies/'));
    // CookieJar cookieJar = CookieJar();
    dio.interceptors.add(CookieManager(cookieJar));
    dio.options.connectTimeout = _CONNECT_TIMEOUT as Duration?;
    dio.options.headers = {'content-type': 'application/json'};
    dio.interceptors.add(LogInterceptor(
      request: false,
      requestHeader: true,
      responseHeader: false,
      responseBody: false,
      requestBody: false,
      error: true,
    ));
    final String? token =
    await PrefDb(await SharedPreferences.getInstance()).getToken();
    if ((token ?? '').isNotEmpty) {
      dio.options.headers['token'] = token;
    }
    try {
      final result = await InternetAddress.lookup(uri.host);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          switch (method) {
            case HttpMethod.GET:
              {
                response =
                await dio.get(uri.toString(), queryParameters: query);
                break;
              }
            case HttpMethod.POST:
              {
                response = await dio.post(uri.toString(),
                    queryParameters: query, data: body);
                break;
              }
            case HttpMethod.PUT:
              response = await dio.put(uri.toString(),
                  queryParameters: body, data: body);
              break;
            case HttpMethod.DELETE:
              response = await dio.delete(uri.toString(),
                  queryParameters: body, data: body);
              break;
            case HttpMethod.PATCH:
              response = await dio.patch(uri.toString(),
                  queryParameters: body, data: body);
              break;
          }
        } catch (e) {
          //Internet connection error
          rethrow;
        }
        switch (response.statusCode) {
          case 200:
            return jsonDecode(response.data.toString()) as Map<String, dynamic>;
          case 401:
            return null;
          case 400:
            return null;
        }
        return null;
      } else {
        throw {
          'error_type': 'SERVER_NOT_CONNECT',
          'message': result.toString()
        };
      }
    } on SocketException catch (_) {
      throw {'error_type': 'SERVER_NOT_CONNECT', 'message': _.toString()};
    }
  }

  Future<bool> _downloadFile(
      Uri uri, File file, ProgressCallback callBack) async {
    Response response;
    Dio dio = new Dio();
    String? token =
    await PrefDb(await SharedPreferences.getInstance()).getToken();
    if ((token ?? '').isNotEmpty) {
      dio.options.headers = {
        'token': token,
      };
    }

    dio.options.connectTimeout = _CONNECT_TIMEOUT as Duration?;
    dio.options.receiveTimeout = 300000 as Duration?;

    try {
      response = await dio.download(
        uri.toString(),
        file.path,
        onReceiveProgress: callBack,
      );
    } catch (e) {
      return false;
    }
    switch (response.statusCode) {
      case 200:
        return true;
      case 401:
        return false;
      case 400:
        return false;
      default:
        return false;
    }
  }

  ///UploadImageFile
  Future<Map<String, dynamic>?> uploadFile(
      Uri uri, File file, ProgressCallback callBack) async {
    Response response;
    final Dio _dio = Dio();
    final String? token =
    await PrefDb(await SharedPreferences.getInstance()).getToken();
    if ((token ?? '').isNotEmpty) {
      _dio.options.headers = {
        'token': token,
        'content-type': 'multipart/form-data; boundary=something'
      };
    }
    _dio.options.connectTimeout = _CONNECT_TIMEOUT as Duration?;
    _dio.options.receiveTimeout = 300000 as Duration?;
    _dio.interceptors.add(LogInterceptor(responseHeader: false));
    // _dio.transformer = new FlutterTransformer();

    try {
      response = await _dio.postUri(
        uri,
        data: FormData.fromMap({
          'avatar': MultipartFile.fromFileSync(file.path),
        }),
      );
    } catch (e) {
      rethrow;
    }
    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.data.toString()) as Map<String, dynamic>;
      case 401:
        return null;
      case 400:
        return null;
    }

    return null;
  }

  Future<Map<String, dynamic>?> sendPost(
      Uri uri, FormData formData, ProgressCallback callBack) async {
    Response response;
    final Dio dio = Dio();
//    String token =
//        await PrefDb(await SharedPreferences.getInstance()).getToken();
//    if ((token ?? "").isNotEmpty) {
//      _dio.options.headers = {
//        'token': token,
//      };
//    }
    dio.options.headers['Content-Type'] =
        ContentType.parse('multipart/form-data');
    dio.options.connectTimeout = _CONNECT_TIMEOUT as Duration?;
    dio.options.receiveTimeout = 300000 as Duration?;
    dio.interceptors.add(LogInterceptor(responseHeader: true));
//     _dio.transformer = new FlutterTransformer();

    try {
      response = await dio.postUri(
        uri,
        data: formData,
      );
    } catch (e) {
      rethrow;
    }
    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.data.toString()) as Map<String, dynamic>;
      case 401:
        return null;
      case 400:
        return null;
    }

    return null;
  }
}
