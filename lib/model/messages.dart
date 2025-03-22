import 'package:flutter_application_1/model/question.dart';

class Messages {
  final String id;
  final String message;
  final bool isBot;
  final List<Options> options;

  Messages({
    required this.id,
    required this.message,
    required this.isBot,
    this.options = const [],
  });
}
