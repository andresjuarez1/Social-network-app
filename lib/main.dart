import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'presentation/login_page.dart';
import 'data/firestore/firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Login(),
      debugShowCheckedModeBanner: false,
    );
  }
}
//saremana@hotmail.com
//Canelita1