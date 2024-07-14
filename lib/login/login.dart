import 'package:flutter/material.dart';
import 'package:login/services/func.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with Func {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool rememberMeValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.grey,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              userField(),
              passwordField(),
              rememberMe(),
              const Spacer(),
              submitButton(context),
              createUser(),
            ],
          ),
        ),
      ),
    );
  }

  TextButton createUser() {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/signup');
      },
      child: const Text(
        'Create User',
        style: TextStyle(color: Colors.blue),
      ),
    );
  }

  CheckboxListTile rememberMe() {
    return CheckboxListTile(
      value: rememberMeValue,
      onChanged: (bool? value) {
        setState(() {
          rememberMeValue = value!;
        });
      },
      title: const Text("Remember Me"),
    );
  }

  Padding passwordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: TextFormField(
        controller: passwordController,
        obscureText: true,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Password",
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your password';
          }
          return null;
        },
      ),
    );
  }

  Padding userField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: TextFormField(
        controller: userController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Username",
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your username';
          }
          return null;
        },
      ),
    );
  }
//Store user-id into local storage

  Padding submitButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Center(
        child: ElevatedButton(
          onPressed: () async {
            Map<String, dynamic> userArgs = await verifyUser(
                context, userController.text, passwordController.text);
            bool isVerified = userArgs['isVerified'] ?? false;

            if (_formKey.currentState!.validate() && isVerified) {
              storeUserIdLocally(userArgs['user-id'], rememberMeValue);
              rememberUser(userArgs['user-id'], rememberMeValue);
              // ignore: use_build_context_synchronously
              Navigator.pushReplacementNamed(context, '/loginSuccessful');
            } else {
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please fill input')),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
          ),
          child: const Text('Submit', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
