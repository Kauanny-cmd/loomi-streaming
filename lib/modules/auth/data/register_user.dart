import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../core/routes/api_routes.dart';

Future<String> registerUser(String email, String password, String? username) async {
  try {
    // 1. Create user on Firebase
    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final firebaseUid = credential.user?.uid;

    if (firebaseUid == null) {
      print('Erro ao obter UID do Firebase.');
      return 'Erro ao obter UID do Firebase.';
    }

    // 2. Register user in API with UID Firebase
    final response = await http.post(
      Uri.parse(ApiRoutes.register),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "username": username,
        "email": email,
        "password": password,
        "firebase_UID": firebaseUid,
      }),
    );

    print('STATUS: ${response.statusCode}');
    print('BODY: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('uid', firebaseUid);
      await prefs.setString('email', email);

      return('Ok');
    } else {
      return 'Erro ao registrar usuário na API';
    }

  } catch (e) {
    return ('Erro no cadastro: $e');
  }
}
