import 'package:flutter/material.dart';
import 'package:login/login/loading_page.dart';
import 'package:login/login/login_successful.dart';
import 'package:login/login/signup.dart';

import 'login/login.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  MainAppState createState() => MainAppState();
}

class MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color.fromARGB(255, 97, 97, 97),
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      routes: {
        '/landing': (context) => const LandingPage(),
        '/login': (context) => const Login(),
        '/signup': (context) => const SignUp(),
        '/loginSuccessful': (context) => const Success(),
      },
      initialRoute: '/landing',
      debugShowCheckedModeBanner: false,
    );
  }
}
