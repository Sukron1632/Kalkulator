import 'package:flutter/material.dart';

class Calculator extends StatefulWidget {
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
  double storedResult = 0;

  Widget calcButton(String btntxt, Color btncolor, Color txtcolor,
      {double fontSize = 28}) {
    return SizedBox(
      width: 80,
      height: 80,
      child: ElevatedButton(
        onPressed: () {
          calculation(btntxt);
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(16),
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Kalkulator'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
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
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 40,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
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
                calcButton('7', Colors.brown, Colors.white),
                calcButton('8', Colors.brown, Colors.white),
                calcButton('9', Colors.brown, Colors.white),
                calcButton('x', Colors.amber[700]!, Colors.white),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                calcButton('4', Colors.brown, Colors.white),
                calcButton('5', Colors.brown, Colors.white),
                calcButton('6', Colors.brown, Colors.white),
                calcButton('-', Colors.amber[700]!, Colors.white),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                calcButton('1', Colors.brown, Colors.white),
                calcButton('2', Colors.brown, Colors.white),
                calcButton('3', Colors.brown, Colors.white),
                calcButton('+', Colors.amber[700]!, Colors.white),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                calcButton('0', Colors.brown, Colors.white, fontSize: 24),
                calcButton('.', Colors.brown, Colors.white),
                calcButton('<-', Colors.brown, Colors.white),
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
      text = '0';
      numOne = 0;
      numTwo = 0;
      result = '';
      finalResult = '0';
      opr = '';
      preOpr = '';
      isOperationDone = false;
      isEqualPressed = false;
      storedResult = 0;
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
        storedResult = numOne;
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
        isEqualPressed = true;
      } else {
        opr = btnText;
        isEqualPressed = false;
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
          : result = '-' + result;
      finalResult = result;
    } else {
      if (isEqualPressed) {
        result = btnText;
        isEqualPressed = false;
      } else {
        // Batasi panjang input menjadi 15 digit
        if (result.length < 15) {
          result += btnText;
        }
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
