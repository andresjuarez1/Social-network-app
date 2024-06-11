import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:video_player/video_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';

class CreatePostPage extends StatefulWidget {
  final String email;

  CreatePostPage({required this.email});

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _contentController = TextEditingController();
  File? _image;
  File? _video;
  File? _audio;
  final picker = ImagePicker();
  VideoPlayerController? _videoController;
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

  Future getVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowCompression: true,
    );

    if (result != null) {
      setState(() {
        _video = File(result.files.single.path!);
        _videoController = VideoPlayerController.file(_video!);
        _videoController!.initialize();
      });
    } else {
      print('No se seleccionó ningún video.');
    }
  }

  Future getAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowCompression: true,
    );

    if (result != null) {
      setState(() {
        _audio = File(result.files.single.path!);
      });
    } else {
      print('No se seleccionó ningún audio.');
    }
  }

  void _submitPost() async {
    String content = _contentController.text;

    if (_image != null) {
      print('Ruta de la imagen: ${_image!.path}');
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

        DatabaseReference ref = FirebaseDatabase.instance.ref('Publicaciones');
        String? postId = ref.push().key;

        await ref.child(postId!).set(data);

        print("File uploaded successfully. Download URL: $downloadURL");
      } catch (e) {
        print("Error uploading image: $e");
      }
    }

    if (_video != null) {
      print('Ruta del video: ${_video!.path}');
      try {
        final storageRef = FirebaseStorage.instance.ref();
        final uploadsRef = storageRef.child(
            "${DateTime.now().millisecondsSinceEpoch}_${_video!.path.split('/').last}");

        await uploadsRef.putFile(_video!);

        final downloadURL = await uploadsRef.getDownloadURL();
        final data = {
          "Usuario": widget.email,
          "Descripcion": content,
          "Video": downloadURL
        };
        DatabaseReference ref = FirebaseDatabase.instance.ref('Publicaciones');
        String? postId = ref.push().key;

        await ref.child(postId!).set(data);

        print("File uploaded successfully. Download URL: $downloadURL");
      } catch (e) {
        print("Error uploading video: $e");
      }
    } else {
      print('No se ha seleccionado ningún video.');
    }

    if (_audio != null) {
      print('Ruta del audio: ${_audio!.path}');
      try {
        final storageRef = FirebaseStorage.instance.ref();
        final uploadsRef = storageRef.child(
            "${DateTime.now().millisecondsSinceEpoch}_${_audio!.path.split('/').last}");

        await uploadsRef.putFile(_audio!);

        final downloadURL = await uploadsRef.getDownloadURL();
        final data = {
          "Usuario": widget.email,
          "Descripcion": content,
          "Audio": downloadURL
        };
        DatabaseReference ref = FirebaseDatabase.instance.ref('Publicaciones');
        String? postId = ref.push().key;

        await ref.child(postId!).set(data);

        print("File uploaded successfully. Download URL: $downloadURL");
      } catch (e) {
        print("Error uploading audio: $e");
      }
    } else {
      print('No se ha seleccionado ningún audio.');
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
      body: SingleChildScrollView(
        child: Padding(
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
                  onPressed: getVideo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: peachColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: peachColor),
                    ),
                  ),
                  child: Text(
                    'Seleccionar Video',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 10),
              _video != null
                  ? AspectRatio(
                      aspectRatio: _videoController!.value.aspectRatio,
                      child: VideoPlayer(_videoController!),
                    )
                  : SizedBox(),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: getAudio,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: peachColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: peachColor),
                    ),
                  ),
                  child: Text(
                    'Seleccionar Audio',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 10),
              _audio != null
                  ? Text('Audio seleccionado: ${_audio!.path.split('/').last}',
                      style: TextStyle(color: Colors.white))
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
      ),
    );
  }
}
