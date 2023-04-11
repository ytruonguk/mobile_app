import 'package:blackhole/Data/Model/response_model.dart';
import 'package:blackhole/Data/data_layer.dart';
import 'package:blackhole/Data/Core/Api/app_api.dart';

abstract class UserRemote {
  Future<ResponseModel<UserModel>> login({required String email, required String password});
}

class UserRemoteDataSourceImpl implements UserRemote {
  static const String LOGIN = '/api/users/login';

  @override
  Future<ResponseModel<UserModel>> login({required String email, required String password}) async {
    Map<String, dynamic>? response;
    try {
      Uri _uri = Uri.http(HOST_NAME, LOGIN);
      response = await ApiClient.instance
          .postRequest(_uri, body: {"email": email, "password": password});
      if (response == null) {
        response?.addAll(
            {"error_type": "API_ERROR", "message": response.toString()});
      }
    } catch(error) {
      response?.addAll({"error_type": "ERROR", "message": error.toString()});
    }

    return ResponseModel<UserModel>.fromJson(response!);
  }
}
