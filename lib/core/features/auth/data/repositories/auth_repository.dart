import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../local/user_model.dart';

class AuthRepository {
  static const String boxName = 'users';
  static const String currentUserKey = 'current_user_id';

  /// Get users box (sudah dibuka di main.dart)
  Box<UserModel> _getBox() {
    if (!Hive.isBoxOpen(boxName)) {
      throw Exception('Users box belum diinisialisasi. Pastikan Hive.openBox("users") dipanggil di main()');
    }
    return Hive.box<UserModel>(boxName);
  }

  /// Get auth settings box (sudah dibuka di main.dart)
  Box _getSettingsBox() {
    if (!Hive.isBoxOpen('auth_settings')) {
      throw Exception('Auth settings box belum diinisialisasi. Pastikan Hive.openBox("auth_settings") dipanggil di main()');
    }
    return Hive.box('auth_settings');
  }

  /// Hash password menggunakan SHA256
  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  /// Register a new user
  Future<UserModel> register({
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
    int? age,
    String? gender,
  }) async {
    try {
      final box = _getBox();
      final emailLower = email.toLowerCase().trim();

      // Validasi input
      if (emailLower.isEmpty || password.isEmpty || fullName.isEmpty) {
        throw Exception('Email, password, dan nama lengkap wajib diisi');
      }

      if (password.length < 6) {
        throw Exception('Password minimal 6 karakter');
      }

      // Check if email already exists
      final existingUser = box.values.firstWhere(
        (user) => user.email.toLowerCase() == emailLower,
        orElse: () => UserModel(
          id: '',
          email: '',
          password: '',
          fullName: '',
          createdAt: DateTime.now(),
        ),
      );

      if (existingUser.id.isNotEmpty) {
        throw Exception('Email sudah terdaftar');
      }

      // Create new user dengan password yang di-hash
      final userId = const Uuid().v4();
      final newUser = UserModel(
        id: userId,
        email: emailLower,
        password: _hashPassword(password), // Hash password
        fullName: fullName.trim(),
        phoneNumber: phoneNumber?.trim(),
        age: age,
        gender: gender,
        createdAt: DateTime.now(),
        isEmailVerified: false,
      );

      await box.put(userId, newUser);

      // Save current user ID untuk auto-login setelah register
      final settingsBox = _getSettingsBox();
      await settingsBox.put(currentUserKey, userId);

      return newUser;
    } catch (e) {
      throw Exception('Pendaftaran gagal: $e');
    }
  }

  /// Login user
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final box = _getBox();
      final emailLower = email.toLowerCase().trim();

      // Validasi input
      if (emailLower.isEmpty || password.isEmpty) {
        throw Exception('Email dan password wajib diisi');
      }

      // Find user by email
      final user = box.values.firstWhere(
        (u) => u.email.toLowerCase() == emailLower,
        orElse: () => UserModel(
          id: '',
          email: '',
          password: '',
          fullName: '',
          createdAt: DateTime.now(),
        ),
      );

      if (user.id.isEmpty) {
        throw Exception('Email tidak ditemukan');
      }

      // Check password dengan hash
      if (user.password != _hashPassword(password)) {
        throw Exception('Password salah');
      }

      // Update last login
      user.lastLoginAt = DateTime.now();
      await box.put(user.id, user);

      // Save current user ID
      final settingsBox = _getSettingsBox();
      await settingsBox.put(currentUserKey, user.id);

      return user;
    } catch (e) {
      throw Exception('Login gagal: $e');
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      final settingsBox = _getSettingsBox();
      await settingsBox.delete(currentUserKey);
    } catch (e) {
      // Even if logout fails, don't throw error
      throw Exception('Logout gagal: $e');
    }
  }

  /// Get current logged in user
  Future<UserModel?> getCurrentUser() async {
    try {
      final settingsBox = _getSettingsBox();
      final userId = settingsBox.get(currentUserKey);

      if (userId == null) {
        return null;
      }

      final box = _getBox();
      return box.get(userId);
    } catch (e) {
      // Return null jika ada error
      return null;
    }
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    try {
      final user = await getCurrentUser();
      return user != null;
    } catch (e) {
      return false;
    }
  }

  /// Update user profile
  Future<UserModel> updateProfile({
    required String userId,
    String? fullName,
    String? phoneNumber,
    String? bio,
    int? age,
    String? gender,
    String? profileImagePath,
  }) async {
    try {
      final box = _getBox();
      final user = box.get(userId);

      if (user == null) {
        throw Exception('User tidak ditemukan');
      }

      if (fullName != null) user.fullName = fullName.trim();
      if (phoneNumber != null) user.phoneNumber = phoneNumber.trim();
      if (bio != null) user.bio = bio.trim();
      if (age != null) user.age = age;
      if (gender != null) user.gender = gender;
      if (profileImagePath != null) user.profileImagePath = profileImagePath.trim();

      await box.put(userId, user);
      return user;
    } catch (e) {
      throw Exception('Update profil gagal: $e');
    }
  }

  /// Change password
  Future<void> changePassword({
    required String userId,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final box = _getBox();
      final user = box.get(userId);

      if (user == null) {
        throw Exception('User tidak ditemukan');
      }

      if (newPassword.length < 6) {
        throw Exception('Password baru minimal 6 karakter');
      }

      // Compare dengan hashed password
      if (user.password != _hashPassword(oldPassword)) {
        throw Exception('Password lama salah');
      }

      user.password = _hashPassword(newPassword); // Hash password baru
      await box.put(userId, user);
    } catch (e) {
      throw Exception('Ganti password gagal: $e');
    }
  }
}
