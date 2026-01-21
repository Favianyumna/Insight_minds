import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/local/user_model.dart';

/// Simple user model used for UI scaffolding.
class AppUser {
  final String? profileImagePath;
  final String? fullName;
  final String? email;
  final String? id;

  const AppUser({this.profileImagePath, this.fullName, this.email, this.id});

  factory AppUser.fromUserModel(UserModel user) {
    return AppUser(
      id: user.id,
      fullName: user.fullName,
      email: user.email,
      profileImagePath: user.profileImagePath,
    );
  }
}

/// Auth repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

/// Basic auth state notifier connected to AuthRepository
class AuthState extends StateNotifier<AppUser?> {
  final AuthRepository _authRepository;

  AuthState(this._authRepository) : super(null) {
    _loadCurrentUser();
  }

  /// Load current user from repository
  Future<void> _loadCurrentUser() async {
    try {
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        state = AppUser.fromUserModel(user);
      }
    } catch (e) {
      // User not logged in or error loading
      state = null;
    }
  }

  /// Login using AuthRepository
  Future<void> login({required String email, required String password}) async {
    try {
      final user = await _authRepository.login(
        email: email,
        password: password,
      );
      state = AppUser.fromUserModel(user);
    } catch (e) {
      rethrow;
    }
  }

  /// Register using AuthRepository
  Future<void> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final user = await _authRepository.register(
        email: email,
        password: password,
        fullName: fullName,
      );
      state = AppUser.fromUserModel(user);
    } catch (e) {
      rethrow;
    }
  }

  /// Logout using AuthRepository
  Future<void> logout() async {
    try {
      await _authRepository.logout();
      state = null;
    } catch (e) {
      // Even if logout fails, clear local state
      state = null;
    }
  }

  /// Update profile using AuthRepository
  Future<void> updateProfile({
    String? fullName,
    String? profileImagePath,
  }) async {
    if (state == null || state!.id == null) {
      throw Exception('User tidak login');
    }

    try {
      final updatedUser = await _authRepository.updateProfile(
        userId: state!.id!,
        fullName: fullName,
        profileImagePath: profileImagePath,
      );
      state = AppUser.fromUserModel(updatedUser);
    } catch (e) {
      rethrow;
    }
  }
}

/// Provider exposing the current (logged-in) user state via StateNotifier.
final currentUserProvider = StateNotifierProvider<AuthState, AppUser?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthState(authRepository);
});
