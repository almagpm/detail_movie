import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pmsn2024/screens/dashboard_screen.dart';
import 'package:pmsn2024/screens/despensa_screen.dart';
import 'package:pmsn2024/screens/detail_movie_screen.dart';
import 'package:pmsn2024/screens/favoritas_screen.dart';
import 'package:pmsn2024/screens/popular_movies_screen.dart';
import 'package:pmsn2024/screens/signup_screen.dart';
import 'package:pmsn2024/screens/splash_screen.dart';
import 'package:pmsn2024/settings/app_value_notifier.dart';
import 'package:pmsn2024/settings/theme.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey:
          "AIzaSyD1Hb7EsSHj2juDIRMdBu51Nexa4pQBkzI", // paste your api key here
      appId:
          "com.example.pmsn2024", //paste your app id here
      messagingSenderId: "255309806773", //paste your messagingSenderId here
      projectId: "pmsn24-9766f", //paste your project id here
    ),
  );
  await Hive.initFlutter();
  await Hive.openBox('favorites');
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return ValueListenableBuilder(
      valueListenable: AppValueNotifier.banTheme,
      builder: (context, value, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: value ? ThemeApp.darkTheme(context) : ThemeApp.lightTheme(context),
          home: SplashCreen(),
          routes: {
            "/dash" : (BuildContext context) => DashboardScreen(),
            "/signup" : (BuildContext context) => SignUp(),
            "/despensa" : (BuildContext context) => DespensaScreen(),
            "/movies" : (BuildContext context) => const PopularMoviesScreen(),
            "/detail": (BuildContext context) => const DetailMovieScreen(),
            "/favoritas": (BuildContext context) => const FavoriteMoviesScreen(),

          },
        );
      },
    );
  }
}

/*class MyApp extends StatefulWidget {
   MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int contador = 0;

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
          backgroundColor: Colors.grey,
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: const Text(
              'Practica 1',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          drawer: Drawer(),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.red,
            onPressed: () {
              contador ++;
              print(contador);
              setState(() {
                
              });
            },
            child: Icon(Icons.ads_click),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.network(
                            'https://celaya.tecnm.mx/wp-content/uploads/2021/02/cropped-FAV.png',
                            height: 250,),
              ),
              Text('Valor del contador $contador' )
            ],
          )),
    );
  }
}*/