import 'package:flutter_application_1/services/chatbot_service.dart';
import 'package:flutter_application_1/services/user_service.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.I;

void setupLocator() {
  locator.registerSingleton<UserService>(UserService());
  locator.registerSingleton<ChatbotService>(ChatbotService());
}
