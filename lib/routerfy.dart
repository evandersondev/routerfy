import 'package:flutter/material.dart';
import 'package:path_to_regexp/path_to_regexp.dart';
import 'package:url_strategy/url_strategy.dart';

class Routerfy {
  static final Routerfy _instance = Routerfy._internal();
  Routerfy._internal() {
    // Remova o "#" da URL no Flutter Web ao inicializar o Routerfy
    setPathUrlStrategy();
  }

  static Routerfy get instance => _instance;

  final Map<String, Widget Function(BuildContext, RouterfyState)> _routeCache =
      {};
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Configura as rotas e cacheia caminhos
  void configureRoutes(BrowserRouter routes) {
    _routeCache.clear();
    _flattenRoutes(routes.children, "");
    print("Cached Routes: ${_routeCache.keys}");
  }

  void _flattenRoutes(List<RouterfyRoute> routes, String parentPath) {
    for (var route in routes) {
      final fullPath = "$parentPath${route.path}".replaceAll("//", "/");
      _routeCache[fullPath] = route.builder;
    }
  }

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final uri = Uri.parse(settings.name ?? "/");
    final path = uri.path;

    // Encontra rota correspondente
    for (var route in _routeCache.entries) {
      final parameters = <String>[];
      final regexp = pathToRegExp(route.key, parameters: parameters);
      final match = regexp.matchAsPrefix(path);

      if (match != null) {
        final params = extract(parameters, match);
        final state = RouterfyState(params, uri.queryParameters, settings);
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              route.value(context, state),
          settings: settings,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return child; // Sem animação
          },
        );
      }
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
  final Map<String, String> params;
  final Map<String, String> query;
  final RouteSettings settings;

  RouterfyState(this.params, this.query, this.settings);

  /// Retorna um parâmetro da rota pelo nome
  String? param(String key) => params[key];
}

class BrowserRouter {
  final List<RouterfyRoute> children;

  BrowserRouter({required this.children});
}

class RouterfyRoute {
  final String path;
  final Widget Function(BuildContext, RouterfyState) builder;

  RouterfyRoute({
    required this.path,
    required this.builder,
  });
}

class NavLink extends StatelessWidget {
  final String to;
  final Widget child;

  const NavLink({
    super.key,
    required this.to,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Routerfy.instance.push(to);
      },
      child: child,
    );
  }
}
