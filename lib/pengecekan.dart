import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pengecekan Ganjil Genap',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PengecekanPage(),
    );
  }
}

class PengecekanPage extends StatefulWidget {
  @override
  _PengecekanPageState createState() => _PengecekanPageState();
}

class _PengecekanPageState extends State<PengecekanPage> {
  final TextEditingController _controller = TextEditingController();
  String _result = '';

  void _cekGanjilGenap() {
    final int? angka = int.tryParse(_controller.text);
    if (angka == null) {
      setState(() {
        _result = 'Masukkan angka yang valid';
      });
      return;
    }
    if (angka % 2 == 0) {
      setState(() {
        _result = 'Angka Genap';
      });
    } else {
      setState(() {
        _result = 'Angka Ganjil';
      });
    }
  }

  void _addNumber(String number) {
    setState(() {
      _controller.text += number;
    });
  }

  void _clear() {
    setState(() {
      _controller.clear();
      _result = '';
    });
  }

  void _deleteLastChar() {
    setState(() {
      _controller.text = _controller.text.isNotEmpty
          ? _controller.text.substring(0, _controller.text.length - 1)
          : '';
    });
  }

  Widget calcButton(String text, Color color, Color textColor, {double fontSize = 24}) {
    return ElevatedButton(
      onPressed: () {
        if (text == 'C') {
          _clear();
        } else if (text == '<-') {
          _deleteLastChar();
        } else {
          _addNumber(text);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: Size(80, 80), // Ukuran tombol
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Sudut tombol membulat
        ),
        padding: EdgeInsets.all(16), // Padding tombol
        textStyle: TextStyle(fontSize: fontSize), // Ukuran font
      ),
      child: Text(
        text,
        style: TextStyle(color: textColor, fontSize: fontSize),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengecekan Ganjil Genap'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Hasil pengecekan ditampilkan di atas TextField
            Text(
              _result,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: InputBorder.none, // Menghapus border
              ),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    calcButton('7', Colors.brown, Colors.white),
                    calcButton('8', Colors.brown, Colors.white),
                    calcButton('9', Colors.brown, Colors.white),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    calcButton('4', Colors.brown, Colors.white),
                    calcButton('5', Colors.brown, Colors.white),
                    calcButton('6', Colors.brown, Colors.white),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    calcButton('1', Colors.brown, Colors.white),
                    calcButton('2', Colors.brown, Colors.white),
                    calcButton('3', Colors.brown, Colors.white),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    calcButton('0', Colors.brown, Colors.white, fontSize: 28),
                    calcButton('<-', Colors.amber[700]!, Colors.white),
                    calcButton('C', Colors.amber[700]!, Colors.white),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _cekGanjilGenap,
              child: Text('Cek Ganjil/Genap'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: Size(double.infinity, 60),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
