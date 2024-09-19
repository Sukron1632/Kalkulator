import 'package:flutter/material.dart';

class OurTeam extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Our Team'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        shadowColor: Colors.black,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Posisikan widget di tengah vertikal
          crossAxisAlignment: CrossAxisAlignment.center, // Posisikan widget di tengah horizontal
          children: <Widget>[
            SizedBox(height: 20),
            SizedBox(
              width: 300,
              height: 100,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.blueGrey,
                      child: FlutterLogo(size: 40),
                    ),
                    SizedBox(width: 15), // Jarak antara avatar dan teks
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center, // Posisikan teks di tengah vertikal
                      crossAxisAlignment: CrossAxisAlignment.start, // Teks rata kiri
                      children: [
                        Text(
                          "Ammar Bayu Saputra",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "124220101",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20), // Jarak antar elemen
            SizedBox(
              width: 300,
              height: 100,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.blueGrey,
                      child: FlutterLogo(size: 40),
                    ),
                    SizedBox(width: 15), // Jarak antara avatar dan teks
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center, // Posisikan teks di tengah vertikal
                      crossAxisAlignment: CrossAxisAlignment.start, // Teks rata kiri
                      children: [
                        Text(
                          "Zola Dimas Firmansyah",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "124220106",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
