import 'package:ledapp/firebase_options.dart';
import 'package:ledapp/pages/login/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'pages/signup/signup.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:ledapp/house/bedroom.dart';
import 'package:ledapp/house/entrance.dart';
import 'package:ledapp/house/kitchen.dart';

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
      home: MainPage(), // Main page listing all other pages.
    );
  }
}


class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Main Page",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Bedroom()),
              ),
              child: Text("Go to Bedroom"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Kitchen()),
              ),
              child: Text("Go to Kitchen"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Entrance()),
              ),
              child: Text("Go to Entrance"),
            ),
          ],
        ),
      ),
    );
  }
}