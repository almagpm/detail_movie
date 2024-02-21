import 'package:flutter/material.dart';
import 'package:pmsn2024/screens/login_screen.dart';
import 'package:splash_view/source/presentation/pages/pages.dart';
import 'package:splash_view/source/presentation/widgets/done.dart';

class SplashCreen extends StatelessWidget {
  const SplashCreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SplashView(
        backgroundColor: Colors.green,
        loadingIndicator: Image.asset('images/loading.gif'),
        logo: Image.network(
            'https://sg.com.mx/sites/default/files/2018-04/LogoITCelaya.png'),
        done: Done(const LoginScreen(),
            animationDuration: const Duration(microseconds: 3000)));
  }
}
