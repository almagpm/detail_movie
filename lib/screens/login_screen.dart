import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;

  final txtUser = TextFormField(
    keyboardType: TextInputType.emailAddress,
    decoration: const InputDecoration(border: OutlineInputBorder()),
  );

  final pwdUser = TextFormField(
    keyboardType: TextInputType.text,
    obscureText: true,
    decoration: const InputDecoration(border: OutlineInputBorder()),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover, image: AssetImage('images/fondo.jpg'))),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 470,
              child: Opacity(
                opacity: .5,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  height: 155,
                  width: MediaQuery.of(context).size.width * .9,
                  //margin: EdgeInsets.symmetric(horizontal: 10),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      txtUser,
                      const SizedBox(
                        height: 10,
                      ),
                      pwdUser
                    ],
                  ),
                ),
              ),
            ),
            //Image.asset('images/halo.png')
            Positioned(
                bottom: 30,
                child: Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width * .9,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      SignInButton(Buttons.Email, onPressed: () {
                        setState(() {
                          isLoading = !isLoading;
                        });
                        Future.delayed(const Duration(milliseconds: 5000), () {
                          /*Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DashboardScreen(),
                              ));*/
                          Navigator.pushNamed(context, "/dash")
                              .then((value) => {
                                    setState(() {
                                      isLoading = !isLoading;
                                    })
                                  });
                        });
                      }),
                      SignInButton(Buttons.Facebook, onPressed: () {}),
                      SignInButton(Buttons.GitHub, onPressed: () {}),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.purple, // Color morado
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0), // Bordes redondeados
                          ),
                        ),
                        child: Text('Registrarse'),
                        onPressed: () {
                          Navigator.pushNamed(context, "/signup");
                        },
                      ),
                                          ],
                  ),
                )),
            isLoading
                ? const Positioned(
                    top: 250,
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
