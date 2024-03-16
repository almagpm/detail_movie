import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:pmsn2024/services/email_auth_firebase.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final authFirebase = EmailAuthFirebase();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();



  bool isLoading = false;

  

  @override
  Widget build(BuildContext context) {

    final txtUser = TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(border: OutlineInputBorder()),
    );

    final pwdUser = TextFormField(
      controller: _passwordController,
      keyboardType: TextInputType.text,
      obscureText: true,
      decoration: const InputDecoration(border: OutlineInputBorder()),
    );

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover, image: AssetImage('images/signup.jpg'))),
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

                        //Clase 15 marzo Ruben

                        authFirebase.signInUser(
                          password: _passwordController.text,
                          email: _emailController.text
                        ).then(
                          (value) {
                            if (!value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:Text(
                                    'Se encontro el usuario.'
                                    ),
                                    backgroundColor: Colors.green,
                                ),
                              );
                            }else {
                                Navigator.pushNamed(context, "/dash");
                            }
                          },
                        );
                        
                      }),
                      SignInButton(Buttons.Facebook, onPressed: () {}),
                      
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.grey, // Color gris para el fondo del botón
                          onPrimary: Colors.black, // Color negro para el texto del botón
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
