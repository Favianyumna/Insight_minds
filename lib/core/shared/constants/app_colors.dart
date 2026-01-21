import 'package:flutter/material.dart';

/// Centralized color constants for the InsightMind app
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // Primary Colors
  static const Color primary = Color(0xFF6366F1); // indigo-500
  static const Color primaryDark = Color(0xFF4F46E5); // indigo-600
  static const Color primaryLight = Color(0xFF818CF8); // indigo-400
  static const Color primaryVeryLight = Color(0xFFC7D2FE); // indigo-200

  // Secondary Colors
  static const Color secondary = Color(0xFF3B82F6); // blue-500
  static const Color secondaryDark = Color(0xFF2563EB); // blue-600
  static const Color secondaryLight = Color(0xFF60A5FA); // blue-400

  // Status Colors
  static const Color success = Color(0xFF10B981); // green-500
  static const Color successLight = Color(0xFF34D399); // green-400
  static const Color error = Color(0xFFEF4444); // red-500
  static const Color errorLight = Color(0xFFF87171); // red-400
  static const Color warning = Color(0xFFF59E0B); // amber-500
  static const Color info = Color(0xFF3B82F6); // blue-500

  // Neutral Colors
  static const Color background = Color(0xFFF7F8FC);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surface = Colors.white;
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color card = Colors.white;
  static const Color cardDark = Color(0xFF2C2C2C);

  // Text Colors
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textPrimaryDark = Color(0xFFF9FAFB);
  static const Color textSecondaryDark = Color(0xFFD1D5DB);

  // Border Colors
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderDark = Color(0xFF374151);

  // Risk Level Colors
  static Color getRiskColor(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'tinggi':
      case 'high':
        return error;
      case 'sedang':
      case 'medium':
        return warning;
      case 'rendah':
      case 'low':
        return success;
      default:
        return textTertiary;
    }
  }

  // Mood Colors (1-10 scale)
  static Color getMoodColor(int rating) {
    if (rating >= 8) return success;
    if (rating >= 6) return successLight;
    if (rating >= 4) return warning;
    return error;
  }
}
