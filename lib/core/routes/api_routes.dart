class ApiRoutes {
  static const baseUrl = 'https://untold-strapi.api.prod.loomi.com.br/api';

  // Auth
  static const register = '$baseUrl/auth/local/register';

  // User
  static const getUser = '$baseUrl/users/me';
  static const updateUser = '$baseUrl/users/updateMe';
  static String deleteUser(String userId) => '$baseUrl/users/$userId';

  // Onboarding
  static const finishOnboarding = '$baseUrl/users/updateMe';

  // Movies
  static const getMovies = '$baseUrl/movies?populate=poster';

  // Likes
  static const getLikes = '$baseUrl/likes?populate=*';
  static const likeMovie = '$baseUrl/likes';
  static String dislikeMovie(String likeId) => '$baseUrl/likes/$likeId';

  // Subtitles
  static getSubtitles(int movieId) =>
      '$baseUrl/subtitles?populate=file&filters%5Bmovie_id%5D=$movieId';
}
