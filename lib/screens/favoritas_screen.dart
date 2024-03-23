import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pmsn2024/model/popular_model.dart';
import 'package:pmsn2024/network/api_lista.dart'; 

class FavoriteMoviesScreen extends StatefulWidget {
  const FavoriteMoviesScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteMoviesScreen> createState() => _FavoriteMoviesScreenState();
}

class _FavoriteMoviesScreenState extends State<FavoriteMoviesScreen> {
  final ApiFavorites apiFavorites = ApiFavorites();
  late StreamSubscription<void> _updateSubscription;
  List<Map<String, dynamic>> _favoriteMovies = [];

  @override
  void initState() {
    super.initState();
    _updateSubscription = apiFavorites.updateStream.listen((_) {
      _loadFavoriteMovies();
    });
    _loadFavoriteMovies(); 
  }

  @override
  void dispose() {
    _updateSubscription.cancel();
    super.dispose();
  }

  Future<void> _loadFavoriteMovies() async {
    final favoriteMovies = await apiFavorites.getFavoriteMovies();
    setState(() {
      _favoriteMovies = favoriteMovies;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 2, 10, 43),
        title: Text(
          'Lista de favoritos',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      body: RefreshIndicator(
        onRefresh: _loadFavoriteMovies,
        child: _favoriteMovies.isEmpty
            ? Center(child: Text('No hay películas favoritas', style: TextStyle(color: Colors.white)))
            : GridView.builder(
                itemCount: _favoriteMovies.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final movieId = _favoriteMovies[index]['id'] as int;
                  final movieDetailsFuture = apiFavorites.getMovieDetails(movieId);
                  return FutureBuilder<PopularModel?>(
                    future: movieDetailsFuture,
                    builder: (context, movieSnapshot) {
                      if (movieSnapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (movieSnapshot.hasError) {
                        return Center(child: Text('Error: ${movieSnapshot.error}'));
                      } else if (movieSnapshot.hasData) {
                        final movieDetails = movieSnapshot.data!;
                        return GestureDetector(
                        onTap: () async {
                          final result = await Navigator.pushNamed(context, "/detailf", arguments: movieDetails);
                          if (result != null && result is bool && result) {
                            // Se actualizó la lista de películas favoritas
                            _loadFavoriteMovies(); 
                          }
                        },
                        child: Hero(
                          tag: 'poster_${movieDetails.id}',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: FadeInImage(
                              placeholder: AssetImage('images/loading.gif'),
                              image: NetworkImage('https://image.tmdb.org/t/p/w500/${movieDetails.posterPath}'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                      } else {
                        return Center(child: Text('No se encontraron detalles de la película'));
                      }
                    },
                  );
                },
              ),
      ),
    );
  }
}
