import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'transition.dart'; // Importa la clase de transición

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class ImageSelector extends StatefulWidget {
  @override
  _ImageSelectorState createState() => _ImageSelectorState();
}

class _ImageSelectorState extends State<ImageSelector> {
  XFile? _image;

  Future<void> _getImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: _image == null
              ? InkWell(
                  onTap: _getImage,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person, size: 50), // Icono por defecto
                      Text('Seleccionar imagen'), // Texto por defecto
                    ],
                  ),
                )
              : Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius:  50,
                      backgroundImage: FileImage(File(_image!.path)),
                    ),
                    Positioned(
                      bottom: 0,
                      child: IconButton(
                        onPressed: _getImage,
                        icon: Icon(Icons.edit),
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: Color(0xFFC8AD8D), // Fondo de toda la pantalla
          ),
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: ShakeTransition(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: kToolbarHeight + 20),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Color(0xFF273A2D), // Color de fondo del texto "Regístrate"
                        borderRadius: BorderRadius.circular(20), // Bordes redondeados
                      ), // Color de fondo del texto "Regístrate"
                      child: Center(
                        child: Text(
                          'Regístrate',
                          style: TextStyle(
                            color: Colors.white, // Texto blanco
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color(0xFF9DC09D), // Color de fondo del formulario
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SingleChildScrollView(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ImageSelector(),
                                  SizedBox(height: 20),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    child: TextFormField(
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                        labelText: 'Nombre',
                                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                        border: InputBorder.none,
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Debe ingresar un nombre';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    child: TextFormField(
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                        labelText: 'Email',
                                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                        border: InputBorder.none,
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Por favor ingresa tu email';
                                        } else if (!EmailValidator.validate(value)) {
                                          return 'Ingresa un email valido';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    child: TextFormField(
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                        labelText: 'Contraseña',
                                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                        border: InputBorder.none,
                                      ),
                                      obscureText: true,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Por favor ingresa tu contraseña';
                                        } else if (value.length < 6) {
                                          return 'La contraseña debe tener al menos 6 caracteres';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // Si el formulario es válido, realiza la acción deseada
              // Por ejemplo, enviar los datos del formulario a un servidor
            }
          },
          child: Text(
            'Sign Up',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
