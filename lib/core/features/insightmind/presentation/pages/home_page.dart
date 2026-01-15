// ignore_for_file: duplicate_import

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insightmind_app/core/features/auth/presentation/pages/login_page.dart';
import 'package:insightmind_app/core/features/auth/presentation/pages/register_page.dart';
import '../providers/score_provider.dart';
import 'history_page.dart';
import '../../../jadwal_kesehatan/presentation/pages/schedule_calendar_page.dart';
import '../../../mood/presentation/pages/mood_page.dart';
import '../../../habit/presentation/pages/habit_page.dart';
import '../../../risk_analysis/presentation/pages/risk_dashboard_page.dart';
import '../../../risk_analysis/presentation/pages/analytics_page.dart';
import 'screening_page.dart';
import '../../../risk_analysis/presentation/pages/assessment_history_page.dart';
import '../../../risk_analysis/presentation/pages/mood_calendar_page.dart';
import '../../../settings/presentation/pages/profile_settings_page.dart';
import '../../../auth/presentation/pages/profile_page.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../risk_analysis/presentation/pages/assistant_bot_page.dart';
import '../../../psychology/presentation/pages/psychology_page.dart';
import '../../../../shared/widgets/ai_bot_button.dart';
import 'ai_result_page.dart';
import '../../data/models/feature_vector.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final answers = ref.watch(answersProvider);
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('InsightMind'),
        actions: [
          const AiBotButton(),
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Riwayat Screening',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HistoryPage()),
              );
            },
          )
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(color: Colors.indigo),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor:
                            const Color(0xFFFFFFFF).withValues(alpha: 0.15),
                        child: user?.profileImagePath != null
                            ? ClipOval(
                                child: Image.network(
                                  user!.profileImagePath!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                ),
                              )
                            : const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 32,
                              ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        user?.fullName ?? 'InsightMind Menu',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (user?.email != null)
                        Text(
                          user!.email!,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              // Profile link
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profil Saya'),
                onTap: () {
                  Navigator.pop(context);
                  if (user == null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfilePage()),
                    );
                  }
                },
              ),
              if (user == null)
                ListTile(
                  leading: const Icon(Icons.login),
                  title: const Text('Masuk / Daftar'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                  },
                )
              else
                Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Logout'),
                      onTap: () async {
                        Navigator.pop(context);
                        await ref.read(currentUserProvider.notifier).logout();
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Anda telah logout')));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.support_agent),
                      title: const Text('Asisten'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AssistantBotPage()),
                        );
                      },
                    ),
                  ],
                ),
              const Divider(),
              // Tracking & Monitoring
              ListTile(
                leading: const Icon(Icons.mood),
                title: const Text('Mood & Jurnal Emosi'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MoodPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.check_circle_outline),
                title: const Text('Habit Tracker'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HabitPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_month),
                title: const Text('Jadwal Kesehatan'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ScheduleCalendarPage()),
                  );
                },
              ),
              const Divider(),
              // Analysis & History
              ListTile(
                leading: const Icon(Icons.analytics),
                title: const Text('Risk Analysis'),
                trailing: user == null ? const Icon(Icons.lock) : null,
                onTap: () {
                  Navigator.pop(context);
                  if (user == null) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Autentikasi Diperlukan'),
                        content: const Text('Fitur ini membutuhkan akun. Silakan daftar atau masuk.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPage()));
                            },
                            child: const Text('Daftar'),
                          ),
                          FilledButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage()));
                            },
                            child: const Text('Masuk'),
                          ),
                        ],
                      ),
                    );
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const RiskDashboardPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.assignment),
                title: const Text('Assessment History'),
                trailing: user == null ? const Icon(Icons.lock) : null,
                onTap: () {
                  Navigator.pop(context);
                  if (user == null) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Autentikasi Diperlukan'),
                        content: const Text('Fitur ini membutuhkan akun. Silakan daftar atau masuk.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPage()));
                            },
                            child: const Text('Daftar'),
                          ),
                          FilledButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage()));
                            },
                            child: const Text('Masuk'),
                          ),
                        ],
                      ),
                    );
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const AssessmentHistoryPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Mood & Risk Calendar'),
                trailing: user == null ? const Icon(Icons.lock) : null,
                onTap: () {
                  Navigator.pop(context);
                  if (user == null) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Autentikasi Diperlukan'),
                        content: const Text('Fitur ini membutuhkan akun. Silakan daftar atau masuk.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPage()));
                            },
                            child: const Text('Daftar'),
                          ),
                          FilledButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage()));
                            },
                            child: const Text('Masuk'),
                          ),
                        ],
                      ),
                    );
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MoodCalendarPage()),
                  );
                },
              ),
              const Divider(),
              // Psychology & Mental Health
              ListTile(
                leading: const Icon(Icons.psychology),
                title: const Text('Psikologi & Kesehatan Mental'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PsychologyPage()),
                  );
                },
              ),
              const Divider(),
              // Settings
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Pengaturan'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ProfileSettingsPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Icon(Icons.psychology_alt,
                      size: 60, color: Colors.indigo),
                  const SizedBox(height: 16),
                  const Text(
                    'Selamat Datang di InsightMind',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Mulai screening sederhana untuk memprediksi risiko '
                    'kesehatan mental Anda secara cepat dan mudah.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: () {
                      if (user == null) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Autentikasi Diperlukan'),
                            content: const Text('Fitur ini membutuhkan akun. Silakan daftar atau masuk.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPage()));
                                },
                                child: const Text('Daftar'),
                              ),
                              FilledButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage()));
                                },
                                child: const Text('Masuk'),
                              ),
                            ],
                          ),
                        );
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ScreeningPage()),
                      );
                    },
                    child: user == null
                        ? const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [Icon(Icons.lock), SizedBox(width: 8), Text('Mulai Screening')],
                          )
                        : const Text('Mulai Screening'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () {
                      // Simulasi FeatureVector untuk testing AI
                      final testFeatureVector = FeatureVector(
                        screeningScore: 15.0,
                        activityMean: 0.5,
                        activityVar: 0.3,
                        ppgMean: 0.7,
                        ppgVar: 0.2,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AIResultPage(
                            featureVector: testFeatureVector,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.psychology),
                    label: const Text('Test AI Prediction'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (answers.isNotEmpty)
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text('Riwayat Simulasi Minggu 2',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        for (final a in answers) Chip(label: Text('$a')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AnalyticsPage()),
            );
          } else if (index == 2) {
            if (user == null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              );
            }
          }
        },
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_outlined), label: 'Beranda'),
          NavigationDestination(
              icon: Icon(Icons.show_chart), label: 'Analytics'),
          NavigationDestination(
              icon: Icon(Icons.person_outline), label: 'Akun'),
        ],
      ),
    );
  }
}
