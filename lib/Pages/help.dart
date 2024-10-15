import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
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
        title: const Text('Help'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        shadowColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Petunjuk Penggunaan : ',
              style: TextStyle(fontSize: 24),
            ),
            const Text(
              '1. Tinggal Tap-Tap aja',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              height: 60,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                child: const Text('Log Out', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
