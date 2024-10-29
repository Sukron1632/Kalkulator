import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BerandaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String? userEmail = FirebaseAuth.instance.currentUser?.email;
    String username = userEmail != null ? userEmail.split('@')[0] : 'unknown user';

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Beranda'),
        shadowColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Selamat datang di AppaAja, $username',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    IconButton(
                      iconSize: 60,
                      onPressed: () {
                        Navigator.pushNamed(context, '/ourteam');
                      },
                      icon: const Icon(Icons.group),
                      color: Colors.black,
                    ),
                    const SizedBox(height: 8),
                    const Text('Our Team', style: TextStyle(fontSize: 16)),
                  ],
                ),
                const SizedBox(width: 60),
                Column(
                  children: [
                    IconButton(
                      iconSize: 60,
                      onPressed: () {
                        Navigator.pushNamed(context, '/stopwatch');
                      },
                      icon: const Icon(Icons.timer),
                      color: Colors.black,
                    ),
                    const SizedBox(height: 8),
                    const Text('Stopwatch', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            Column(
              children: [
                IconButton(
                  iconSize: 60,
                  onPressed: () {
                    Navigator.pushNamed(context, '/website');
                  },
                  icon: const Icon(Icons.app_shortcut_rounded),
                  color: Colors.black,
                ),
                const SizedBox(height: 8),
                const Text('Recommended Sites', style: TextStyle(fontSize: 16)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
