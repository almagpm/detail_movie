import 'package:flutter/material.dart';
import 'package:pmsn2024/screens/login_screen.dart';
import 'package:splash_view/source/presentation/presentation.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SplashView(
      backgroundColor: Colors.green[600],
      logo: Image.network(
                            'https://celaya.tecnm.mx/wp-content/uploads/2021/02/cropped-FAV.png',
                            height: 250,),
      loadingIndicator: CircularProgressIndicator(),
      //loadingIndicator: Image.asset('images/loading-7528_512.gif'),
      done: Done(
        const LoginScreen(),
        animationDuration: const Duration(milliseconds: 3000)
      ),
    );
  }
}