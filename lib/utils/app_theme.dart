import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Light Theme Colors
  static const Color lightPrimaryColor = Color(0xFF6366F1); // Indigo
  static const Color lightSecondaryColor = Color(0xFF8B5CF6); // Purple
  static const Color lightAccentColor = Color(0xFF10B981); // Emerald
  static const Color lightBackgroundColor = Color(0xFFF8FAFC); // Slate 50
  static const Color lightSurfaceColor = Color(0xFFFFFFFF); // White
  static const Color lightTextPrimaryColor = Color(0xFF1E293B); // Slate 800
  static const Color lightTextSecondaryColor = Color(0xFF64748B); // Slate 500
  static const Color lightBorderColor = Color(0xFFE2E8F0); // Slate 200

  // Dark Theme Colors
  static const Color darkPrimaryColor = Color(0xFF6366F1); // Indigo
  static const Color darkSecondaryColor = Color(0xFF8B5CF6); // Purple
  static const Color darkAccentColor = Color(0xFF10B981); // Emerald
  static const Color darkBackgroundColor = Color(0xFF0F172A); // Slate 900
  static const Color darkSurfaceColor = Color(0xFF1E293B); // Slate 800
  static const Color darkTextPrimaryColor = Color(0xFFF1F5F9); // Slate 100
  static const Color darkTextSecondaryColor = Color(0xFF94A3B8); // Slate 400
  static const Color darkBorderColor = Color(0xFF334155); // Slate 700

  static const Color errorColor = Color(0xFFEF4444); // Red 500

  // Gradients
  static const LinearGradient lightPrimaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [lightPrimaryColor, lightSecondaryColor],
  );

  static const LinearGradient darkPrimaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [darkPrimaryColor, darkSecondaryColor],
  );

  static const LinearGradient lightBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFF1F5F9), Color(0xFFE2E8F0)], // Slate 100 to 200
  );

  static const LinearGradient darkBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0F172A), Color(0xFF1E293B)], // Slate 900 to 800
  );

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      textTheme: GoogleFonts.poppinsTextTheme(),
      fontFamily: GoogleFonts.poppins().fontFamily,
      useMaterial3: true,
      brightness: Brightness.light,
      primarySwatch: createMaterialColor(lightPrimaryColor),
      primaryColor: lightPrimaryColor,
      scaffoldBackgroundColor: lightBackgroundColor,
      colorScheme: const ColorScheme.light(
        primary: lightPrimaryColor,
        secondary: lightSecondaryColor,
        surface: lightSurfaceColor,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: lightTextPrimaryColor,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: lightTextPrimaryColor,
        ),
        iconTheme: IconThemeData(color: lightTextPrimaryColor),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightPrimaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: lightPrimaryColor.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSurfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: lightBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: lightBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: lightPrimaryColor, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      textTheme: GoogleFonts.poppinsTextTheme(),
      fontFamily: GoogleFonts.poppins().fontFamily,
      brightness: Brightness.dark,
      primarySwatch: createMaterialColor(darkPrimaryColor),
      primaryColor: darkPrimaryColor,
      scaffoldBackgroundColor: darkBackgroundColor,
      colorScheme: const ColorScheme.dark(
        primary: darkPrimaryColor,
        secondary: darkSecondaryColor,
        surface: darkSurfaceColor,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: darkTextPrimaryColor,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: darkTextPrimaryColor,
        ),
        iconTheme: IconThemeData(color: darkTextPrimaryColor),
      ),
      cardTheme: CardThemeData(
        color: darkSurfaceColor,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkPrimaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: darkPrimaryColor.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkPrimaryColor, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  // Helper method to create MaterialColor
  static MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }

  // Current theme colors (dynamic based on theme mode)
  static Color getPrimaryColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightPrimaryColor
        : darkPrimaryColor;
  }

  static Color getTextPrimaryColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightTextPrimaryColor
        : darkTextPrimaryColor;
  }

  static Color getTextSecondaryColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightTextSecondaryColor
        : darkTextSecondaryColor;
  }

  static LinearGradient getPrimaryGradient(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightPrimaryGradient
        : darkPrimaryGradient;
  }

  static LinearGradient getBackgroundGradient(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightBackgroundGradient
        : darkBackgroundGradient;
  }
}