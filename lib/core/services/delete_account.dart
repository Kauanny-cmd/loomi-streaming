import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

import '../../modules/auth/data/index.dart';
import '../routes/api_routes.dart';
import 'package:http/http.dart' as http;

Future<String> deleteAccount() async {
  final token = await getFirebaseToken();

  final user = FirebaseAuth.instance.currentUser;

  final response = await http.get(
    Uri.parse(ApiRoutes.deleteUser(user!.uid)),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  log(response.body);

  if (response.statusCode == 200 || response.statusCode == 201) {
    await user.delete();
    return('Ok');
  } else {
    return 'Failed to register user with the API';
  }
}