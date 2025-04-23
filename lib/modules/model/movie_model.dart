class MovieModel {
  final int id;
  final String name;
  final String synopsis;
  final String genre;
  final String endDate;
  final String streamLink;
  final String posterUrl;

  MovieModel({
    required this.id,
    required this.name,
    required this.synopsis,
    required this.genre,
    required this.endDate,
    required this.streamLink,
    required this.posterUrl,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    final attributes = json['attributes'];
    final posterData = attributes['poster']?['data']?['attributes']?['formats']?['large'] ??
        attributes['poster']?['data']?['attributes']?['formats']?['medium'] ??
        attributes['poster']?['data']?['attributes']?['formats']?['small'] ??
        attributes['poster']?['data']?['attributes'];

    return MovieModel(
      id: json['id'],
      name: attributes['name'] ?? '',
      synopsis: attributes['synopsis'] ?? '',
      genre: attributes['genre'] ?? '',
      endDate: attributes['end_date'] ?? '',
      streamLink: attributes['stream_link'] ?? '',
      posterUrl: posterData?['url'] ?? '',
    );
  }
}
