import 'package:flutter/material.dart';

class MathPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Math'),
        shadowColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0), 
                  child: IconButton(
                    iconSize: 70,
                    onPressed: () {
                      Navigator.pushNamed(context, '/kalkulator');
                    },
                    icon: const Icon(Icons.calculate),
                    color: Colors.black,
                  ),
                ),
                const Text(
                  'Kalkulator',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 20), 
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0), 
                  child: IconButton(
                    iconSize: 70,
                    onPressed: () {
                      Navigator.pushNamed(context, '/pengecekan');
                    },
                    icon: const Icon(Icons.free_cancellation),
                    color: Colors.black,
                  ),
                ),
                const Text(
                  'Pengecekan Ganjil Genap',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
