import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreatePostPage extends StatefulWidget {
  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  File? _image;
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

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

 Future<String?> _uploadImage(File image) async {
  try {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref().child("posts/$fileName");
    UploadTask uploadTask = reference.putFile(image);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    print('Imagen subida con éxito: $downloadUrl');
    return downloadUrl;
  } catch (e) {
    print('Error al subir la imagen: $e');
    return null;
  }
}

void _submitPost() async {
  if (_formKey.currentState!.validate()) {
    setState(() {
      _isLoading = true;
    });

    String title = _titleController.text;
    String content = _contentController.text;

    String? imageUrl;
    try {
      if (_image != null) {
        print('Subiendo imagen...');
        imageUrl = await _uploadImage(_image!);
        print('URL de la imagen: $imageUrl');
      }

      if (imageUrl != null) {
        print('Creando publicación...');
        await FirebaseFirestore.instance.collection('posts').add({
          'title': title,
          'content': content,
          'imageUrl': imageUrl,
          'timestamp': FieldValue.serverTimestamp(),
        });
        print('Publicación creada con éxito.');

        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Publicación creada con éxito')),
        );

        Navigator.pop(context);
      } else {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: la imagen no se pudo subir')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear la publicación: $e')),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Publicación'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Título',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El título es obligatorio.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: 'Contenido',
                ),
                maxLines: null,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El contenido es obligatorio.';
                  }
                  return null;
                },
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
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitPost,
                      child: Text('Enviar Publicación'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
