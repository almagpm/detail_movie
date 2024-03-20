import 'package:dio/dio.dart';
import 'package:pmsn2024/model/popular_model.dart';

class ApiFavorites {
  final String apiKey = '558a6043ffaf21488d74cb6f44181b9a';
  final String sessionId = 'eb339ec8bbda93bd30571a67e348489c4caf0aee'; 
  final String authorizedRequestToken = 'f247ac9d44b01b012dbed17754f1daea1409d669'; 

  Future<List<Map<String, dynamic>>> getFavoriteMovies() async {
    try {
      final dio = Dio();
      final response = await dio.get(
        'https://api.themoviedb.org/3/account/21050747/favorite/movies',
        queryParameters: {
          'api_key': apiKey,
          'session_id': sessionId,
        },
      );

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> favoriteMovies = List<Map<String, dynamic>>.from(response.data['results']);
        return favoriteMovies;
      } else {
        throw Exception('Failed to retrieve favorite movies');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> addToFavorites(int movieId) async {
    try {
      final dio = Dio();
      final response = await dio.post(
        'https://api.themoviedb.org/3/account/21050747/favorite',
        queryParameters: {
          'api_key': apiKey,
          'session_id': sessionId,
        },
        data: {
          'media_type': 'movie',
          'media_id': movieId,
          'favorite': true,
        },
      );

      if (response.statusCode == 200) {
        print('Película agregada a favoritos');
      } else {
        print('Película agregada a favoritos');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> removeFromFavorites(int movieId) async {
    try {
      final dio = Dio();
      final response = await dio.post(
        'https://api.themoviedb.org/3/account/21050747/favorite',
        queryParameters: {
          'api_key': apiKey,
          'session_id': sessionId,
        },
        data: {
          'media_type': 'movie',
          'media_id': movieId,
          'favorite': false,
        },
      );

      if (response.statusCode == 200) {
        print('Película eliminada de favoritos');
      } else {
        throw Exception('Error al eliminar la película de favoritos');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
  Future<PopularModel?> getMovieDetails(int movieId) async {
    try {
      final dio = Dio();
      final response = await dio.get(
        'https://api.themoviedb.org/3/movie/$movieId?api_key=558a6043ffaf21488d74cb6f44181b9a&language=es',
      );

      if (response.statusCode == 200) {
        return PopularModel.fromMap(response.data); 
      } else {
        throw Exception('Failed to retrieve movie details');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
