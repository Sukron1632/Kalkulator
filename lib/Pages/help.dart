import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);

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
      body: Stack(
        children: [
          const SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 20),
                ExpansionTile(
                  title: Text(
                    'Panduan Menggunakan Stopwatch',
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                  ),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        '1. Waktu ditampilkan dalam format jam, menit, detik, dan milidetik.',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        '2. Tekan tombol "Start Timer" untuk memulai penghitungan waktu.',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        '3. Tekan tombol "Pause" untuk menghentikan sementara penghitungan waktu.',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        '4. Tekan tombol "Continue" untuk melanjutkan penghitungan waktu.',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        '5. Tekan tombol "Reset" untuk mengatur ulang waktu ke kondisi awal.',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                ExpansionTile(
                  title: Text(
                    'Panduan Penggunaan Kalkulator',
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                  ),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        '1. Tekan tombol AC untuk menghapus semua angka dan mengatur ulang kalkulator ke kondisi awal.',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        '2. Tekan tombol angka (0-9) untuk memasukkan angka yang ingin dihitung.',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        '3. Tombol Operasi:\n+: Menambahkan angka\n-: Mengurangi angka\nX: Mengalikan angka\n/: Membagi angka\n+/−: Mengubah tanda angka (positif/negatif)',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        '4. Setelah memasukkan angka dan memilih operasi, tekan tombol hasil (seperti "=") untuk melihat perhitungan.',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        '5. Contoh Penggunaan:\nUntuk menghitung 4 + 8: Tekan 4, lalu tombol +, tekan 8, dan terakhir tombol hasil.',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                ExpansionTile(
                  title: Text(
                    'Panduan Pengecekan Ganjil/Genap',
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                  ),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        '1. Klik tombol angka (0-9) untuk memasukkan angka yang ingin diperiksa.',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        '2. Menghapus Karakter:\nTombol <- berfungsi sebagai backspace untuk menghapus satu karakter.\nTombol C digunakan untuk mereset semua angka yang sudah dimasukkan.',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        '3. Klik tombol Cek Ganjil/Genap untuk melihat apakah angka yang dimasukkan merupakan angka ganjil atau genap.',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 100),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(10),
              child: Center(
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
            ),
          ),
        ],
      ),
    );
  }
}
