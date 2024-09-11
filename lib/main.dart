import 'package:flutter/material.dart';
import 'login.dart'; // Pastikan path sesuai dengan lokasi file login.dart
import 'kalkulator.dart'; // Pastikan path sesuai dengan lokasi file kalkulator.dart

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      routes: {
        '/kalkulator': (context) => Calculator(),
      },
    );
  }
}
