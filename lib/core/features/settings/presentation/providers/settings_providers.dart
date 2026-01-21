import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/local/settings_model.dart';
import '../../domain/services/notification_service.dart';

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsModel>((ref) {
  return SettingsNotifier();
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

class SettingsNotifier extends StateNotifier<SettingsModel> {
  SettingsNotifier() : super(SettingsModel.load());

  Future<void> save() async {
    await state.save();
    state = SettingsModel.load();
  }
}
