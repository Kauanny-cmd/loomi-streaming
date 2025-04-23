import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../modules/auth/data/index.dart';
import '../routes/api_routes.dart';

Future<String> likeMovie(int movieId) async {
  try {
    final token = await getFirebaseToken();
    print('token ${token}');

    if (token == null) {
      print('User not auhenticated');
    }

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('uid');

    print(userId!);

    final response = await http.post(
      Uri.parse(ApiRoutes.likeMovie),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "data":{
          "movie_id": movieId,
          "user_id": int.parse(userId!),
        }
      }),
    );

    print('STATUS: ${response.statusCode}');
    print('BODY: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return('Ok');
    } else {
      return 'Failed to register user with the API';
    }

  } catch (e) {
    return ('Error: $e');
  }
}
