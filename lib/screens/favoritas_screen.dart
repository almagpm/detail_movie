import 'package:flutter/material.dart';
import 'package:pmsn2024/network/api_lista.dart'; // Importa la clase ApiFavorites

class FavoriteMoviesScreen extends StatefulWidget {
  const FavoriteMoviesScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteMoviesScreen> createState() => _FavoriteMoviesScreenState();
}

class _FavoriteMoviesScreenState extends State<FavoriteMoviesScreen> {
  final ApiFavorites apiFavorites = ApiFavorites(); // Instancia de ApiFavorites

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Películas Favoritas'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: apiFavorites.getFavoriteMovies(), // Llama al método getFavoriteMovies
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay películas favoritas'));
          } else {
            return GridView.builder(
              itemCount: snapshot.data!.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                // Aquí puedes acceder a los datos de la película desde snapshot.data[index]
                return GestureDetector(
                  onTap: () => Navigator.pushNamed(context, "/detail", arguments: snapshot.data![index]),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: FadeInImage(
                      placeholder: AssetImage('images/loading.gif'),
                      image: NetworkImage('https://image.tmdb.org/t/p/w500/${snapshot.data![index]['poster_path']}'),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
