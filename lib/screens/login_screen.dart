import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final txtUsername = TextFormField(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
    );

    final txtPwd = TextFormField(
      obscureText: true,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
    );

    final btnLogin = InkWell(
      onTap: () {
        setState(() {
          isLoading = true;
        });
        Future.delayed(const Duration(milliseconds: 3000)).then((_) {
          if (mounted) {
            Navigator.pushNamed(context, "/dashboard");
            setState(() {
              isLoading = false; 
            });
          }
        });
      },
      child: Lottie.asset(
        'assets/getstarted.json',
        height: 100,
        fit: BoxFit.contain,
      ),
    );

    final imgLoading = isLoading
        ? Positioned(
            child: Lottie.asset('assets/loading.json', height: 200),
          )
        : const SizedBox.shrink(); // FIX: SizedBox.shrink() es más eficiente que Container()

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/wallpaper.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Positioned(
              top: 200,
              child: SizedBox(
                width: 300,
                child: Text(
                  "Amongus",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontFamily: 'minecraft_fot_esp',
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 140,
              child: Container(
                width: 400,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    txtUsername,
                    const SizedBox(height: 16),
                    txtPwd,
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              child: btnLogin, // FIX: el Positioned está aquí, no duplicado dentro
            ),
            imgLoading,
          ],
        ),
      ),
    );
  }
}
