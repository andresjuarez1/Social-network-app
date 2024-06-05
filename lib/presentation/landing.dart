import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';  // Importar Firebase Storage
import 'package:flutter/material.dart';
import 'package:c2_movil/presentation/login_page.dart';
import 'package:c2_movil/presentation/create_post_page.dart';
import 'package:c2_movil/data/models/post_model.dart'; // Asegúrate de ajustar la ruta según la estructura de tu proyecto

class LandingPage extends StatefulWidget {
  final String email;

  LandingPage({required this.email});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  List<Publicacion> publicaciones = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Publicaciones")
          .get();

      List<Publicacion> tempPublicaciones = [];

      for (var doc in querySnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        String gsUrl = data['Imagen'] ?? '';
        String httpUrl = await getDownloadURL(gsUrl);

        tempPublicaciones.add(Publicacion(
          Usuario: data['Usuario'] ?? '',
          Descripcion: data['Descripcion'] ?? '',
          Imagen: httpUrl,
        ));
      }

      setState(() {
        publicaciones = tempPublicaciones;
      });

      print("Successfully completed");
    } catch (e) {
      print("Error completing: $e");
    }
  }

  Future<String> getDownloadURL(String gsUrl) async {
    if (gsUrl.startsWith('gs://')) {
      final ref = FirebaseStorage.instance.refFromURL(gsUrl);
      return await ref.getDownloadURL();
    }
    return gsUrl;
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
      MaterialPageRoute(builder: (context) => CreatePostPage(email: widget.email)),
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
            Expanded(
              child: ListView.builder(
                itemCount: publicaciones.length,
                itemBuilder: (context, index) {
                  final publicacion = publicaciones[index];
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    padding: EdgeInsets.all(16.0),
                    color: Colors.blue,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          publicacion.Imagen,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 5),
                        Text(
                          publicacion.Usuario,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          publicacion.Descripcion,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () => _navigateToLoginPage(context),
                child: Text('Ir a Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
