import 'package:flutter/material.dart';
import 'package:pmsn2024/model/popular_model.dart';
import 'package:pmsn2024/network/api_trailer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailMovieScreen extends StatefulWidget {
 const DetailMovieScreen({Key? key}) : super(key: key);

 @override
 State<DetailMovieScreen> createState() => _DetailMovieScreenState();
}

class _DetailMovieScreenState extends State<DetailMovieScreen> {
  late YoutubePlayerController _controller;
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadTrailer();
  }

  void _loadTrailer() async {
    final popularModel = ModalRoute.of(context)!.settings.arguments as PopularModel;
    final trailerFetcher = MovieTrailerFetcher();
    
    try {
      final trailers = await trailerFetcher.getTrailers(popularModel.id!);
      if (trailers.isNotEmpty) {
        final trailerId = YoutubePlayer.convertUrlToId(trailers[0]);
        if (trailerId != null) {
          setState(() {
            _controller = YoutubePlayerController(
              initialVideoId: trailerId,
              flags: YoutubePlayerFlags(
                autoPlay: false,
                mute: false,
              ),
            );
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error cargando el trailer: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    final popularModel = ModalRoute.of(context)!.settings.arguments as PopularModel;

    // Calcular el porcentaje de popularidad
    double popularityPercentage = (popularModel.voteAverage! / 10) * 100; // Asumiendo que 1000 es el valor máximo posible

    return Scaffold(
      body: Column(
        children: [
          // Parte superior de la pantalla que contiene la imagen y el título de la película
          Expanded(
            flex: 1,
            child: Stack(
              children: [
                // Imagen de la película
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage('https://image.tmdb.org/t/p/w500/${popularModel.backdropPath}'),
                    ),
                  ),
                ),
                // Gradiente de difuminado hacia abajo
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Colors.transparent,
                        Colors.black,
                      ],
                    ),
                  ),
                ),
                // Título de la película y su título original
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        popularModel.title!,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5), // Espacio entre los títulos
                      Text(
                        popularModel.originalTitle!,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Parte inferior de la pantalla que muestra la descripción, el ranking y el círculo de porcentaje
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.black,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0), // Agrega un padding alrededor del contenido
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10), // Agrega un padding alrededor del texto de la descripción
                        child: Text(
                          popularModel.overview?.isNotEmpty ?? false ? popularModel.overview! : "Por el momento esta película no cuenta con una descripción",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      
                      SizedBox(height: 30),
                      Text(
                        'Ranking',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20),
                      CircularProgressIndicator(
                        value: popularityPercentage / 100, // Normalizar el valor a un rango de 0.0 a 1.0
                        strokeWidth: 10,
                        backgroundColor: Colors.grey[300]!,
                        valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 79, 88, 169)),
                      ),
                      SizedBox(height: 30),
                       // Espacio entre los títulos
                      Text(
                        'Trailer',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5),
                      isLoading
                          ? CircularProgressIndicator() 
                          : _controller != null
                              ? YoutubePlayer(
                                  controller: _controller,
                                  showVideoProgressIndicator: true,
                                )
                              : Text('No se encontró ningún trailer'), 
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}