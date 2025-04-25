import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import 'package:loomi_streaming/core/routes/api_routes.dart';
import '../../modules/auth/data/get_Firebase_token.dart';

Future<Map<String, dynamic>?> getUserData() async {
  final token = await getFirebaseToken();
  print('token $token');

  if (token == null) {
    print('User not authenticated');
    return null;
  }

  final response = await http.get(
    Uri.parse(ApiRoutes.getUser),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  log('response get user data ${response.body}');

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    log('userid get user data $data');
    return data;
  } else {
    return null;
  }
}
