import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:c2_movil/presentation/login_page.dart';

class RegistrationPage extends StatelessWidget {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final Color peachColor = Color(0xFFFFDAB9);

  void _register(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registro exitoso')),
      );
      Navigator.pop(context);
    }
  }

  void _navigateToLoginPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 34, 34, 34),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 140),
                Text(
                  'Registro',
                  style: TextStyle(
                      color: peachColor,
                      fontSize: 38,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Usuario',
                    labelStyle: TextStyle(color: peachColor),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: peachColor, width: 0.7),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: peachColor, width: 2.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa tu nombre de usuario';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: peachColor),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: peachColor, width: 0.7),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: peachColor, width: 2.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa tu email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    labelStyle: TextStyle(color: peachColor),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: peachColor, width: 0.7),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: peachColor, width: 2.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  obscureText: true,
                  style: TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa tu contraseña';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirmar contraseña',
                    labelStyle: TextStyle(color: peachColor),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: peachColor, width: 0.7),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: peachColor, width: 2.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  obscureText: true,
                  style: TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa tu contraseña nuevamente';
                    }
                    if (value != _passwordController.text) {
                      return 'Las contraseñas no coinciden';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => _register(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: peachColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: peachColor),
                      ),
                    ),
                    child: Text(
                      'Registrar',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () => _navigateToLoginPage(context),
                  child: Container(
                    margin: EdgeInsets.only(left: 20.0),
                    child: Text(
                      '¿Ya estás registrado? Inicia sesión',
                      style: TextStyle(fontSize: 14.0, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
