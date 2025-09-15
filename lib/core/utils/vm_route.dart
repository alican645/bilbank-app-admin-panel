import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

GoRoute vmRoute<T extends ChangeNotifier>({
  required String path,
  String? name,
  List<RouteBase> routes = const [],
  required T Function(BuildContext, GoRouterState) create,
  required Widget Function(BuildContext, GoRouterState) child,
}) {
  return GoRoute(
    path: path,
    name: name,
    routes: routes,
    builder: (context, state) {
      return ChangeNotifierProvider<T>(
        create: (_) => create(context, state),
        child: Builder(builder: (ctx) => child(ctx, state)),
      );
    },
  );
}
