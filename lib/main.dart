import 'package:AppaAja/Components/recSite.dart';
import 'package:AppaAja/Components/stopwacth.dart';
import 'package:AppaAja/Components/testing.dart';
import 'package:AppaAja/Components/website_page.dart';
import 'package:AppaAja/layout.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Components/ourteam.dart';
import 'signup.dart';
import 'firebase_options.dart';
import 'login.dart';
import 'Components/kalkulator.dart';
import 'Components/pengecekan.dart';

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
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0.5,
          shadowColor: Colors.black
        )
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => const SignUp(),
        '/kalkulator': (context) => Calculator(),
        '/pengecekan': (context) => PengecekanPage(),
        '/ourteam': (context) => OurTeam(),
        '/stopwacth': (context) => StopWatchPage(),
        '/recsite': (context) => const RecSite(),
        '/layout':(context) => MainPage(),
        '/website':(context) => websitePage(),
        '/testing':(context) => TestingPage(),
      },
    );
  }
}
