import 'package:flutter/material.dart';
import 'package:path_to_regexp/path_to_regexp.dart';
import 'package:url_strategy/url_strategy.dart';

class Routerfy {
  static final Routerfy _instance = Routerfy._internal();

  Routerfy._internal() {
    setPathUrlStrategy();
  }

  static Routerfy get instance => _instance;
  static Routerfy get I => _instance;

  final Map<String, Widget Function(BuildContext, RouterfyState)> routeCache =
      {};
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Configura as rotas e cacheia caminhos
  void configureRoutes(BrowserRouter routes) {
    routeCache.clear();
    _flattenRoutes(routes.children, "");
  }

  void _flattenRoutes(List<RouterfyRoute> routes, String parentPath) {
    for (var route in routes) {
      final fullPath = "$parentPath${route.path}".replaceAll("//", "/");
      routeCache[fullPath] = route.builder;

      if (route.children.isNotEmpty) {
        _flattenRoutes(route.children, fullPath);
      }
    }
  }

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final uri = Uri.parse(settings.name ?? "/");
    final path = uri.path;

    // Encontra rota correspondente
    for (var route in routeCache.entries) {
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
  final List<RouterfyRoute> children;

  RouterfyRoute({
    required this.path,
    required this.builder,
    this.children = const [],
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

class Outlet extends StatelessWidget {
  const Outlet({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = ModalRoute.of(context)?.settings;
    final uri = Uri.parse(settings?.name ?? "/");
    final path = uri.path;

    final parameters = <String>[];

    // print(path);
    // print(Routerfy.I.routeCache[path]);

    if (Routerfy.I.routeCache[path] != null) {
      // final regexp = pathToRegExp(route.key, parameters: parameters);
      // final match = regexp.matchAsPrefix(path);

      return Text('DENTRO');
    } else {
      return const SizedBox.shrink();
    }

    // Encontra a rota correspondente
    // for (var route in Routerfy.I.routeCache.entries) {

    //   if (match != null) {
    //   }

    // if (match != null && route.value.children.isNotEmpty) {
    // final subPath = path.replaceFirst(route.key, '').replaceAll('//', '/');

    // for (var subRoute in route.value.children) {
    //   final subRegexp = pathToRegExp(subRoute.path, parameters: parameters);
    //   final subMatch = subRegexp.matchAsPrefix(subPath);

    //   if (subMatch != null) {
    //     final params = extract(parameters, subMatch);
    //     final state = RouterfyState(params, uri.queryParameters, settings!);
    //     return subRoute.builder(context, state);
    //   }

    // }
    // }
    // }
  }
}
