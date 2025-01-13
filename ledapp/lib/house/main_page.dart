import 'package:flutter/material.dart';
import 'package:ledapp/house/bedroom.dart';
import 'package:ledapp/house/kitchen.dart';
import 'package:ledapp/house/entrance.dart';

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
