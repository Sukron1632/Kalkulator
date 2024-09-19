import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application/signup.dart';
import 'firebase_options.dart';
import 'login.dart';
import 'beranda.dart';
import 'kalkulator.dart';
import 'pengecekan.dart';

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
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => const SignUp(),
        '/beranda': (context) => BerandaPage(),
        '/kalkulator': (context) => Calculator(),
        '/pengecekan': (context) => PengecekanPage(),
      },
    );
  }
}
