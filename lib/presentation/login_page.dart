import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:c2_movil/presentation/register_page.dart';
import 'package:c2_movil/presentation/landing.dart';

class Login extends StatelessWidget {
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final Color peachColor = Color(0xFFFFDAB9);

  void _navigateToRegistrationPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegistrationPage()),
    );
  }

  void _navigateToLandingPage(BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LandingPage(email: _emailController.text)),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 34, 34, 34),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Bienvenido',
              style: TextStyle(
                  color: Color(0xFFFFDAB9),
                  fontSize: 38,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.white),
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
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                labelStyle: TextStyle(color: Colors.white),
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
            ),
            SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => _navigateToLandingPage(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: peachColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: peachColor),
                  ),
                ),
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 30),
            GestureDetector(
              onTap: () => _navigateToRegistrationPage(context),
              child: Container(
                margin: EdgeInsets.only(left: 20.0),
                child: Text(
                  '¿No estás registrado? ¡Regístrate!',
                  style: TextStyle(fontSize: 14.0, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
