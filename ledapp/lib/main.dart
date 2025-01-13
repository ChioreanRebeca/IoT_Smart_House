import 'package:ledapp/firebase_options.dart';
import 'package:ledapp/pages/login/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:ledapp/house/bedroom.dart';
import 'package:ledapp/house/entrance.dart';
import 'package:ledapp/house/kitchen.dart';
import 'package:ledapp/house/main_page.dart'; 

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Automation',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Login(), // Main page listing all other pages.
    );
  }
}
