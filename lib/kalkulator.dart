import 'package:flutter/material.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String text = '0';
  double numOne = 0;
  double numTwo = 0;
  String result = '';
  String finalResult = '0';
  String opr = '';
  String preOpr = '';
  bool isOperationDone = false;
  bool isEqualPressed = false;
  double storedResult = 0; // Menyimpan hasil operasi terakhir

  Widget calcButton(String btntxt, Color btncolor, Color txtcolor,
      {double fontSize = 35}) {
    return Container(
      child: ElevatedButton(
        onPressed: () {
          calculation(btntxt);
        },
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(20),
          backgroundColor: btncolor,
        ),
        child: Text(
          btntxt,
          style: TextStyle(
            fontSize: fontSize,
            color: txtcolor,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Calculator'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      text,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 100,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                calcButton('AC', Colors.grey, Colors.black),
                calcButton('+/-', Colors.grey, Colors.black),
                calcButton('%', Colors.grey, Colors.black),
                calcButton('/', Colors.amber[700]!, Colors.white),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                calcButton('7', Colors.grey[850]!, Colors.white),
                calcButton('8', Colors.grey[850]!, Colors.white),
                calcButton('9', Colors.grey[850]!, Colors.white),
                calcButton('x', Colors.amber[700]!, Colors.white),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                calcButton('4', Colors.grey[850]!, Colors.white),
                calcButton('5', Colors.grey[850]!, Colors.white),
                calcButton('6', Colors.grey[850]!, Colors.white),
                calcButton('-', Colors.amber[700]!, Colors.white),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                calcButton('1', Colors.grey[850]!, Colors.white),
                calcButton('2', Colors.grey[850]!, Colors.white),
                calcButton('3', Colors.grey[850]!, Colors.white),
                calcButton('+', Colors.amber[700]!, Colors.white),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                calcButton('0', Colors.grey[850]!, Colors.white, fontSize: 28),
                calcButton('<-', Colors.grey[850]!, Colors.white),
                calcButton('.', Colors.grey[850]!, Colors.white),
                calcButton('=', Colors.amber[700]!, Colors.white),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void calculation(String btnText) {
    if (btnText == 'AC') {
      // Reset kalkulator
      text = '0';
      numOne = 0;
      numTwo = 0;
      result = '';
      finalResult = '0';
      opr = '';
      preOpr = '';
      isOperationDone = false;
      isEqualPressed = false;
      storedResult = 0; // Reset hasil tersimpan ketika AC ditekan
    } else if (btnText == '<-') {
      if (result.isNotEmpty) {
        result = result.substring(0, result.length - 1);
        if (result.isEmpty) {
          result = '0';
        }
        finalResult = result;
      }
    } else if (btnText == '+' ||
        btnText == '-' ||
        btnText == 'x' ||
        btnText == '/' ||
        btnText == '=') {
      if (opr.isNotEmpty && !isOperationDone) {
        if (!isEqualPressed) {
          numTwo = double.tryParse(result) ?? 0;
        }
        if (opr == '+') {
          finalResult = add();
        } else if (opr == '-') {
          finalResult = sub();
        } else if (opr == 'x') {
          finalResult = mul();
        } else if (opr == '/') {
          finalResult = div();
        }
        numOne = double.parse(finalResult);
        storedResult = numOne; // Simpan hasil operasi di storedResult
        result = '';
        isOperationDone = true;
      } else if (opr.isEmpty) {
        numOne =
            storedResult != 0 ? storedResult : double.tryParse(result) ?? 0;
        result = '';
        isOperationDone = false;
      }

      if (btnText == '=') {
        text = finalResult;
        isEqualPressed = true; // Tandai bahwa = telah ditekan
      } else {
        opr = btnText;
        isEqualPressed = false; // Reset flag saat operator baru ditekan
        isOperationDone = false;
      }
    } else if (btnText == '%') {
      result = (numOne / 100).toString();
      finalResult = doesContainDecimal(result);
    } else if (btnText == '.') {
      if (!result.contains('.')) {
        result += '.';
      }
      finalResult = result;
    } else if (btnText == '+/-') {
      result.startsWith('-')
          ? result = result.substring(1)
          : result = '-$result';
      finalResult = result;
    } else {
      if (isEqualPressed) {
        // Jika "=" sudah ditekan, mulai dari hasil sebelumnya
        result = btnText;
        isEqualPressed = false; // Reset flag setelah angka baru dimasukkan
      } else {
        result += btnText;
      }
      finalResult = result;
    }

    setState(() {
      text = finalResult;
    });
  }

  String add() {
    result = (numOne + numTwo).toString();
    return doesContainDecimal(result);
  }

  String sub() {
    result = (numOne - numTwo).toString();
    return doesContainDecimal(result);
  }

  String mul() {
    result = (numOne * numTwo).toString();
    return doesContainDecimal(result);
  }

  String div() {
    result = (numOne / numTwo).toString();
    return doesContainDecimal(result);
  }

  String doesContainDecimal(dynamic result) {
    if (result.toString().contains('.')) {
      List<String> splitDecimal = result.toString().split('.');
      if (int.parse(splitDecimal[1]) == 0) {
        return splitDecimal[0];
      }
    }
    return result.toString();
  }
}
