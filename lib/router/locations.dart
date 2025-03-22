import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/chatbot.dart';
import 'package:flutter_application_1/home.dart';
import 'package:flutter_application_1/home_options.dart';
import 'package:flutter_application_1/results.dart';
import 'package:flutter_application_1/register.dart';
import 'package:flutter_application_1/login.dart';
import 'package:flutter_application_1/forgot_password.dart'; // Importamos la pantalla de recuperación

class Locations extends BeamLocation<BeamState> {
  @override
  List<Pattern> get pathPatterns => [
        '/',
        '/login', // Ruta para la pantalla de login
        '/register', // Ruta para la pantalla de registro
        '/forgot-password', // Ruta para la pantalla de recuperación de contraseña
        '/options',
        '/results',
        '/chatbot',
      ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final pages = [
      if (state.uri.pathSegments.isEmpty || state.uri.pathSegments.contains('login'))
        const BeamPage(
          key: ValueKey('LoginPage'),
          title: 'Login',
          child: Login(),
        ),
      if (state.uri.pathSegments.contains('register'))
        const BeamPage(
          key: ValueKey('RegisterPage'),
          title: 'Registrarse',
          child: Register(),
        ),
      if (state.uri.pathSegments.contains('forgot-password')) // Ruta agregada
        const BeamPage(
          key: ValueKey('ForgotPasswordPage'),
          title: 'Recuperar Contraseña',
          child: ForgotPassword(),
        ),
      if (state.uri.pathSegments.contains('options'))
        const BeamPage(
          key: ValueKey('HomeOptions'),
          title: 'HomeOptions',
          child: HomeOptions(),
        ),
      if (state.uri.pathSegments.contains('results'))
        const BeamPage(
          key: ValueKey('ResultsPage'),
          title: 'Results',
          child: Results(),
        ),
      if (state.uri.pathSegments.contains('chatbot'))
        const BeamPage(
          key: ValueKey('ChatbotPage'),
          title: 'Chatbot',
          child: Chatbot(name: 'User'),
        ),
    ];
    return pages;
  }
}
