import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostPage extends StatefulWidget {
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

  void _submitPost() {
    // Enviar la publicación al servidor
    String title = _titleController.text;
    String content = _contentController.text;

    if (_image != null) {
      print('Ruta de la imagen: ${_image!.path}');
    }

    print('Título: $title');
    print('Contenido: $content');
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
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Título',
              ),
            ),
            SizedBox(height: 20),
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
