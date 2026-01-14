import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../local/user_model.dart';

class AuthRepository {
  static const String boxName = 'users';
  static const String currentUserKey = 'current_user_id';

  Future<Box<UserModel>> _openBox() async {
    if (!Hive.isAdapterRegistered(12)) {
      Hive.registerAdapter(UserModelAdapter());
    }
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<UserModel>(boxName);
    }
    return Hive.openBox<UserModel>(boxName);
  }

  Future<Box> _openSettingsBox() async {
    if (Hive.isBoxOpen('auth_settings')) {
      return Hive.box('auth_settings');
    }
    return Hive.openBox('auth_settings');
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
    final box = await _openBox();

    // Check if email already exists
    final existingUser = box.values.firstWhere(
      (user) => user.email.toLowerCase() == email.toLowerCase(),
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

    // Create new user
    final userId = const Uuid().v4();
    final newUser = UserModel(
      id: userId,
      email: email.toLowerCase(),
      password: password, // In production, hash this password
      fullName: fullName,
      phoneNumber: phoneNumber,
      age: age,
      gender: gender,
      createdAt: DateTime.now(),
      isEmailVerified: false,
    );

    await box.put(userId, newUser);
    return newUser;
  }

  /// Login user
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final box = await _openBox();

    // Find user by email
    final user = box.values.firstWhere(
      (u) => u.email.toLowerCase() == email.toLowerCase(),
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

    // Check password (in production, compare hashed passwords)
    if (user.password != password) {
      throw Exception('Password salah');
    }

    // Update last login
    user.lastLoginAt = DateTime.now();
    await box.put(user.id, user);

    // Save current user ID
    final settingsBox = await _openSettingsBox();
    await settingsBox.put(currentUserKey, user.id);

    return user;
  }

  /// Logout user
  Future<void> logout() async {
    final settingsBox = await _openSettingsBox();
    await settingsBox.delete(currentUserKey);
  }

  /// Get current logged in user
  Future<UserModel?> getCurrentUser() async {
    final settingsBox = await _openSettingsBox();
    final userId = settingsBox.get(currentUserKey);

    if (userId == null) {
      return null;
    }

    final box = await _openBox();
    return box.get(userId);
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final user = await getCurrentUser();
    return user != null;
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
    final box = await _openBox();
    final user = box.get(userId);

    if (user == null) {
      throw Exception('User tidak ditemukan');
    }

    if (fullName != null) user.fullName = fullName;
    if (phoneNumber != null) user.phoneNumber = phoneNumber;
    if (bio != null) user.bio = bio;
    if (age != null) user.age = age;
    if (gender != null) user.gender = gender;
    if (profileImagePath != null) user.profileImagePath = profileImagePath;

    await box.put(userId, user);
    return user;
  }

  /// Change password
  Future<void> changePassword({
    required String userId,
    required String oldPassword,
    required String newPassword,
  }) async {
    final box = await _openBox();
    final user = box.get(userId);

    if (user == null) {
      throw Exception('User tidak ditemukan');
    }

    if (user.password != oldPassword) {
      throw Exception('Password lama salah');
    }

    user.password = newPassword; // In production, hash this password
    await box.put(userId, user);
  }
}
