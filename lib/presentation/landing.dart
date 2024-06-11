import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:c2_movil/presentation/login_page.dart';
import 'package:c2_movil/presentation/create_post_page.dart';
import 'package:c2_movil/data/models/post_model.dart';

class LandingPage extends StatefulWidget {
  final String email;

  LandingPage({required this.email});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  List<Publicacion> publicaciones = [];
  final Color peachColor = Color(0xFFFFDAB9);
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _reloadData();
  }
  @override
  void didUpdateWidget(covariant LandingPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _reloadData();
  }

  void _reloadData(){
    setState(() {
      isLoading = true;
    });
    fetchData().then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }
  Future<String> getDownloadURL(String gsUrl) async {
    if (gsUrl.startsWith('gs://')) {
      final ref = FirebaseStorage.instance.refFromURL(gsUrl);
      return await ref.getDownloadURL();
    }
    return gsUrl;
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection("Publicaciones").get();

      List<Publicacion> tempPublicaciones = [];

      for (var doc in querySnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        String gsImagenUrl = data['Imagen'] ?? '';
        String httpImagenUrl = await getDownloadURL(gsImagenUrl);

        String gsVideoUrl = data['Video'] ?? '';
        String httpVideoUrl = await getDownloadURL(gsVideoUrl);

        tempPublicaciones.add(Publicacion(
          Usuario: data['Usuario'] ?? '',
          Descripcion: data['Descripcion'] ?? '',
          Imagen: httpImagenUrl,
          Video: httpVideoUrl, 
        ));
      }

      setState(() {
        publicaciones = tempPublicaciones;
        isLoading = false;
      });

      print("Successfully completed");
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error completing: $e");
    }
  }

  Widget _buildPostWidget(Publicacion publicacion) {
    if (publicacion.Video != null && publicacion.Video!.isNotEmpty) {
      return VideoPlayerWidget(videoUrl: publicacion.Video!);
    } else {
      return Image.network(publicacion.Imagen);
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
      MaterialPageRoute(
          builder: (context) => CreatePostPage(email: widget.email)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Feed',
              style: TextStyle(color: peachColor),
            ),
          ],
        ),
        actions: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 6.0),
            decoration: BoxDecoration(
              color: peachColor,
              borderRadius: BorderRadius.circular(9.0),
            ),
            child: IconButton(
              icon: Icon(Icons.add),
              onPressed: () => _navigateToCreatePage(context),
              color: Colors.black,
            ),
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => _reloadData(),
            color: peachColor,
          ),
        ],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: Container(
          color: peachColor,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(height: 80),
              Center(
                child: Text(
                  'Menú',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 30,
                  ),
                ),
              ),
              SizedBox(height: 560),
              ListTile(
                leading: Icon(Icons.exit_to_app, color: Colors.black, size: 20),
                title: Text(
                  'Cerrar sesión',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                onTap: () {
                  _navigateToLoginPage(context);
                },
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: publicaciones.length,
                itemBuilder: (context, index) {
                  final publicacion = publicaciones[index];
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: peachColor,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: peachColor,
                        width: 1.0,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildPostWidget(publicacion),
                        SizedBox(height: 5),
                        Center(
                          child: Text(
                            publicacion.Usuario,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 7),
                        Center(
                          child: Text(
                            publicacion.Descripcion,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  VideoPlayerWidget({required this.videoUrl});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    )
        : CircularProgressIndicator();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
