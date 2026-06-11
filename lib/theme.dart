import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class YwcTheme {
  static const Color navy = Color(0xFF0B1F3A);
  static const Color navyLight = Color(0xFF132D52);
  static const Color teal = Color(0xFF0FA9A0);
  static const Color tealLight = Color(0xFF1EC9BF);
  static const Color gold = Color(0xFFC9A84C);
  static const Color surface = Color(0xFFF4F6F9);
  static const Color surface2 = Color(0xFFFFFFFF);
  static const Color text1 = Color(0xFF0B1F3A);
  static const Color text2 = Color(0xFF4A6278);
  static const Color text3 = Color(0xFF8BA0B4);
  static const Color borderColor = Color(0xFFDDE4ED);
  static const Color red = Color(0xFFE05252);
  static const Color green = Color(0xFF1EB87A);

  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: teal,
      primary: navy,
      surface: surface,
      surfaceContainerHighest: surface,
      onSurface: text1,
    ),
    scaffoldBackgroundColor: surface,
    appBarTheme: AppBarTheme(
      backgroundColor: navy,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surface2,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: teal,
      unselectedItemColor: text3,
      elevation: 0,
      landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.playfairDisplay(
        fontSize: 32,
        fontWeight: FontWeight.w400,
      ),
      headlineMedium: GoogleFonts.playfairDisplay(
        fontSize: 28,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: GoogleFonts.dmSans(fontSize: 22, fontWeight: FontWeight.w600),
      titleMedium: GoogleFonts.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w400),
      bodyMedium: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w400),
      bodySmall: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w400),
      labelLarge: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w500),
      labelMedium: GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w500),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: teal, width: 2),
      ),
      filled: true,
      fillColor: surface2,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  );
}
