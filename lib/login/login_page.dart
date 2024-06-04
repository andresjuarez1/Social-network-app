import 'package:flutter/material.dart';
import 'package:c2_movil/register/register_page.dart';
import 'package:c2_movil/landing/landing.dart';

class Login extends StatelessWidget {
  void _navigateToRegistrationPage(BuildContext context) {

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegistrationPage()),
    );
  }

  void _navigateToLandingPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LandingPage()),
    );
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
              decoration: InputDecoration(
                labelText: 'Usuario',
              ),
            ),
            TextField(
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
