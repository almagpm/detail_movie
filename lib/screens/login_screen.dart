import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

   final txtUser = TextFormField(
    keyboardType: TextInputType.emailAddress,
   );
   final pwdUser = TextFormField(
    keyboardType: TextInputType.text,
    obscureText: true,
   );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('images/fondogears.jpg')
            )
         ),
         child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset('images/logo_text.png'),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              color: Colors.black,
              height: 200,
              child: ListView(
                shrinkWrap: true,
                children: [
                  txtUser,
                  pwdUser
                ],
              ),
            )
          ],
         ),
      ),
    );
  }
}