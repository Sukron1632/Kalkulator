import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal Logout: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Help'),
        shadowColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: <Widget>[
            const Text(
              'Panduan Menggunakan Stopwatch:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              '1. Waktu ditampilkan dalam format jam, menit, detik, dan milidetik.',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 10),
            const Text(
              '2. Tekan tombol "Start Timer" untuk memulai penghitungan waktu.',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 10),
            const Text(
              '3. Tekan tombol "Pause" untuk menghentikan sementara penghitungan waktu.',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 10),
            const Text(
              '4. Tekan tombol "Continue" untuk melanjutkan penghitungan waktu.',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 10),
            const Text(
              '5. Tekan tombol "Reset" untuk mengatur ulang waktu ke kondisi awal.',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 40),
            Center(
              child: SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    _signOut(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: const Text(
                    'Log Out',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
