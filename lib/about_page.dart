import 'package:flutter/material.dart';
import 'package:h1d023088_tugas7/sidemenu.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Page'),
      ),
      body: const Center(
        child: Text('Ini adalah halaman about'),
      ),
      drawer: const Sidemenu(),
    );
  }
}