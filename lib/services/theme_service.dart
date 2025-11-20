import 'package:flutter/material.dart';
import '../models/emotion.dart';

class EmotionTheme {
  final Color primary;
  final Color secondary;
  final Color accent;
  final Color background;
  final Color surface;
  final Color error;
  final Color onPrimary;
  final Color onSecondary;
  final Color onBackground;
  final Color onSurface;

  EmotionTheme({
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.background,
    required this.surface,
    required this.error,
    required this.onPrimary,
    required this.onSecondary,
    required this.onBackground,
    required this.onSurface,
  });

  static EmotionTheme fromEmotion(Emotion emotion, bool isDark) {
    switch (emotion) {
      case Emotion.happy:
        return EmotionTheme(
          primary: const Color(0xFFF59E0B), // Amber vibrante
          secondary: const Color(0xFFEAB308), // Yellow vibrante
          accent: const Color(0xFFEC4899), // Pink vibrante
          background: isDark
              ? const Color(0xFF1C1917)
              : const Color(0xFFFFFBEB), // Amber muy claro
          surface: isDark
              ? const Color(0xFF292524)
              : Colors.white,
          error: const Color(0xFFEF4444),
          onPrimary: Colors.white,
          onSecondary: const Color(0xFF1C1917),
          onBackground: isDark ? const Color(0xFFF5F5F4) : const Color(0xFF1C1917),
          onSurface: isDark ? const Color(0xFFF5F5F4) : const Color(0xFF292524),
        );

      case Emotion.calm:
        return EmotionTheme(
          primary: const Color(0xFFB5E5CF), // Verde menta pastel
          secondary: const Color(0xFFA8D8EA), // Azul cielo pastel
          accent: const Color(0xFFE0F2F1), // Verde agua pastel
          background: isDark
              ? const Color(0xFF1A1F1D)
              : const Color(0xFFF0FDF4), // Verde muy claro
          surface: isDark
              ? const Color(0xFF2A2F2D)
              : const Color(0xFFF5FFF7), // Verde menta muy claro
          error: const Color(0xFFFF6B6B),
          onPrimary: const Color(0xFF1A3A2E),
          onSecondary: const Color(0xFF1A3A2E),
          onBackground: isDark ? Colors.white : Colors.black87,
          onSurface: isDark ? Colors.white70 : Colors.black87,
        );

      case Emotion.confident:
        return EmotionTheme(
          primary: const Color(0xFFC4B5FD), // Lila pastel
          secondary: const Color(0xFFA78BFA), // Púrpura pastel
          accent: const Color(0xFFDDD6FE), // Lila muy claro
          background: isDark
              ? const Color(0xFF1E1B2E)
              : const Color(0xFFFAF5FF), // Lila muy claro
          surface: isDark
              ? const Color(0xFF2E2B3E)
              : const Color(0xFFF3E8FF), // Lila claro
          error: const Color(0xFFFF6B6B),
          onPrimary: const Color(0xFF2D1B4E),
          onSecondary: const Color(0xFF2D1B4E),
          onBackground: isDark ? Colors.white : Colors.black87,
          onSurface: isDark ? Colors.white70 : Colors.black87,
        );

      case Emotion.anxious:
        return EmotionTheme(
          primary: const Color(0xFFFFC5C5), // Rosa pastel suave
          secondary: const Color(0xFFFFD4B3), // Melocotón pastel
          accent: const Color(0xFFFFE0E0), // Rosa muy claro
          background: isDark
              ? const Color(0xFF1F1A1A)
              : const Color(0xFFFFF5F5), // Rosa muy claro
          surface: isDark
              ? const Color(0xFF2F2A2A)
              : const Color(0xFFFFEBEB), // Rosa claro
          error: const Color(0xFFFF5252),
          onPrimary: const Color(0xFF4A1E1E),
          onSecondary: const Color(0xFF4A1E1E),
          onBackground: isDark ? Colors.white : Colors.black87,
          onSurface: isDark ? Colors.white70 : Colors.black87,
        );

      case Emotion.energetic:
        return EmotionTheme(
          primary: const Color(0xFFFFD89B), // Naranja pastel
          secondary: const Color(0xFFFFB84D), // Naranja claro
          accent: const Color(0xFFFFE5B4), // Melocotón
          background: isDark
              ? const Color(0xFF1F1A0F)
              : const Color(0xFFFFF8E1), // Amarillo muy claro
          surface: isDark
              ? const Color(0xFF2F2A1F)
              : const Color(0xFFFFF4D6), // Amarillo claro
          error: const Color(0xFFFF6B6B),
          onPrimary: const Color(0xFF4A2E0E),
          onSecondary: const Color(0xFF4A2E0E),
          onBackground: isDark ? Colors.white : Colors.black87,
          onSurface: isDark ? Colors.white70 : Colors.black87,
        );

      case Emotion.insecure:
        return EmotionTheme(
          primary: const Color(0xFFD4C4FB), // Lila pastel suave
          secondary: const Color(0xFFC8B3F0), // Lila medio
          accent: const Color(0xFFE8DDFF), // Lila muy claro
          background: isDark
              ? const Color(0xFF1E1A26)
              : const Color(0xFFF5F0FF), // Lila muy claro
          surface: isDark
              ? const Color(0xFF2E2A36)
              : const Color(0xFFF0E8FF), // Lila claro
          error: const Color(0xFFFF6B6B),
          onPrimary: const Color(0xFF3A2E4A),
          onSecondary: const Color(0xFF3A2E4A),
          onBackground: isDark ? Colors.white : Colors.black87,
          onSurface: isDark ? Colors.white70 : Colors.black87,
        );

      case Emotion.robotic:
        return EmotionTheme(
          primary: const Color(0xFFE0E0E0), // Gris pastel
          secondary: const Color(0xFFBDBDBD), // Gris medio
          accent: const Color(0xFFF0F0F0), // Gris muy claro
          background: isDark
              ? const Color(0xFF1A1A1A)
              : const Color(0xFFFAFAFA), // Gris muy claro
          surface: isDark
              ? const Color(0xFF2A2A2A)
              : const Color(0xFFF5F5F5), // Gris claro
          error: const Color(0xFFFF6B6B),
          onPrimary: const Color(0xFF2A2A2A),
          onSecondary: const Color(0xFF2A2A2A),
          onBackground: isDark ? Colors.white : Colors.black87,
          onSurface: isDark ? Colors.white70 : Colors.black87,
        );

      case Emotion.neutral:
      default:
        return EmotionTheme(
          primary: const Color(0xFF6366F1), // Indigo vibrante
          secondary: const Color(0xFF8B5CF6), // Púrpura vibrante
          accent: const Color(0xFFEC4899), // Rosa vibrante
          background: isDark
              ? const Color(0xFF0F172A) // Slate oscuro
              : const Color(0xFFF8FAFC), // Slate muy claro
          surface: isDark
              ? const Color(0xFF1E293B) // Slate medio oscuro
              : Colors.white, // Blanco puro
          error: const Color(0xFFEF4444),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onBackground: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A),
          onSurface: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF1E293B),
        );
    }
  }

  ThemeData toThemeData(bool isDark) {
    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      colorScheme: ColorScheme(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: primary,
        onPrimary: onPrimary,
        secondary: secondary,
        onSecondary: onSecondary,
        error: error,
        onError: Colors.white,
        surface: surface,
        onSurface: onSurface,
        background: background,
        onBackground: onBackground,
      ),
      scaffoldBackgroundColor: background,
      cardColor: surface,
    );
  }
}

