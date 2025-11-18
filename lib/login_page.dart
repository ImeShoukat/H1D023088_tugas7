import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:h1d023088_tugas7/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _saveUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', _usernameController.text);
  }

  // --- WIDGET INPUT STYLE SPOTIFY ---
  Widget _buildInput(TextEditingController controller, String placeholder, bool isPassword) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white), // Teks yang diketik putih
      decoration: InputDecoration(
        hintText: placeholder,
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
    );
  }

  void _showJumpscare() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: const Text("ERROR", style: TextStyle(color: Colors.red)),
        content: Image.asset('assets/hantu.jpg', height: 200, fit: BoxFit.cover),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("CLOSE"))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background hitam pekat
      backgroundColor: const Color(0xFF121212),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // LOGO (Ikon Musik Besar)
            const Icon(Icons.music_note, size: 80, color: Colors.white),
            const SizedBox(height: 40),
            
            const Text(
              "Log in to continue.",
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),

            _buildInput(_usernameController, 'Email or Username', false),
            const SizedBox(height: 15),
            _buildInput(_passwordController, 'Password', true),
            
            const SizedBox(height: 40),

            // TOMBOL HIJAU BULAT
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_usernameController.text == 'admin' && _passwordController.text == 'admin') {
                    _saveUsername();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
                  } else {
                    _showJumpscare();
                  }
                },
                child: const Text('LOG IN'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}