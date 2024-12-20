import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _login() async {
    String email = usernameController.text;
    String password = passwordController.text;

    final loadingDialog = showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Logging In"),
            ],
          ),
        );
      },
    );

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('email', email);

      Navigator.of(context).pop();
      Navigator.pushNamed(context, '/layout');
    } on FirebaseAuthException catch (e) {
      String message = 'Login Failed';

      if (e.code == 'user-not-found') {
        message = 'User not found';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password';
      }

      Navigator.of(context).pop();

      SnackBar snackBar = SnackBar(
          content: Text(
            message + ' : ' + e.code,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // showDialog(context: context, builder: (context) => AlertDialog(
      //   title: const Text('Login Failed'),
      //   content: Text(message),
      //   actions: [
      //     TextButton(onPressed: () => Navigator.pop(context),
      //     child: const Text('OK'),),
      //   ],
      // ));
    } 
    // finally {
    //   Navigator.of(context).pop();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: _page(),
      ),
    );
  }

  Widget _page() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon(),
            const SizedBox(height: 50),
            inputtext("Email", usernameController),
            const SizedBox(height: 10),
            inputtext("Password", passwordController, isPassword: true),
            const SizedBox(height: 30),
            loginBtn(),
            const SizedBox(height: 5),
            signUpBtn(),
          ],
        ),
      ),
    );
  }

  Widget icon() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Image.asset(
        'assets/images/appaaja.png',
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      ),
    );
    // return const CircleAvatar(
    //   radius: 50,
    //   backgroundImage: AssetImage('assets/images/appaaja.png'),
    // );
  }

  Widget inputtext(String hintText, TextEditingController controller,
      {bool isPassword = false}) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: Colors.black54),
    );

    return TextField(
      style: const TextStyle(color: Colors.black87),
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        enabledBorder: border,
        focusedBorder: border,
      ),
      obscureText: isPassword,
    );
  }

  Widget loginBtn() {
    return ElevatedButton(
      onPressed: () {
        _login();
        // // Verifikasi username dan password yang hardcode
        // if (usernameController.text == "admin" && passwordController.text == "123") {
        //   Navigator.pushNamed(context, '/beranda'); // Navigasi ke halaman kalkulator
        // } else {
        //   // Jika login gagal, tampilkan pesan kesalahan
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(content: Text("Login gagal! Username atau password salah.")),
        //   );
        // }
      },
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: const SizedBox(
        width: double.infinity,
        child: Text(
          "Log in",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  Widget signUpBtn() {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/signup');
      },
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        foregroundColor: Colors.black54,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: const SizedBox(
        width: double.infinity,
        child: Text(
          "Create account",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15),
        ),
      ),
    );
  }
}
