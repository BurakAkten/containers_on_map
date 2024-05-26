import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppSizes {}

class AppColors {
  static const Color border = Color(0xffE1E1E1);
  static const Color shadowGreen = Color(0xff72C875);
  static const Color shadowColor = Color.fromRGBO(0, 0, 0, 0.16);
  static const Color error = Color(0xffFC3131);
  static const Color darkBlue = Color(0xff172C49);
  static const Color yellow = Color(0xffE9CF30);
  static const Color darkGrey = Color(0xff535A72);
  static const Color light = Color(0xffFBFCFF);
  static const Color green = Color(0xff3BA935);
}

class AppFontUtils {
  static TextStyle get h4 => GoogleFonts.openSans().copyWith(
        fontWeight: FontWeight.w900,
        fontSize: 16,
        color: AppColors.darkGrey,
      );

  static TextStyle get h3 => GoogleFonts.openSans().copyWith(
        fontWeight: FontWeight.w800,
        fontSize: 20,
        color: AppColors.darkBlue,
      );

  static TextStyle get t2 => GoogleFonts.openSans().copyWith(
        fontWeight: FontWeight.normal,
        fontSize: 20,
        color: AppColors.darkGrey,
      );

  static TextStyle get buttonText => GoogleFonts.openSans().copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: AppColors.light,
      );

  static TextStyle get t1 => GoogleFonts.openSans().copyWith(
        fontWeight: FontWeight.normal,
        fontSize: 20,
        color: AppColors.darkGrey,
      );

  static TextStyle get inActiveInput => GoogleFonts.openSans().copyWith(
        fontWeight: FontWeight.normal,
        fontSize: 16,
        color: AppColors.shadowColor,
      );

  static TextStyle get filledInputLabel => GoogleFonts.openSans().copyWith(
        fontWeight: FontWeight.normal,
        fontSize: 12,
        color: AppColors.darkGrey,
      );

  static TextStyle get activeInputLabel => GoogleFonts.openSans().copyWith(
        fontWeight: FontWeight.normal,
        fontSize: 12,
        color: AppColors.yellow,
      );

  static TextStyle get errorInputLabel => GoogleFonts.openSans().copyWith(
        fontWeight: FontWeight.normal,
        fontSize: 12,
        color: AppColors.error,
      );
}

class AppRadius {
  static const double zero = 0;
  static const double small = 5;
  static const double medium = 8;
}

class AppIconSize {
  static const double small = 20;
  static const double medium = 26;
}

class AppSpacing {
  static const double spacingZero = 0;
  static const double spacingXxSmall = 5;
  static const double spacingXSmall = 8;
  static const double spacingSmall = 12;
  static const double spacingMedium = 16;
  static const double spacingLarge = 24;
  static const double spacingXLarge = 26;
  static const double spacingXxLarge = 32;
}

class AppDecorations {
  static const BoxDecoration gradientBox = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xffECECEC), Color(0xffFFFFFF)],
    ),
  );
}
