import 'dart:io';

import 'package:dio/dio.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:http/http.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';

class LoginStore {
  final Dio _dio;

  LoginStore(this._dio);

  Future<Dio> getAccesToken() async {}
}
