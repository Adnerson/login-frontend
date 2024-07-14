import 'dart:async';
import 'package:flutter/material.dart';
import 'package:login/services/func.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with Func {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    int loggedin = 0;
    await Future.delayed(
      const Duration(seconds: 0),
      () async {
        String? userId = await getUserIdLocally();

        if (userId != null) {
          loggedin = await getLoginStatus(userId, context);
        }
      },
    );
    // ignore: use_build_context_synchronously
    switch (loggedin) {
      case 1:
        Navigator.pushReplacementNamed(context, '/loginSuccessful');
        break;
      default:
        Navigator.pushReplacementNamed(context, '/login');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
