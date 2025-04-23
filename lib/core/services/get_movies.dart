import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../modules/auth/data/index.dart';
import '../../modules/model/movie_model.dart';
import '../routes/api_routes.dart';

Future<List<MovieModel>> getMovies() async {
  final token = await getFirebaseToken();
  print('token ${token}');

  if (token == null) {
    print('User not auhenticated');
  }

  final response = await http.get(
    Uri.parse(ApiRoutes.getMovies),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  print('STATUS: ${response.statusCode}');
  log('BODY: ${response.body}');

  final List<MovieModel> movies = [];

  if (response.statusCode == 200) {
    final decoded = jsonDecode(response.body);
    final List data = decoded['data'];
    movies.addAll(data.map((item) => MovieModel.fromJson(item)));
  }
  return movies;
}
