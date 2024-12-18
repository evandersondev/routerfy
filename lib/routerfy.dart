import 'package:flutter/material.dart';

class Routerfy {
  Routerfy._();

  static final Routerfy _instance = Routerfy._();
  static Routerfy get instance => _instance;

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  final Map<String, WidgetBuilder> _routeCache = {};

  // Inicializa as rotas e sub-rotas no mapa privado
  void configureRoutes(BrowserRoutes routes) {
    _routeCache.clear();
    _flattenRoutes(routes.children, "");
    print("Cached routes: ${_routeCache.keys}");
  }

  void _flattenRoutes(List<RouterfyRoute> routes, String parentPath) {
    for (var route in routes) {
      final fullPath = "$parentPath${route.path}".replaceAll("//", "/");
      _routeCache[fullPath] = route.builder;

      // Processa sub-rotas recursivamente
      if (route.children.isNotEmpty) {
        _flattenRoutes(route.children, fullPath);
      }
    }
  }

  // Push para navegar para uma rota com query params
  void push(String routeName, {Map<String, String>? queryParams}) {
    final uri = Uri(path: routeName, queryParameters: queryParams);
    navigatorKey.currentState?.pushNamed(uri.toString());
  }

  // Replace para substituir a rota atual
  void replace(String routeName, {Map<String, String>? queryParams}) {
    final uri = Uri(path: routeName, queryParameters: queryParams);
    navigatorKey.currentState?.pushReplacementNamed(uri.toString());
  }

  // onGenerateRoute - resolve a rota usando o mapa privado
  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final uri = Uri.parse(settings.name ?? "/");
    final path = uri.path;

    final builder = _routeCache[path];
    if (builder != null) {
      return MaterialPageRoute(
        builder: (context) => builder(context),
        settings: RouteSettings(
          name: settings.name,
          arguments: uri.queryParameters,
        ),
      );
    }

    // Rota não encontrada (404)
    return MaterialPageRoute(
      builder: (context) => const Scaffold(
        body: Center(child: Text("404 - Page not found")),
      ),
    );
  }
}

// Estrutura para definir rotas
class BrowserRoutes {
  final List<RouterfyRoute> children;

  BrowserRoutes({required this.children});
}

class RouterfyRoute {
  final String path;
  final WidgetBuilder builder;
  final List<RouterfyRoute> children;

  RouterfyRoute({
    required this.path,
    required this.builder,
    this.children = const [],
  });
}

// Provedor principal do Routerfy
class RouterfyProvider extends StatelessWidget {
  final BrowserRoutes routes;
  final Widget child;

  const RouterfyProvider({
    super.key,
    required this.routes,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    Routerfy.instance.configureRoutes(routes);

    return MaterialApp(
      navigatorKey: Routerfy.navigatorKey,
      onGenerateRoute: Routerfy.instance.onGenerateRoute,
      home: child,
    );
  }
}
