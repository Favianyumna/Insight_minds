import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart'; // WEEK6: init Hive
import 'core/features/onboarding/presentation/pages/splash_screen.dart';
import 'core/features/insightmind/data/local/screening_record.dart'; // gunakan model dari core/
import 'core/features/jadwal_kesehatan/data/local/schedule_item.dart';
import 'core/features/mood/data/local/mood_entry.dart';
import 'core/features/habit/data/local/habit_entry.dart';
import 'core/features/settings/data/local/settings_model.dart';
import 'core/features/auth/data/local/user_model.dart';
import 'package:intl/date_symbol_data_local.dart'; // Tambahkan import ini
import 'package:timezone/data/latest_all.dart' as tz;
import 'core/features/settings/domain/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();

  await Hive.initFlutter();

  // Registrasi adapter (synchronous, fast)
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(ScreeningRecordAdapter());
  }
  if (!Hive.isAdapterRegistered(7)) {
    Hive.registerAdapter(ScheduleItemAdapter());
  }
  if (!Hive.isAdapterRegistered(9)) {
    Hive.registerAdapter(MoodEntryAdapter());
  }
  if (!Hive.isAdapterRegistered(10)) {
    Hive.registerAdapter(HabitEntryAdapter());
  }
  if (!Hive.isAdapterRegistered(11)) {
    Hive.registerAdapter(SettingsModelAdapter());
  }
  if (!Hive.isAdapterRegistered(12)) {
    Hive.registerAdapter(UserModelAdapter());
  }

  await Future.wait([
    Hive.openBox<ScreeningRecord>('screening_record'),
    Hive.openBox<SettingsModel>('settings'),
    Hive.openBox<UserModel>('users'),
    Hive.openBox('auth_settings'),
    initializeDateFormatting('id', null),
  ]);

  runApp(const ProviderScope(child: SplashScreen()));

  NotificationService().initialize();
}
