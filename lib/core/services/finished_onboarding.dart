import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../modules/auth/data/index.dart';
import '../routes/api_routes.dart';

Future<String> finishedOnboarding() async {
  try {
    final token = await getFirebaseToken();
    print('token ${token}');

    if (token == null) {
      print('User not auhenticated');
    }

    final response = await http.patch(
      Uri.parse(ApiRoutes.finishOnboarding),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        {
          "data": {"finished_onboarding": true}
        }
      }),
    );

    print('STATUS: ${response.statusCode}');
    print('BODY: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ('Ok');
    } else {
      return 'Failed to register user with the API';
    }
  } catch (e) {
    return ('Error: $e');
  }
}
