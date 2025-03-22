import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String recoverUrl = "https://petsmarket.backupti.com/docs/api/recover_password.php";
  final String resetUrl = "https://petsmarket.backupti.com/docs/api/reset_password.php";

  Future<Map<String, dynamic>> recoverPassword(String email) async {
    final response = await http.post(
      Uri.parse(recoverUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return {"status": "error", "message": "Error del servidor"};
    }
  }

  Future<Map<String, dynamic>> resetPassword(String token, String newPassword) async {
    final response = await http.post(
      Uri.parse(resetUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"token": token, "password": newPassword}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return {"status": "error", "message": "Error del servidor"};
    }
  }
}

