import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:h1d023088_tugas7/home_page.dart';
import 'package:h1d023088_tugas7/login_page.dart'; 
import 'package:h1d023088_tugas7/me_page.dart';
import 'package:h1d023088_tugas7/music_page.dart';


class Sidemenu extends StatelessWidget {
  const Sidemenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF121212), // Background Drawer Hitam
      child: ListView(
        children: [
          const SizedBox(height: 40),
          // Profile Avatar Sederhana
          const Center(
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Color(0xFF282828),
              child: Icon(Icons.person, size: 40, color: Colors.white),
            ),
          ),
          const SizedBox(height: 10),
          const Center(
            child: Text("Admin User", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          const SizedBox(height: 40),

          // Menu Items
          _buildMenuItem(context, Icons.home_filled, 'Home', const HomePage()),
          _buildMenuItem(context, Icons.library_music, 'My Notes', const MePage()),
          _buildMenuItem(context, Icons.play_circle_fill, 'Music Player', const MusicPage()),
          
          const Divider(color: Colors.grey),
          
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.white),
            title: const Text('Log out', style: TextStyle(color: Colors.white)),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('username');
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginPage()), (r) => false);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String text, Widget page) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));
      },
    );
  }
}