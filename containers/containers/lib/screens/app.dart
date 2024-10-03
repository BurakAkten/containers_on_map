import 'package:containers/base/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/navigation_util.dart';

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Containers',
      theme: ThemeData(
        colorScheme: const ColorScheme.light().copyWith(primary: AppColors.yellow),
        fontFamily: GoogleFonts.openSans().fontFamily,
        progressIndicatorTheme: const ProgressIndicatorThemeData(color: AppColors.green),
      ),
      navigatorKey: NavigationUtil.navigatorKey,
      debugShowCheckedModeBanner: true,
      initialRoute: NavigationUtil.authScreen,
      onGenerateRoute: NavigationUtil.onGenerateRoute,
    );
  }
}
