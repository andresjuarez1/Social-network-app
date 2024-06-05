import 'dart:io';

import 'package:c2_movil/data/models/post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CreatePostPage extends StatefulWidget {
  final String email;

  CreatePostPage({required this.email});
  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  File? _image; 
  final picker = ImagePicker();

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
      final uploadsRef = storageRef.child("${DateTime.now().millisecondsSinceEpoch}_${_image!.path.split('/').last}");

      await uploadsRef.putFile(_image!);

      final downloadURL = await uploadsRef.getDownloadURL();
      final data = {
        "Usuario": widget.email,
        "Descripcion": content,
        "Imagen": downloadURL
      };
      var db = FirebaseFirestore.instance
          .collection("Publicaciones")
          .add(data).then((documentSnapshot) =>
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
      appBar: AppBar(
        title: Text('Crear Publicación'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: 'Contenido',
              ),
              maxLines: null,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: getImage,
              child: Text('Seleccionar Imagen'),
            ),
            SizedBox(height: 10),
            _image != null
                ? Image.file(
                    _image!,
                    height: 150,
                  )
                : SizedBox(), 
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitPost,
              child: Text('Enviar Publicación'),
            ),
          ],
        ),
      ),
    );
  }
}
