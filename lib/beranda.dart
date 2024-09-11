import 'package:flutter/material.dart';

class BerandaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Menghilangkan tombol back di pojok kiri atas
        title: const Text('Beranda'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login'); // Navigasi ke halaman login
            },
            color: Colors.red, // Tombol logout berwarna merah
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Selamat datang di Beranda!',
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
                child: const Text('Buka Kalkulator'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue, // Warna tombol
                  onPrimary: Colors.white, // Warna teks tombol
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Membuat tombol lebih simetris
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/pengecekan'); // Navigasi ke halaman pengecekan
                },
                child: const Text('Pengecekan Ganjil Genap'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue, // Warna tombol
                  onPrimary: Colors.white, // Warna teks tombol
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Membuat tombol lebih simetris
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
