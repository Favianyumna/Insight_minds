/// Centralized route constants for the InsightMind app
class AppRoutes {
  AppRoutes._(); // Private constructor to prevent instantiation

  // Auth Routes
  static const String login = '/login';
  static const String register = '/register';
  static const String profile = '/profile';

  // Main Routes
  static const String home = '/home';
  static const String dashboard = '/dashboard';
  static const String screening = '/screening';
  static const String result = '/result';
  static const String history = '/history';
  static const String aiResult = '/ai-result';

  // Feature Routes
  static const String mood = '/mood';
  static const String moodScan = '/mood-scan';
  static const String habit = '/habit';
  static const String schedule = '/schedule';
  static const String riskDashboard = '/risk-dashboard';
  static const String analytics = '/analytics';
  static const String assessmentHistory = '/assessment-history';
  static const String moodCalendar = '/mood-calendar';
  static const String assessmentForm = '/assessment-form';

  // Settings Routes
  static const String profileSettings = '/profile-settings';
  static const String settings = '/settings';

  // Onboarding Routes
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
}
