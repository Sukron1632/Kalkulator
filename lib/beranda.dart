import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class BerandaPage extends StatelessWidget {

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal Logout : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Beranda'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _signOut(context);
            },
            color: Colors.red,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Posisi tombol di tengah vertikal
          crossAxisAlignment: CrossAxisAlignment.center, // Posisi tombol di tengah horizontal
          children: <Widget>[
            const Text(
              'Selamat datang di Kalkulator',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/kalkulator'); // Navigasi ke halaman kalkulator
                },
                child: const Text('Buka Kalkulator', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Warna tombol
                  foregroundColor: Colors.white, // Warna teks tombol
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Membuat tombol lebih simetris
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Padding yang simetris
                ),
              ),
            ),
            const SizedBox(height: 20), // Jarak antar tombol
            SizedBox(
              width: 200,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/pengecekan'); // Navigasi ke halaman pengecekan
                },
                child: const Text('Pengecekan Ganjil Genap', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Warna tombol
                  foregroundColor: Colors.white, // Warna teks tombol
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Membuat tombol lebih simetris
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Padding yang simetris
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
