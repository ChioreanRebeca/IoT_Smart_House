import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Bedroom extends StatefulWidget {
  @override
  _BedroomState createState() => _BedroomState();
}

class _BedroomState extends State<Bedroom> {
  final DatabaseReference ledRef = FirebaseDatabase.instance.ref("led/state");
  final DatabaseReference fanStateRef = FirebaseDatabase.instance.ref("house/fan/state");
  final DatabaseReference fanAutoRef = FirebaseDatabase.instance.ref("house/fan/automatic");
  final DatabaseReference fanIsAutomatic = FirebaseDatabase.instance.ref("house/fan/isAutomatic");
  final DatabaseReference tempRef = FirebaseDatabase.instance.ref("house/temp");

  TextEditingController _tempController = TextEditingController(text: '24');
  int currentTemp = 24;

  void setLedState(int state) {
    ledRef.set(state);
  }

  void setFanState(int state) {
    fanStateRef.set(state);
  }

  void setFanAuto(int state) {
    fanIsAutomatic.set(state);
  }

  void setTemp(int temp) {
    fanAutoRef.set(temp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Bedroom Controls",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => setLedState(1),
                  child: Text("Turn ON LED"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
                ElevatedButton(
                  onPressed: () => setLedState(0),
                  child: Text("Turn OFF LED"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => setFanState(1),
                  child: Text("Turn ON Fan"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
                ElevatedButton(
                  onPressed: () => setFanState(0),
                  child: Text("Turn OFF Fan"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => setFanAuto(1),
                  child: Text("Enable Auto Fan"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                ),
                ElevatedButton(
                  onPressed: () => setFanAuto(0),
                  child: Text("Disable Auto Fan"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _tempController,
                    decoration: InputDecoration(labelText: "Set Temperature"),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        currentTemp = int.tryParse(value) ?? 24;
                      });
                    },
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setTemp(currentTemp);
                  },
                  child: Text("Set"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
              ],
            ),
            SizedBox(height: 30),
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
