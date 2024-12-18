import 'package:flutter/material.dart';
import 'package:routerfy/routerfy.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          spacing: 24,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('HOME'),
            TextButton(
                onPressed: () {
                  Routerfy.instance.push('/login');
                },
                child: Text('L O G I N')),
          ],
        ),
      ),
    );
  }
}
