import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors - Sophisticated black and white with gold accent
  static const Color primaryColor = Color(0xFF000000); // Pure black
  static const Color backgroundColor = Color(0xFFFFFFFF); // Pure white
  static const Color surfaceColor = Color(0xFFF8F9FA); // Off white
  static const Color accentColor = Color(0xFFFFD700); // Gold accent

  // Dark Theme Colors
  static const Color darkBackgroundColor = Color(0xFF000000); // Pure black
  static const Color darkSurfaceColor = Color(0xFF0F0F0F); // Almost black

  // Supporting Colors
  static const Color successColor = Color(0xFF10B981); // Emerald
  static const Color warningColor = Color(0xFFF59E0B); // Amber
  static const Color errorColor = Color(0xFFEF4444); // Red

  // Text Colors - High contrast
  static const Color textPrimary = Color(0xFF000000); // Black text on white
  static const Color textSecondary = Color(0xFF666666); // Dark gray
  static const Color darkTextPrimary = Color(0xFFFFFFFF); // White text on black
  static const Color darkTextSecondary = Color(0xFFCCCCCC); // Light gray

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        tertiary: accentColor,
        surface: surfaceColor,
        background: backgroundColor,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: textPrimary,
        onBackground: textPrimary,
      ),
      textTheme: GoogleFonts.sourceCodeProTextTheme().copyWith(
        displayLarge: GoogleFonts.sourceCodePro(
          fontSize: 57,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.25,
          color: textPrimary,
        ),
        displayMedium: GoogleFonts.sourceCodePro(
          fontSize: 45,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
          color: textPrimary,
        ),
        displaySmall: GoogleFonts.sourceCodePro(
          fontSize: 36,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
          color: textPrimary,
        ),
        headlineLarge: GoogleFonts.sourceCodePro(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          color: textPrimary,
        ),
        headlineMedium: GoogleFonts.sourceCodePro(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          color: textPrimary,
        ),
        headlineSmall: GoogleFonts.sourceCodePro(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          color: textPrimary,
        ),
        titleLarge: GoogleFonts.sourceCodePro(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
          color: textPrimary,
        ),
        titleMedium: GoogleFonts.sourceCodePro(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
          color: textPrimary,
        ),
        titleSmall: GoogleFonts.sourceCodePro(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
          color: textPrimary,
        ),
        bodyLarge: GoogleFonts.sourceCodePro(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
          color: textPrimary,
        ),
        bodyMedium: GoogleFonts.sourceCodePro(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
          color: textPrimary,
        ),
        bodySmall: GoogleFonts.sourceCodePro(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
          color: textSecondary,
        ),
        labelLarge: GoogleFonts.sourceCodePro(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
          color: textPrimary,
        ),
        labelMedium: GoogleFonts.sourceCodePro(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: textSecondary,
        ),
        labelSmall: GoogleFonts.sourceCodePro(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: textSecondary,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor,
        foregroundColor: textPrimary,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        titleTextStyle: GoogleFonts.sourceCodePro(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.15,
          color: textPrimary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: primaryColor.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.sourceCodePro(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: Colors.white,
        secondary: accentColor,
        tertiary: accentColor,
        surface: darkSurfaceColor,
        background: darkBackgroundColor,
        error: errorColor,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: darkTextPrimary,
        onBackground: darkTextPrimary,
      ),
      textTheme: GoogleFonts.sourceCodeProTextTheme().copyWith(
        displayLarge: GoogleFonts.sourceCodePro(
          fontSize: 57,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.25,
          color: darkTextPrimary,
        ),
        displayMedium: GoogleFonts.sourceCodePro(
          fontSize: 45,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
          color: darkTextPrimary,
        ),
        displaySmall: GoogleFonts.sourceCodePro(
          fontSize: 36,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
          color: darkTextPrimary,
        ),
        headlineLarge: GoogleFonts.sourceCodePro(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          color: darkTextPrimary,
        ),
        headlineMedium: GoogleFonts.sourceCodePro(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          color: darkTextPrimary,
        ),
        headlineSmall: GoogleFonts.sourceCodePro(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          color: darkTextPrimary,
        ),
        titleLarge: GoogleFonts.sourceCodePro(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
          color: darkTextPrimary,
        ),
        titleMedium: GoogleFonts.sourceCodePro(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
          color: darkTextPrimary,
        ),
        titleSmall: GoogleFonts.sourceCodePro(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
          color: darkTextPrimary,
        ),
        bodyLarge: GoogleFonts.sourceCodePro(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
          color: darkTextPrimary,
        ),
        bodyMedium: GoogleFonts.sourceCodePro(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
          color: darkTextPrimary,
        ),
        bodySmall: GoogleFonts.sourceCodePro(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
          color: darkTextSecondary,
        ),
        labelLarge: GoogleFonts.sourceCodePro(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
          color: darkTextPrimary,
        ),
        labelMedium: GoogleFonts.sourceCodePro(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: darkTextSecondary,
        ),
        labelSmall: GoogleFonts.sourceCodePro(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: darkTextSecondary,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: darkBackgroundColor,
        foregroundColor: darkTextPrimary,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        titleTextStyle: GoogleFonts.sourceCodePro(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.15,
          color: darkTextPrimary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 2,
          shadowColor: Colors.white.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.sourceCodePro(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
