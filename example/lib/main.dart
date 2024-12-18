import 'package:example/pages/about_page.dart';
import 'package:example/pages/home_page.dart';
import 'package:example/pages/login_page.dart';
import 'package:example/pages/profile_page.dart';
import 'package:example/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:routerfy/routerfy.dart';

BrowserRoutes createBrowserRoutes() {
  return BrowserRoutes(
    children: [
      RouterfyRoute(
        path: '/',
        builder: (context, state) => HomePage(),
      ),
      RouterfyRoute(
        path: '/login',
        builder: (context, state) => LoginPage(),
      ),
      RouterfyRoute(
        path: '/settings',
        builder: (context, state) => SettingsPage(),
        children: [
          RouterfyRoute(
            path: '/profile',
            builder: (context, state) => ProfilePage(),
          ),
          RouterfyRoute(
            path: '/themes',
            builder: (context, state) => AboutPage(),
          ),
        ],
      ),
    ],
  );
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.routerfy(
      routes: createBrowserRoutes(),
    );
  }
}
