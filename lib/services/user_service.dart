import 'package:dio/dio.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/model/user.dart';

class UserService {
  final Dio _dio = Dio();

  Future<bool> login(
    String cedula,
    String password,
  ) async {
    return _dio
        .post(
          '$baseUrl/login',
          data: {
            "cedula": cedula,
            "password": password,
          },
          options: Options(contentType: 'Application/json'),
        )
        .then((result) => result.statusCode == 200)
        .onError((error, stackTrace) => false);
  }

  Future<bool> register(RegisterUser user) {
    return _dio
        .post('$baseUrl/register', data: user.toJson(), options: Options(contentType: 'Application/json'))
        .then((result) {
      return result.statusCode == 200;
    }).onError((error, stackTrace) {
      return false;
    });
  }
}
