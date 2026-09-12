import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Central palette pulled from the Fruit Pal designs.
class AppColors {
  AppColors._();

  static const Color primaryRed = Color(0xFFFF3B47); // main CTA buttons
  static const Color lightRed = Color(0xFFFF6B6B); // scanner app bar / secondary red
  static const Color headingRed = Color(0xFFF03E3E); // serif headings
  static const Color pinkBg = Color(0xFFFDE7ED); // splash / soft section backgrounds
  static const Color paleRedCard = Color(0xFFFBE2E6); // input fields / cards
  static const Color paleGreenCard = Color(0xFFEAF6EC); // info cards
  static const Color darkGreen = Color(0xFF2F6B3C); // headings / accents
  static const Color mutedGreen = Color(0xFF4C8557); // "Good morning" text
  static const Color textDark = Color(0xFF1F2223);
  static const Color textGrey = Color(0xFF767676);
  static const Color divider = Color(0xFFECECEC);
}

class AppTextStyles {
  AppTextStyles._();

  /// Elegant serif used for big headings ("Create Account", "Good Morning", "Apple Tree"...)
  static TextStyle serifHeading({
    double size = 26,
    Color color = AppColors.headingRed,
    FontWeight weight = FontWeight.w700,
  }) =>
      GoogleFonts.playfairDisplay(
        fontSize: size,
        fontWeight: weight,
        color: color,
      );

  static TextStyle body({
    double size = 14,
    Color color = AppColors.textDark,
    FontWeight weight = FontWeight.normal,
  }) =>
      GoogleFonts.poppins(
        fontSize: size,
        fontWeight: weight,
        color: color,
      );
}

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: GoogleFonts.poppins().fontFamily,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryRed,
      primary: AppColors.primaryRed,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: IconThemeData(color: AppColors.textDark),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.primaryRed,
      selectionHandleColor: AppColors.primaryRed,
    ),
  );
}
