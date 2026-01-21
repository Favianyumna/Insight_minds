import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'chatbot_page.dart';
import 'wellness_challenges_page.dart';

/// Halaman utama untuk fitur Psikologi
/// Berisi artikel, tips, teknik relaksasi, dan informasi kesehatan mental
class PsychologyPage extends ConsumerWidget {
  const PsychologyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Psikologi & Kesehatan Mental'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header Card
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [Colors.indigo.shade400, Colors.indigo.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Icon(
                    Icons.psychology,
                    size: 64,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Pusat Psikologi & Kesehatan Mental',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Informasi, tips, dan teknik untuk menjaga kesehatan mental Anda',
                    style: TextStyle(
                      fontSize: 14,
                      // ignore: deprecated_member_use
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Quick Tips Section
          _buildSectionHeader(
            context,
            'Tips Cepat',
            Icons.lightbulb_outline,
            Colors.amber,
          ),
          const SizedBox(height: 12),
          _buildTipCard(
            context,
            'Tidur Cukup',
            'Tidur 7-9 jam per hari membantu menjaga kesehatan mental dan fisik',
            Icons.bedtime,
            Colors.blue,
          ),
          _buildTipCard(
            context,
            'Olahraga Rutin',
            'Aktivitas fisik 30 menit per hari dapat mengurangi stres dan meningkatkan mood',
            Icons.fitness_center,
            Colors.green,
          ),
          _buildTipCard(
            context,
            'Meditasi',
            'Meditasi 10 menit per hari dapat membantu mengurangi kecemasan',
            Icons.self_improvement,
            Colors.purple,
          ),
          const SizedBox(height: 24),

          // Techniques Section
          _buildSectionHeader(
            context,
            'Teknik Relaksasi',
            Icons.spa_outlined,
            Colors.teal,
          ),
          const SizedBox(height: 12),
          _buildTechniqueCard(
            context,
            'Deep Breathing',
            'Teknik pernapasan dalam untuk mengurangi stres dan kecemasan',
            '1. Tarik napas dalam selama 4 hitungan\n'
                '2. Tahan napas selama 4 hitungan\n'
                '3. Buang napas selama 4 hitungan\n'
                '4. Ulangi 5-10 kali',
            Icons.air,
            Colors.cyan,
          ),
          _buildTechniqueCard(
            context,
            'Progressive Muscle Relaxation',
            'Teknik relaksasi otot untuk mengurangi ketegangan',
            '1. Tegangkan otot selama 5 detik\n'
                '2. Lepaskan dan rasakan relaksasi\n'
                '3. Mulai dari jari kaki hingga kepala\n'
                '4. Ulangi untuk setiap kelompok otot',
            Icons.healing,
            Colors.orange,
          ),
          const SizedBox(height: 24),

          // Articles Section
          _buildSectionHeader(
            context,
            'Artikel Psikologi',
            Icons.article_outlined,
            Colors.indigo,
          ),
          const SizedBox(height: 12),
          _buildArticleCard(
            context,
            'Memahami Depresi',
            'Depresi adalah gangguan mood yang mempengaruhi perasaan, pikiran, dan perilaku seseorang...',
            Icons.emoji_emotions_outlined,
            Colors.red,
          ),
          _buildArticleCard(
            context,
            'Mengelola Kecemasan',
            'Kecemasan adalah respons normal terhadap stres, tetapi bisa menjadi masalah jika berlebihan...',
            Icons.psychology_outlined,
            Colors.orange,
          ),
          _buildArticleCard(
            context,
            'Membangun Resilience',
            'Resilience adalah kemampuan untuk bangkit kembali dari kesulitan dan tantangan hidup...',
            Icons.trending_up,
            Colors.green,
          ),
          const SizedBox(height: 24),

          // Self-Help Resources
          _buildSectionHeader(
            context,
            'Sumber Bantuan Diri',
            Icons.help_outline,
            Colors.purple,
          ),
          const SizedBox(height: 12),
          _buildResourceCard(
            context,
            'Crisis Hotline',
            'Jika Anda mengalami krisis, hubungi hotline bantuan: 119',
            Icons.phone,
            Colors.red,
          ),
          _buildResourceCard(
            context,
            'Self-Assessment',
            'Lakukan assessment untuk memahami kondisi kesehatan mental Anda',
            Icons.assessment,
            Colors.blue,
            onTap: () {
              // Navigate to screening page
              Navigator.pushNamed(context, '/screening');
            },
          ),
          const SizedBox(height: 24),

          // AI Chatbot & Challenges
          _buildSectionHeader(
            context,
            'Fitur Interaktif',
            Icons.touch_app,
            Colors.indigo,
          ),
          const SizedBox(height: 12),
          _buildResourceCard(
            context,
            'AI Chatbot Support',
            'Chat dengan AI untuk dukungan emosional dan bantuan kesehatan mental',
            Icons.chat_bubble_outline,
            Colors.purple,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ChatbotPage(),
                ),
              );
            },
          ),
          _buildResourceCard(
            context,
            'Wellness Challenges',
            'Ikuti tantangan 7-14 hari untuk meningkatkan kesehatan mental',
            Icons.emoji_events,
            Colors.orange,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const WellnessChallengesPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildTipCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          // ignore: deprecated_member_use
          backgroundColor: color.withValues(alpha: 0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildTechniqueCard(
    BuildContext context,
    String title,
    String description,
    String steps,
    IconData icon,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        leading: CircleAvatar(
          // ignore: deprecated_member_use
          backgroundColor: color.withValues(alpha: 0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              steps,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          // ignore: deprecated_member_use
          backgroundColor: color.withValues(alpha: 0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Show article detail
          _showArticleDetail(context, title, description);
        },
        isThreeLine: true,
      ),
    );
  }

  Widget _buildResourceCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color, {
    VoidCallback? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          // ignore: deprecated_member_use
          backgroundColor: color.withValues(alpha: 0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
        isThreeLine: true,
      ),
    );
  }

  void _showArticleDetail(
      BuildContext context, String title, String description) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(
            // ignore: prefer_interpolation_to_compose_strings
            description +
                '\n\nArtikel lengkap akan tersedia di update berikutnya. '
                    'Untuk informasi lebih lanjut, konsultasikan dengan profesional kesehatan mental.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}
