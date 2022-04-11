
import 'package:flutter/material.dart';

class NavigatorUtil {

  NavigatorUtil._();

  static Future<T?> push<T extends Object?>(BuildContext context, Widget page, { RouteSettings? settings }) {
    return Navigator.of(context).push(_createRoute(page, settings: settings));
  }

  static void pop<T>(BuildContext context, [ T? result ]) {
    Navigator.of(context).pop(result);
  }

  static bool canPop(BuildContext context) {
    return Navigator.of(context).canPop();
  }

  static Route<T> _createRoute<T>(Widget page, { RouteSettings? settings }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.linear;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

}