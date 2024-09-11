import 'package:flutter/material.dart';
import 'login.dart'; // Pastikan path sesuai dengan lokasi file login.dart
import 'beranda.dart'; // Pastikan path sesuai dengan lokasi file beranda.dart
import 'kalkulator.dart'; // Pastikan path sesuai dengan lokasi file kalkulator.dart
import 'pengecekan.dart'; // Pastikan path sesuai dengan lokasi file pengecekan.dart

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login', // Rute awal adalah halaman login
      routes: {
        '/login': (context) => LoginPage(), // Halaman login
        '/beranda': (context) => BerandaPage(), // Halaman beranda setelah login berhasil
        '/kalkulator': (context) => Calculator(), // Halaman kalkulator setelah beranda
        '/pengecekan': (context) => PengecekanPage(), // Halaman pengecekan setelah beranda
      },
    );
  }
}
