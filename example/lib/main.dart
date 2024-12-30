import 'package:example/pages/home_page.dart';
import 'package:example/pages/login_page.dart';
import 'package:example/pages/product_details_page.dart';
import 'package:example/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:routerfy/routerfy.dart';

BrowserRouter createBrowserRouter() {
  return BrowserRouter(
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
        path: '/product',
        builder: (context, state) => SettingsPage(),
      ),
      RouterfyRoute(
        path: '/product/:id',
        builder: (context, state) {
          final id = state.params['id'] ?? '';

          return ProductDetailsPage(id: id);
        },
      ),
    ],
  );
}

void main() {
  final routes = createBrowserRouter();
  Routerfy.instance.configureRoutes(routes);

  runApp(MaterialApp(
    navigatorKey: Routerfy.instance.navigatorKey,
    onGenerateRoute: Routerfy.instance.onGenerateRoute,
    initialRoute: '/',
  ));
}
