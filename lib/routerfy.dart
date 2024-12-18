import 'package:flutter/material.dart';

/// Classe principal do Routerfy
class Routerfy {
  static final Routerfy _instance = Routerfy._internal();
  Routerfy._internal();

  static Routerfy get instance => _instance;

  final Map<String, Widget Function(BuildContext, RouterfyState)> _routeCache =
      {};
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Configura as rotas e cacheia caminhos
  void configureRoutes(BrowserRoutes routes) {
    _routeCache.clear();
    _flattenRoutes(routes.children, "");
    print("Cached Routes: ${_routeCache.keys}");
  }

  void _flattenRoutes(List<RouterfyRoute> routes, String parentPath) {
    for (var route in routes) {
      final fullPath = "$parentPath${route.path}".replaceAll("//", "/");
      _routeCache[fullPath] = route.builder;

      if (route.children.isNotEmpty) {
        _flattenRoutes(route.children, fullPath);
      }
    }
  }

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final uri = Uri.parse(settings.name ?? "/");
    final path = uri.path;

    // Encontra rota correspondente
    final builder = _routeCache[path];
    if (builder != null) {
      return MaterialPageRoute(
        builder: (context) =>
            builder(context, RouterfyState(uri.queryParameters, settings)),
        settings: settings,
      );
    }

    // Página 404
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(child: Text("404 - Page Not Found")),
      ),
    );
  }

  void push(String routeName, {Map<String, String>? queryParams}) {
    final uri = Uri(path: routeName, queryParameters: queryParams);
    navigatorKey.currentState?.pushNamed(uri.toString());
  }

  void replace(String routeName, {Map<String, String>? queryParams}) {
    final uri = Uri(path: routeName, queryParameters: queryParams);
    navigatorKey.currentState?.pushReplacementNamed(uri.toString());
  }
}

class RouterfyState {
  final Map<String, String> query;
  final RouteSettings settings;

  RouterfyState(this.query, this.settings);

  /// Retorna um parâmetro da rota pelo nome
  String? param(String key) => settings.arguments != null
      ? (settings.arguments as Map<String, String>?)![key]
      : null;
}

class BrowserRoutes {
  final List<RouterfyRoute> children;

  BrowserRoutes({required this.children});
}

class RouterfyRoute {
  final String path;
  final Widget Function(BuildContext, RouterfyState) builder;
  final List<RouterfyRoute> children;

  RouterfyRoute({
    required this.path,
    required this.builder,
    this.children = const [],
  });
}

/// Extensão para MaterialApp
extension RouterfyMaterialApp on MaterialApp {
  static Widget testando({required BrowserRoutes routes}) {
    Routerfy.instance.configureRoutes(routes);

    return MaterialApp(
      navigatorKey: Routerfy.instance.navigatorKey,
      onGenerateRoute: Routerfy.instance.onGenerateRoute,
    );
  }
}
