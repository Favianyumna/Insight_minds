// ignore_for_file: duplicate_import

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insightmind_app/core/features/auth/presentation/pages/login_page.dart';
import 'package:insightmind_app/core/features/auth/presentation/pages/register_page.dart';
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
import '../../../risk_analysis/presentation/providers/risk_analysis_providers.dart';
import '../../../mood/presentation/providers/mood_providers.dart';
import '../../../../shared/widgets/ai_bot_button.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('InsightMind'),
        backgroundColor: Colors.blue.shade600,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
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
                decoration: BoxDecoration(color: Colors.blue.shade600),
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
      body: Container(
        color: Colors.white,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 20),
            // Welcome Header
            Column(
              children: [
                // Icon with badge
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Icon(
                        Icons.psychology_alt,
                        size: 80,
                        color: Colors.blue,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.amber,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.star,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                const Text(
                  'Selamat Datang di\nInsightMind',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Mulai perjalanan untuk memahami dan meningkatkan kesehatan mental Anda dengan pendekatan yang personal dan mudah',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(height: 40),
            // Feature Cards
            _buildFeatureCard(
              icon: Icons.shield,
              title: 'Screening Profesional',
              description: 'Penilaian kesehatan mental yang akurat dan tervalidasi',
            ),
            const SizedBox(height: 12),
            _buildFeatureCard(
              icon: Icons.bolt,
              title: 'AI Prediction',
              description: 'Prediksi risiko dengan teknologi AI terkini',
            ),
            const SizedBox(height: 12),
            _buildFeatureCard(
              icon: Icons.favorite,
              title: 'Privasi Terjamin',
              description: 'Data Anda aman dan terlindungi dengan enkripsi',
            ),
            const SizedBox(height: 40),
            // Start Screening Button
            FilledButton.icon(
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
                  MaterialPageRoute(builder: (_) => const ScreeningPage()),
                );
              },
              icon: const Icon(Icons.shield),
              label: const Text('Mulai Screening'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue.shade600,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Test AI Prediction Button
            FilledButton.icon(
              onPressed: () async {
                _showAIPredictionDialog(context, ref);
              },
              icon: const Icon(Icons.bolt),
              label: const Text('Test AI Prediction'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
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
                          color: Colors.black87,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const PsychologyPage()),
                          );
                        },
                        child: const Text(
                          'Lihat Semua',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.amber,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Tips Hari Ini Card
                  _buildRecommendationCard(
                    backgroundColor: Colors.blue.shade100,
                    iconColor: Colors.blue.shade600,
                    icon: Icons.bedtime,
                    title: 'Tidur Cukup',
                    description:
                        'Tidur 7-9 jam per hari membantu menjaga kesehatan mental dan fisik',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PsychologyPage()),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  // Artikel Pilihan Card
                  _buildRecommendationCard(
                    backgroundColor: Colors.red.shade100,
                    iconColor: Colors.red.shade700,
                    icon: Icons.emoji_emotions_outlined,
                    title: 'Memahami Depresi',
                    description: 'Gangguan mood yang mempengaruhi perasaan, pikiran, dan perilaku',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PsychologyPage()),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  // Meditasi Pagi Card
                  _buildRecommendationCard(
                    backgroundColor: Colors.blue.shade100,
                    iconColor: Colors.blue.shade700,
                    icon: Icons.self_improvement,
                    title: 'Meditasi Mindfulness',
                    description:
                        'Meditasi 10 menit per hari dapat membantu mengurangi kecemasan',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PsychologyPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        indicatorColor: Colors.blue.shade100,
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

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.blue,
              size: 28,
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
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
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

  void _showAIPredictionDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => _AIPredictionDialog(ref: ref),
    );
  }
}

class _AIPredictionDialog extends ConsumerWidget {
  final WidgetRef ref;

  const _AIPredictionDialog({required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moodAsync = ref.watch(moodWeekProvider);
    final assessmentsAsync = ref.watch(assessmentListProvider);
    final riskScoreAsync = ref.watch(calculatedRiskScoreProvider);

    return AlertDialog(
      title: const Text('AI Prediction Analysis'),
      content: SingleChildScrollView(
        child: moodAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Text('Error: $error'),
          data: (moodEntries) {
            return assessmentsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Text('Error: $error'),
              data: (assessments) {
                return riskScoreAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Text('Error: $error'),
                  data: (riskScore) {
                    return _buildPredictionContent(
                      moodEntries,
                      assessments,
                      riskScore,
                    );
                  },
                );
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Tutup'),
        ),
      ],
    );
  }

  Widget _buildPredictionContent(
    List<dynamic> moodEntries,
    List<dynamic> assessments,
    dynamic riskScore,
  ) {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));

    // Calculate mood trend
    final recentMoods = moodEntries.where((m) {
      try {
        return m.timestamp.isAfter(sevenDaysAgo);
      } catch (e) {
        return false;
      }
    }).toList();

    // Calculate average mood score
    double avgMoodScore = 0;
    if (recentMoods.isNotEmpty) {
      try {
        final totalScore = recentMoods.fold<double>(0, (sum, m) {
          return sum + (m.score?.toDouble() ?? 5);
        });
        avgMoodScore = totalScore / recentMoods.length;
      } catch (e) {
        avgMoodScore = 5;
      }
    }

    // Get latest assessment
    final latestAssessment = assessments.isNotEmpty ? assessments.first : null;

    // Predict trend
    String trendPrediction = _predictTrend(
      avgMoodScore,
      latestAssessment,
      riskScore,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoCard(
          icon: Icons.trending_up,
          title: 'Mood Trend',
          value: avgMoodScore.toStringAsFixed(1),
          subtitle: '7 hari terakhir (${recentMoods.length} data)',
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          icon: Icons.assessment,
          title: 'Assessment',
          value: latestAssessment != null ? 'Ada' : 'Belum ada',
          subtitle: latestAssessment != null
              ? 'Skor: ${(latestAssessment.totalScore ?? 0)}'
              : 'Lakukan assessment terlebih dahulu',
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Prediksi AI:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                trendPrediction,
                style: const TextStyle(fontSize: 13, height: 1.5),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Rekomendasi:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '• Lanjutkan aktivitas positif yang sedang dilakukan\n'
                '• Tingkatkan tracking mood untuk hasil prediksi yang lebih akurat\n'
                '• Ikuti assessment berkala untuk monitoring kesehatan mental',
                style: TextStyle(fontSize: 12, height: 1.5),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.blue.shade600, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _predictTrend(
    double avgMoodScore,
    dynamic latestAssessment,
    dynamic riskScore,
  ) {
    // Mood score interpretation: 1-3 = poor, 4-6 = moderate, 7-10 = good
    String moodStatus = avgMoodScore < 4
        ? 'rendah'
        : avgMoodScore < 7
            ? 'sedang'
            : 'baik';

    String prediction =
        'Berdasarkan analisis AI terhadap mood dan data kesehatan mental Anda:\n\n';
    prediction += '📊 Status Mood: $moodStatus (${avgMoodScore.toStringAsFixed(1)}/10)\n';

    if (latestAssessment != null) {
      try {
        final score = latestAssessment.totalScore ?? 0;
        final type = latestAssessment.type ?? 'Unknown';
        String riskLevel = score < 5 ? 'minimal' : score < 10 ? 'ringan' : 'sedang';
        prediction +=
            '⚠️ Risk Level ($type): $riskLevel (skor: $score)\n';
      } catch (e) {
        prediction += '⚠️ Assessment: Tersedia\n';
      }
    } else {
      prediction += '⚠️ Assessment: Belum ada data assessment\n';
    }

    prediction += '\n💡 Insight:\n';
    if (avgMoodScore < 4) {
      prediction +=
          'Mood Anda terdeteksi dalam kondisi yang menurut. Pertimbangkan untuk melakukan screening atau berkonsultasi dengan profesional kesehatan mental.';
    } else if (avgMoodScore < 7) {
      prediction +=
          'Mood Anda cukup stabil namun ada ruang untuk peningkatan. Lanjutkan aktivitas yang membuat Anda bahagia dan pertahankan rutinitas positif.';
    } else {
      prediction +=
          'Mood Anda dalam kondisi baik! Pertahankan kebiasaan sehat dan terus track progress Anda untuk monitoring kesehatan mental.';
    }

    return prediction;
  }
}
