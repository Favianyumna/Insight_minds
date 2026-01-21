import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import '../../../settings/presentation/providers/settings_providers.dart';
import '../../../psychology/presentation/pages/psychology_page.dart';
import 'ai_result_page.dart';
import '../../data/models/feature_vector.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final answers = ref.watch(answersProvider);
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('InsightMind'),
        actions: [
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
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        settings.userName ?? 'InsightMind Menu',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileSettingsPage()),
                  );
                },
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
                onTap: () {
                  Navigator.pop(context);
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
                onTap: () {
                  Navigator.pop(context);
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
                onTap: () {
                  Navigator.pop(context);
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
          // "Untuk Kamu Hari Ini" Section
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Untuk Kamu Hari Ini',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to see all recommendations
                      },
                      child: const Text(
                        'Lihat Semua',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.purple,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Tips Hari Ini Card
                _buildRecommendationCard(
                  backgroundColor: Colors.amber.shade100,
                  iconColor: Colors.amber.shade700,
                  icon: Icons.lightbulb_outline,
                  title: 'Tips Hari Ini',
                  description:
                      'Latihan pernapasan 5 menit dapat mengurangi stres hingga 30%',
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                // Artikel Pilihan Card
                _buildRecommendationCard(
                  backgroundColor: Colors.green.shade100,
                  iconColor: Colors.green.shade700,
                  icon: Icons.book_outlined,
                  title: 'Artikel Pilihan',
                  description: 'Cara Mengatasi Kecemasan di Tempat Kerja',
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                // Meditasi Pagi Card
                _buildRecommendationCard(
                  backgroundColor: Colors.purple.shade100,
                  iconColor: Colors.purple.shade700,
                  icon: Icons.headphones_outlined,
                  title: 'Meditasi Pagi',
                  description:
                      'Mulai hari dengan meditasi mindfulness 10 menit',
                  onTap: () {},
                ),
              ],
            ),
          ),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ScreeningPage()),
                      );
                    },
                    child: const Text('Mulai Screening'),
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileSettingsPage()),
            );
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

  Widget _buildRecommendationCard({
    required Color backgroundColor,
    required Color iconColor,
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
