import 'package:flutter/material.dart';
import 'package:login/services/func.dart';

// DEBUG SCREEN

class Success extends StatefulWidget {
  const Success({super.key});

  @override
  State<Success> createState() => _SuccessState();
}

class _SuccessState extends State<Success> with Func {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Good Job'),
        backgroundColor: Colors.grey,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () async {
                String? id = await getUserIdLocally();
            
                print(id);
              },
              child: const Text('print userid'),
            ),
            TextButton(
                onPressed: () async {
                  // also need to set cache = 0
                  String? userId = await getUserIdLocally();
                  if (userId != null) {
                    forgetUser(userId);
                  }
                  deleteUserId();
                  Navigator.pushReplacementNamed(context, '/login'); 
                },
                child: const Text('Log Out'),
              ),
            // TextButton(onPressed: () async {
            //   String? userId = await getUserIdLocally();
            //       if (userId != null) {
            //         forgetUser(userId);
            //       }
            //       deleteUserId();

            // }, child: const Text('delete user')
            // ),
          ],
        ),
      ),
    );
  }
}
