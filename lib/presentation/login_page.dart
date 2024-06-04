import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:c2_movil/presentation/register_page.dart';
import 'package:c2_movil/presentation/landing.dart';

class Login extends StatelessWidget {

  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

  void _navigateToRegistrationPage(BuildContext context) {

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegistrationPage()),
    );
  }

  void _navigateToLandingPage(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LandingPage(email: _emailController.text)),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 40),
            TextField(
              controller:_emailController,
              decoration: InputDecoration(
                labelText: 'email',
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Contraseña',
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _navigateToLandingPage(context),
              child: Text('Login'),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () => _navigateToRegistrationPage(context),
              child: Container(
                margin: EdgeInsets.only(left: 20.0),
                child: Text(
                  '¿No estás registrado? Regístrate',
                  style: TextStyle(fontSize: 14.0, color: Colors.blue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
