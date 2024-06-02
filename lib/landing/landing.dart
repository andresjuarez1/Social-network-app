import 'package:flutter/material.dart';
import 'package:c2_movil/login/login_page.dart';

class LandingPage extends StatelessWidget {
  void _navigateToLoginPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => _navigateToLoginPage(context),
          child: Text('Ir a Login'),
        ),
      ),
    );
  }
}
