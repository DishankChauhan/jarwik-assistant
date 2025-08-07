import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
<<<<<<< HEAD
  // Brand Colors
  static const Color primaryColor = Color(0xFF6366F1); // Indigo
  static const Color secondaryColor = Color(0xFF8B5CF6); // Purple
  static const Color accentColor = Color(0xFF06B6D4); // Cyan

  // Neutral Colors
  static const Color backgroundColor = Color(0xFFFAFAFA);
  static const Color surfaceColor = Colors.white;
  static const Color darkBackgroundColor = Color(0xFF0F0F0F);
  static const Color darkSurfaceColor = Color(0xFF1A1A1A);

  // Status Colors
  static const Color successColor = Color(0xFF10B981);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color errorColor = Color(0xFFEF4444);

  // Text Colors
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color darkTextPrimary = Color(0xFFF9FAFB);
  static const Color darkTextSecondary = Color(0xFFD1D5DB);
=======
  // Jarwik Brand Colors - Black & White with Gold Accent
  static const Color primaryColor = Color(0xFF000000); // Pure Black
  static const Color secondaryColor = Color(0xFFFFFFFF); // Pure White
  static const Color accentColor = Color(0xFFFFD700); // Gold accent for premium feel

  // Neutral Colors - Black & White Theme
  static const Color backgroundColor = Color(0xFFFFFFFF); // White background
  static const Color surfaceColor = Color(0xFFFAFAFA); // Off-white surface
  static const Color darkBackgroundColor = Color(0xFF000000); // Pure black
  static const Color darkSurfaceColor = Color(0xFF111111); // Near black surface

  // Status Colors - Minimal palette
  static const Color successColor = Color(0xFF22C55E); // Green
  static const Color warningColor = Color(0xFFF59E0B); // Amber
  static const Color errorColor = Color(0xFFEF4444); // Red

  // Text Colors - High contrast
  static const Color textPrimary = Color(0xFF000000); // Black text on white
  static const Color textSecondary = Color(0xFF666666); // Dark gray
  static const Color darkTextPrimary = Color(0xFFFFFFFF); // White text on black
  static const Color darkTextSecondary = Color(0xFFCCCCCC); // Light gray
>>>>>>> 9b168b8 (pushed other files)

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
<<<<<<< HEAD
        secondary: secondaryColor,
        tertiary: accentColor,
        surface: surfaceColor,
        background: backgroundColor,
        error: errorColor,
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        displayMedium: GoogleFonts.inter(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        displaySmall: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        headlineLarge: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textPrimary,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textSecondary,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textSecondary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        filled: true,
        fillColor: surfaceColor,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceColor,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
=======
        secondary: accentColor,
        tertiary: accentColor,
        surface: surfaceColor,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: textPrimary,
>>>>>>> 9b168b8 (pushed other files)
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
<<<<<<< HEAD
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        surface: darkSurfaceColor,
        background: darkBackgroundColor,
        error: errorColor,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme)
          .copyWith(
            displayLarge: GoogleFonts.inter(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: darkTextPrimary,
            ),
            displayMedium: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: darkTextPrimary,
            ),
            displaySmall: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: darkTextPrimary,
            ),
            headlineLarge: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: darkTextPrimary,
            ),
            headlineMedium: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: darkTextPrimary,
            ),
            titleLarge: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: darkTextPrimary,
            ),
            bodyLarge: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: darkTextPrimary,
            ),
            bodyMedium: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: darkTextSecondary,
            ),
            bodySmall: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: darkTextSecondary,
            ),
          ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF374151)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        filled: true,
        fillColor: darkSurfaceColor,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        color: darkSurfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: darkSurfaceColor,
        foregroundColor: darkTextPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: darkTextPrimary,
        ),
=======
        primary: Colors.white,
        secondary: accentColor,
        tertiary: accentColor,
        surface: darkSurfaceColor,
        error: errorColor,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: darkTextPrimary,
>>>>>>> 9b168b8 (pushed other files)
      ),
    );
  }
}
