import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class BerandaPage extends StatelessWidget {
  const BerandaPage({super.key});


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
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        shadowColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Warna tombol
                  foregroundColor: Colors.white, // Warna teks tombol
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Membuat tombol lebih simetris
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Padding yang simetris
                ),
                child: const Text('Buka Kalkulator'),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Warna tombol
                  foregroundColor: Colors.white, // Warna teks tombol
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Membuat tombol lebih simetris
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Padding yang simetris
                ),
                child: const Text('Pengecekan Ganjil Genap', textAlign: TextAlign.center,),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/ourteam'); // Navigasi ke halaman pengecekan
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Warna tombol
                  foregroundColor: Colors.white, // Warna teks tombol
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Membuat tombol lebih simetris
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Padding yang simetris
                ),
                child: const Text('Kelompok', textAlign: TextAlign.center,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
