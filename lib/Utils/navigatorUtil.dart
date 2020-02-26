import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import '../Router/router.dart';

class NavigatorUtil {
  static var router = Routes.configureRoutes();
  static navigateTo(
    BuildContext context,
    String path, {
    bool replace = false,
    bool clearStack = false,
    Duration transitionDuration = const Duration(milliseconds: 250),
    RouteTransitionsBuilder transitionBuilder,
    TransitionType transition = TransitionType.cupertino,
  }) {
    router.navigateTo(context, path,
        replace: replace,
        clearStack: clearStack,
        transitionDuration: transitionDuration,
        transitionBuilder: transitionBuilder,
        transition: transition);
  }
}
