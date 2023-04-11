import 'dart:io';

import 'package:blackhole/Data/Core/Api/app_api.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> isConnected();
}

class NetworkInfoImpl implements NetworkInfo {
  late DataConnectionChecker _connectionChecker;

  NetworkInfoImpl({DataConnectionChecker? connectionChecker}) {
    _connectionChecker = connectionChecker ?? DataConnectionChecker();
  }

  @override
  Future<bool> isConnected() async {
    bool isConnect = false;
    isConnect = await _connectionChecker.hasConnection;
    try {
      final result = await InternetAddress.lookup(HOST_NAME);
      isConnect = result.isNotEmpty &&
          result[0].rawAddress.isNotEmpty;
    } catch (_) {}
    return isConnect;
  }
}
