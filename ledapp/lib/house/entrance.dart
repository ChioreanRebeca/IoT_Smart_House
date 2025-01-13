import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Entrance extends StatefulWidget {
  @override
  _EntrancePageState createState() => _EntrancePageState();
}

class _EntrancePageState extends State<Entrance> {
  final DatabaseReference motionRef = FirebaseDatabase.instance.ref("/house/movement");
  final DatabaseReference noiseRef = FirebaseDatabase.instance.ref("/house/sound");

  bool motionDetected = false;
  bool noiseDetected = false;

  @override
  void initState() {
    super.initState();

    // Listen for motion detection updates
    motionRef.onValue.listen((event) {
      setState(() {
        motionDetected = event.snapshot.value == true;
      });
    });

    // Listen for noise detection updates
    noiseRef.onValue.listen((event) {
      setState(() {
        noiseDetected = event.snapshot.value == true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Entrance",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              "Motion Detected:",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              motionDetected ? "Yes" : "No",
              style: TextStyle(
                fontSize: 24,
                color: motionDetected ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              "Noise Detected:",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              noiseDetected ? "Yes" : "No",
              style: TextStyle(
                fontSize: 24,
                color: noiseDetected ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Back to Main Page"),
            ),
          ],
        ),
      ),
    );
  }
}