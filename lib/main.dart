import 'package:dmsn2026/listeners/value_listener.dart';
import 'package:dmsn2026/screens/dashboard_screen.dart';
import 'package:dmsn2026/screens/list_cast_screen.dart';
import 'package:dmsn2026/screens/login_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp()); 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ValueListener.isDarkMode,
      builder: (context, value, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const LoginScreen(), 
          routes: {
            "/dashboard": (context) => const DashboardScreen(), 
            "/cast": (context) => const ListCastScreen(),       
          },
          theme: value ? ThemeData.dark() : ThemeData.light(),
        );
      },
    );
  }
}
