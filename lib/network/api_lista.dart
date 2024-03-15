import 'package:dio/dio.dart';

class ApiFavorites {
  final String apiKey = '558a6043ffaf21488d74cb6f44181b9a'; // Reemplaza con tu clave de API de TMDb
  final String accessToken = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1NThhNjA0M2ZmYWYyMTQ4OGQ3NGNiNmY0NDE4MWI5YSIsInN1YiI6IjY1ZTI1NWI3ZGFmNTdjMDE2MjljN2FkZCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.42ZeeZBc0uctyVirKsWqvJ5LS3RcN2UQxJxsEChbi38'; // Reemplaza con tu token de acceso de TMDb

  Future<Map<String, dynamic>> getSessionData() async {
    try {
      final dio = Dio();
      final response = await dio.get(
        'https://api.themoviedb.org/3/authentication/session/new',
        queryParameters: {
          'api_key': apiKey,
          'request_token': accessToken,
        },
      );

      if (response.statusCode == 200) {
        final sessionId = response.data['session_id'];
        final accountId = response.data['account_id'];
        return {'sessionId': sessionId, 'accountId': accountId};
      } else {
        throw Exception('Failed to retrieve session data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getFavoriteMovies() async {
    try {
      final sessionData = await getSessionData();
      final sessionId = sessionData['sessionId'];
      final accountId = sessionData['accountId'];

      final dio = Dio();
      final response = await dio.get(
        'https://api.themoviedb.org/3/account/$accountId/favorite/movies',
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
      final sessionData = await getSessionData();
      final sessionId = sessionData['sessionId'];
      final dio = Dio();
      final response = await dio.post(
        'https://api.themoviedb.org/3/account/{account_id}/favorite',
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
        print('Error al agregar la película a favoritos');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> removeFromFavorites(int movieId) async {
    try {
      final sessionData = await getSessionData();
      final sessionId = sessionData['sessionId'];
      final dio = Dio();
      final response = await dio.post(
        'https://api.themoviedb.org/3/account/{account_id}/favorite',
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
        print('Error al eliminar la película de favoritos');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
