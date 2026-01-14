import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/local/user_model.dart';

/// Provider for AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

/// Provider for current user state
final currentUserProvider = StateNotifierProvider<CurrentUserNotifier, UserModel?>((ref) {
  return CurrentUserNotifier(ref.read(authRepositoryProvider));
});

class CurrentUserNotifier extends StateNotifier<UserModel?> {
  final AuthRepository _repository;

  CurrentUserNotifier(this._repository) : super(null) {
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final user = await _repository.getCurrentUser();
    state = user;
  }

  Future<void> login(String email, String password) async {
    try {
      final user = await _repository.login(email: email, password: password);
      state = user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
    int? age,
    String? gender,
  }) async {
    try {
      await _repository.register(
        email: email,
        password: password,
        fullName: fullName,
        phoneNumber: phoneNumber,
        age: age,
        gender: gender,
      );
      // Auto login after registration
      await login(email, password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = null;
  }

  Future<void> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? bio,
    int? age,
    String? gender,
    String? profileImagePath,
  }) async {
    if (state == null) return;

    try {
      final updatedUser = await _repository.updateProfile(
        userId: state!.id,
        fullName: fullName,
        phoneNumber: phoneNumber,
        bio: bio,
        age: age,
        gender: gender,
        profileImagePath: profileImagePath,
      );
      state = updatedUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> refreshUser() async {
    await _loadCurrentUser();
  }
}

/// Provider to check if user is logged in
final isLoggedInProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user != null;
});
