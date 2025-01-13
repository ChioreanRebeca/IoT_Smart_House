// import 'package:flutter/material.dart';

// class Kitchen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Kitchen")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               "Kitchen",
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text("Back to Main Page"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Kitchen extends StatefulWidget {
  @override
  _KitchenPageState createState() => _KitchenPageState();
}

class _KitchenPageState extends State<Kitchen> {
  final DatabaseReference gasRef = FirebaseDatabase.instance.ref("/house/gas-leak");
  final DatabaseReference tempRef = FirebaseDatabase.instance.ref("/house/temp");
  final DatabaseReference humidityRef = FirebaseDatabase.instance.ref("/house/humidity");

  bool gasLeak = false;
  double temperature = 0.0;
  double humidity = 0.0;

  @override
  void initState() {
    super.initState();

    gasRef.onValue.listen((event) {
      setState(() {
        gasLeak = event.snapshot.value == true;
      });
    });

    tempRef.onValue.listen((event) {
      setState(() {
        temperature = (event.snapshot.value as num?)?.toDouble() ?? 0.0;
      });
    });

    humidityRef.onValue.listen((event) {
      setState(() {
        humidity = (event.snapshot.value as num?)?.toDouble() ?? 0.0;
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
              "Kitchen",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              "Temperature: ${temperature.toStringAsFixed(1)}°C",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              "Humidity: ${humidity.toStringAsFixed(1)}%",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              "Gas Leak: ${gasLeak ? "Yes" : "No"}",
              style: TextStyle(
                fontSize: 18,
                color: gasLeak ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (gasLeak)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  "WARNING: High gas levels detected!",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
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