/// Centralized validation functions for the InsightMind app
class Validators {
  Validators._(); // Private constructor to prevent instantiation

  /// Validates email format
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Format email tidak valid';
    }

    return null;
  }

  /// Validates password
  static String? validatePassword(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }

    if (value.length < minLength) {
      return 'Password minimal $minLength karakter';
    }

    return null;
  }

  /// Validates password confirmation
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }

    if (value != password) {
      return 'Password tidak cocok';
    }

    return null;
  }

  /// Validates full name
  static String? validateFullName(String? value, {int minLength = 3}) {
    if (value == null || value.isEmpty) {
      return 'Nama tidak boleh kosong';
    }

    if (value.trim().length < minLength) {
      return 'Nama minimal $minLength karakter';
    }

    return null;
  }

  /// Validates phone number (Indonesian format)
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Phone is optional
    }

    // Remove spaces and dashes
    final cleaned = value.replaceAll(RegExp(r'[\s-]'), '');

    // Check if it's a valid Indonesian phone number
    // Format: 08xxxxxxxxxx (10-13 digits starting with 08)
    final phoneRegex = RegExp(r'^08\d{8,11}$');

    if (!phoneRegex.hasMatch(cleaned)) {
      return 'Format nomor telepon tidak valid (contoh: 081234567890)';
    }

    return null;
  }

  /// Validates age
  static String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Age is optional
    }

    final age = int.tryParse(value);

    if (age == null) {
      return 'Usia harus berupa angka';
    }

    if (age < 1 || age > 150) {
      return 'Usia tidak valid (1-150)';
    }

    return null;
  }

  /// Validates required field
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    return null;
  }

  /// Validates minimum length
  static String? validateMinLength(
    String? value,
    int minLength,
    String fieldName,
  ) {
    if (value == null || value.isEmpty) {
      return '$fieldName tidak boleh kosong';
    }

    if (value.length < minLength) {
      return '$fieldName minimal $minLength karakter';
    }

    return null;
  }
}
