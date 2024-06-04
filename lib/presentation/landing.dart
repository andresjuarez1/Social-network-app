import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:c2_movil/presentation/login_page.dart';
import 'package:c2_movil/presentation/create_post_page.dart';

class LandingPage extends StatefulWidget {
  final String email;

  LandingPage({required this.email});
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Publicaciones")
          .where('Usuario',isEqualTo: widget.email)
          .get();

      print("Successfully completed");
      
      for (var docSnapshot in querySnapshot.docs) {
        print('${docSnapshot.id} => ${docSnapshot.data()}');
      }
    } catch (e) {
      print("Error completing: $e");
    }
  }


  void _navigateToLoginPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  void _navigateToCreatePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreatePostPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            Text(
              'Feed',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () => _navigateToCreatePage(context),
                child: Text('Crear Post'),
              ),
            ),
            SizedBox(height: 20),
            Container(
              color: Colors.blue,
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Image.asset(
                    'assets/messi.jpg',
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Titulo',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Esta es una descripción de la imagen de Messi.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () => _navigateToLoginPage(context),
                child: Text('Ir a Login'),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
