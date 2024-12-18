import 'package:flutter/material.dart';
import 'package:routerfy/routerfy.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          spacing: 24,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('LOGIN'),
            TextButton(
              onPressed: () {
                Routerfy.instance.push('/');
              },
              child: Text('H O M E'),
            ),
          ],
        ),
      ),
    );
  }
}
