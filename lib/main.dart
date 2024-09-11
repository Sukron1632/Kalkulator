import 'package:flutter/material.dart';
import 'login.dart'; // Pastikan path sesuai dengan lokasi file login.dart
import 'kalkulator.dart'; // Pastikan path sesuai dengan lokasi file kalkulator.dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
