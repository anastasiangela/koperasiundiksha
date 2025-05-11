import 'package:flutter/material.dart';
import 'login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Koperasi Undiksha',
      debugShowCheckedModeBanner: false,
      home: LoginPage(), // Harus LoginPage, bukan HomePage
    );
  }
}
