import 'package:containers/screens/login/auth_screen.dart';
import 'package:containers/screens/operation/containers_screen.dart';
import 'package:flutter/material.dart';

class NavigationUtil {
  static final navigatorKey = GlobalKey<NavigatorState>();

  //Screens
  static const String authScreen = "authScreen";
  static const String operationScreen = "operationScreen";

  static _navigateToPageAndRemoveUntil(context, String pageName, {Object? arguments}) =>
      Navigator.pushNamedAndRemoveUntil(context, pageName, (Route<dynamic> route) => false, arguments: arguments);

  static navigateToBack(context, {dynamic value}) => Navigator.pop(context, value);

  //Navigate screens methods
  static navigateToLoginScreen(context) => _navigateToPageAndRemoveUntil(context, authScreen);
  static navigateToOperationScreen(context) => _navigateToPageAndRemoveUntil(context, operationScreen);

  static Route onGenerateRoute(settings) =>
      MaterialPageRoute(builder: (context) => _buildNavigationMap(context, settings), settings: RouteSettings(name: settings.name));

  static _buildNavigationMap(context, settings) {
    switch (settings.name) {
      case authScreen:
        return const AuthScreen();
      case operationScreen:
        return const ContainersScreen();
    }
  }
}
