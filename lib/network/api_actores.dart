import 'dart:convert';
import 'package:http/http.dart' as http;

class MovieCastFetcher {
 static const String apiKey = '558a6043ffaf21488d74cb6f44181b9a'; 
 static const String baseUrl = 'https://api.themoviedb.org/3/movie/';

 Future<List<String>> getCast(int movieId) async {
    List<String> cast = [];
    final response = await http.get(Uri.parse('$baseUrl$movieId/credits?api_key=$apiKey'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var results = data['cast'];
      for (var actor in results) {
        if (actor['order'] <= 5) { 
          cast.add('${actor['name']} como ${actor['character']}');
        }
      }
    } else {
      throw Exception('Failed to load cast.');
    }
    return cast;
 }
 Future<List<String>> getReviews(int movieId) async {
    List<String> reviews = [];
    final response = await http.get(Uri.parse('$baseUrl$movieId/reviews?api_key=$apiKey'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var results = data['results'];
      for (var review in results) {
        reviews.add('${review['author']}: ${review['content']}');
      }
    } else {
      throw Exception('Failed to load reviews.');
    }
    return reviews;
 }

 Future<Map<String, dynamic>> getProviders(int movieId) async {
  Map<String, dynamic> providers = {};
  final response = await http.get(Uri.parse('$baseUrl$movieId/watch/providers?api_key=$apiKey'));

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    if (data['results'] != null && data['results'].isNotEmpty) {
      providers = data['results'];
    }
  } else {
    throw Exception('Failed to load providers.');
  }
  return providers;
}

}
