import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/model/question.dart';
import 'package:flutter_application_1/model/response.dart';

class ChatbotService {
  final Dio _dio = Dio();

  Future<List<Question>> getQuestion() async {
    return _dio.get('$baseUrl/init').then((result) {
      final data = result.data as List;
      return data.map((e) => Question.fromJson(e)).toList();
    }).catchError((error) {
      debugPrint('Error: $error');
      return <Question>[];
    });
  }

  Future<Prediction> predict(Map<String, int> data) async {
    return _dio.post('$baseUrl/predecir', data: data).then((result) {
      return Prediction.fromJson(result.data);
    }).catchError((error) {
      debugPrint('Error: $error');
    });
  }
}
