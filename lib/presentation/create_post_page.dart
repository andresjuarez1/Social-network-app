import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:c2_movil/data/models/post_model.dart';

class CreatePostPage extends StatefulWidget {
  final String email;

  CreatePostPage({required this.email});

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _contentController = TextEditingController();
  File? _image;
  final picker = ImagePicker();
  final Color peachColor = Color(0xFFFFDAB9);

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No se seleccionó ninguna imagen.');
      }
    });
  }

  void _submitPost() async {
    String content = _contentController.text;

    if (_image != null) {
      print('Ruta de la imagen: ${_image!.path}');
    }
    print('Contenido: $content');
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final uploadsRef = storageRef.child(
          "${DateTime.now().millisecondsSinceEpoch}_${_image!.path.split('/').last}");

      await uploadsRef.putFile(_image!);

      final downloadURL = await uploadsRef.getDownloadURL();
      final data = {
        "Usuario": widget.email,
        "Descripcion": content,
        "Imagen": downloadURL
      };
      var db = FirebaseFirestore.instance
          .collection("Publicaciones")
          .add(data)
          .then((documentSnapshot) =>
              print("Added Data with ID: ${documentSnapshot.id}"));
      ;
      print("File uploaded successfully. Download URL: $downloadURL");
    } catch (e) {
      print("Error uploading file: $e");
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Padding(
          padding: const EdgeInsets.only(left: 31.0),
          child: Text(
            'Crear Publicación',
            style: TextStyle(color: peachColor),
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: peachColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: peachColor),
                  ),
                ),
                child: TextField(
                  controller: _contentController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Contenido',
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: getImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: peachColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: peachColor),
                  ),
                ),
                child: Text(
                  'Seleccionar Imagen',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 10),
            _image != null
                ? Image.file(
                    _image!,
                    height: 150,
                  )
                : SizedBox(),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _submitPost,
                style: ElevatedButton.styleFrom(
                  backgroundColor: peachColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: peachColor),
                  ),
                ),
                child: Text(
                  'Enviar Publicación',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
