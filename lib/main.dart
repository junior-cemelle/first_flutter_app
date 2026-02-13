import 'package:dmsn2026/screens/dashboard_screen.dart';
import 'package:dmsn2026/screens/login_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
      routes: {
        "/dashboard": (context) =>  DashboardScreen(),
      },
    );
  }
}