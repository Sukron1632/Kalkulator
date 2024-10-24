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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Selamat datang di AppaAja,',
              style: TextStyle(fontSize: 24),
            ),
            // const SizedBox(height: 1),
            Text(
              username ,
              style: const TextStyle(fontSize: 24, color: Color.fromARGB(255, 19, 80, 21)),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/ourteam'); 
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                child: const Text('Our Team', textAlign: TextAlign.center),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/stopwacth'); 
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                child: const Text('stopwacth'),
              ),
            ),
            // const SizedBox(height: 20),
            // SizedBox(
            //   width: 200,
            //   height: 60,
            //   child: ElevatedButton(
            //     onPressed: () {
            //       Navigator.pushNamed(context, '/testing');
            //     },
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.black,
            //       foregroundColor: Colors.white,
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(30),
            //       ),
            //       padding:
            //           const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            //     ),
            //     child: const Text('testing Page'),
            //   ),
            // ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/website');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                child: const Text('Recommended Sites'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
