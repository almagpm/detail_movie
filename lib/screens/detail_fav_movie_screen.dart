import 'package:flutter/material.dart';
import 'package:pmsn2024/model/popular_model.dart';
import 'package:pmsn2024/network/api_actores.dart';
import 'package:pmsn2024/network/api_lista.dart';
import 'package:pmsn2024/network/api_trailer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailFavScreen extends StatefulWidget {
 const DetailFavScreen({Key? key}) : super(key: key);

 @override
 State<DetailFavScreen> createState() => _DetailFavScreenState();
}

class _DetailFavScreenState extends State<DetailFavScreen> {
 late YoutubePlayerController _controller;
 bool isLoading = true;
 bool isFavorite = false; 
 final ApiFavorites apiFavorites = ApiFavorites(); 
 Key favoriteKey = UniqueKey(); 
 late List<Map<String, dynamic>> cast = [];
 List<Map<String, dynamic>> providers = [];
 List<String> reviews = [];
 bool showReviews = false;


 @override
 void didChangeDependencies() {
    super.didChangeDependencies();
    _loadTrailer();
    _checkIsFavorite(); 
    _loadCast();
    _loadProviders();
    _loadReviews();
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


void _toggleFavorite() async {
  final popularModel = ModalRoute.of(context)!.settings.arguments as PopularModel;
  try {
    if (isFavorite) {
      await apiFavorites.removeFromFavorites(popularModel.id!);
    } else {
      await apiFavorites.addToFavorites(popularModel.id!);
    }
    
    _checkIsFavorite();
    
    setState(() {
      favoriteKey = UniqueKey();
    });

    // Utilizar Navigator para volver a la pantalla de favoritos
    Navigator.pop(context, true); // true indica que se actualizó la lista de favoritos
  } catch (e) {
    print('Error: $e');
  }
}






 
 void _checkIsFavorite() async {
    final popularModel = ModalRoute.of(context)!.settings.arguments as PopularModel;
    try {
      final favoriteMovies = await apiFavorites.getFavoriteMovies();
      setState(() {
        isFavorite = favoriteMovies.any((movie) => movie['id'] == popularModel.id);
      });
    } catch (e) {
      print('Error al verificar si la película está en favoritos: $e');
    }
 }

 void _loadCast() async {
    final popularModel = ModalRoute.of(context)!.settings.arguments as PopularModel;
    final castFetcher = MovieCastFetcher();

    try {
      final castData = await castFetcher.getCast(popularModel.id!);
      setState(() {
        cast = castData;
      });
    } catch (e) {
      print('Error loading cast with images: $e');
    }
 }

 void _loadProviders() async {
  final popularModel = ModalRoute.of(context)!.settings.arguments as PopularModel;
  final providerFetcher = MovieCastFetcher();

  try {
    Map<String, dynamic> providerData = await providerFetcher.getProviders(popularModel.id!);
    setState(() {
      providers = providerData['providers'] as List<Map<String, dynamic>>;
    });
  } catch (e) {
    print('Error cargando los proveedores: $e');
  }
}

void _loadReviews() async {
    final popularModel = ModalRoute.of(context)!.settings.arguments as PopularModel;
    final reviewFetcher = MovieCastFetcher(); 

    try {
      reviews = await reviewFetcher.getReviews(popularModel.id!);
    } catch (e) {
      print('Error cargando las reseñas: $e');
    }
 }


 @override
 Widget build(BuildContext context) {
    final popularModel = ModalRoute.of(context)!.settings.arguments as PopularModel;

    // Calcular el porcentaje de popularidad
    double popularityPercentage = (popularModel.voteAverage! / 10) * 100; 
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 2, 10, 43),
        title: Text(
          'Detalles',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            key: favoriteKey, 
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
            ),
            onPressed: _toggleFavorite, 
          ),
        ],
      ),
      body: Column(
        children: [
          
          Expanded(
            flex: 1,
            child: Stack(
              children: [
                
                Hero(
                  tag: 'poster_${popularModel.id}', 
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage('https://image.tmdb.org/t/p/w500/${popularModel.backdropPath}'),
                      ),
                    ),
                  ),
                ),
                                
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
                      SizedBox(height: 5), 
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
          
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.black,
              child: SingleChildScrollView(
                child: Padding(
                 padding: const EdgeInsets.all(20.0), 
                 child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 50),
                       
                      Text(
                        'Descripciòn',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Divider(), 
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.all(10), 
                        
                        child: Text(
                          popularModel.overview?.isNotEmpty ?? false ? popularModel.overview! : "Por el momento esta película no cuenta con una descripción",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 20),
                      Divider(), 
                      SizedBox(height: 20),
                      SizedBox(height: 20),
                      
                      Text(
                        'Ranking',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20),
                      Divider(), 
                      SizedBox(height: 20),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${popularityPercentage.toStringAsFixed(2)}%', 
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 50), 
                             CircularProgressIndicator(
                                value: popularityPercentage / 100, 
                                strokeWidth: 10,
                                backgroundColor: Colors.grey[300]!,
                                valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 79, 88, 169)),
                              ),
                          ],
                        ),
                      SizedBox(height: 20),
                      Divider(), 
                      SizedBox(height: 30),
                      Text(
                        'Actores',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20),
                      Divider(),
                      SizedBox(height: 10),
                      Container(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: cast.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    width: 80,
                                    height: 80, // Tamaño reducido de la imagen
                                    child: ClipOval(
                                      child: cast[index]['profilePath'] != null
                                          ? Image.network(
                                              cast[index]['profilePath'],
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.network(
                                              'https://static.vecteezy.com/system/resources/thumbnails/019/879/186/small/user-icon-on-transparent-background-free-png.png',
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    cast[index]['name'],
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    cast[index]['character'],
                                    style: TextStyle(color: Colors.grey, fontSize: 12),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      Divider(), 
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
                      SizedBox(height: 20),
                      Divider(), 
                      SizedBox(height: 20),
                      isLoading
                          ? CircularProgressIndicator() 
                          : _controller != null
                              ? YoutubePlayer(
                                 controller: _controller,
                                 showVideoProgressIndicator: true,
                                )
                              : Text('No se encontró ningún trailer'), 
                              SizedBox(height: 30),
                        Divider(), 
                        SizedBox(height: 60),
                         Text(
                          'Proveedores',
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20),
                      Divider(), 
                      SizedBox(height: 20),
                        providers.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: providers.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(
                                      providers[index]['name'],
                                      style: TextStyle(color: Colors.white), 
                                    ),
                                    subtitle: Text(
                                      providers[index]['description'],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  );
                                },
                              )
                            : Text(
                                'No hay proveedores de streaming disponibles',
                                style: TextStyle(color: const Color.fromARGB(255, 175, 175, 175)), 
                              ),
                            SizedBox(height: 60),
                        ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  showReviews = !showReviews; 
                                });
                              },
                              icon: Icon(
                                Icons.comment,
                                color: Color.fromARGB(255, 13, 50, 130),
                              ),
                              label: Text(
                                'Ver Reseñas',
                                style: TextStyle(
                                  color:Color.fromARGB(255, 13, 50, 130), 
                                ),
                              ),
                            ),
                            if (showReviews)
                            Container(
                              padding: EdgeInsets.all(10),
                              child: reviews.isNotEmpty
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: reviews.length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            Divider(), 
                                            Text(
                                              reviews[index],
                                              style: TextStyle(
                                                color: Color.fromARGB(255, 177, 177, 177), 
                                              ),
                                            ),
                                            Divider(),
                                            SizedBox(height: 10),
                                          ],
                                        );
                                      },
                                    )
                                  : Center(
                                      child: Text(
                                        'Por el momento no hay reseñas de esta película',
                                        style: TextStyle(
                                          color: const Color.fromARGB(255, 191, 191, 191),
                                        ),
                                      ),
                                    ),
                            ),


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
    _controller.pause();
    _controller.dispose(); 
    super.dispose();
 }
}




