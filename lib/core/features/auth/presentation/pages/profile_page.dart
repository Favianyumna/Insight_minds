import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_providers.dart';
import 'package:insightmind_app/core/features/settings/presentation/pages/profile_settings_page.dart';
import 'package:insightmind_app/core/features/settings/presentation/providers/settings_providers.dart';
import 'login_page.dart';
import 'register_page.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header dengan Gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade700, Colors.blue.shade500],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 40),
                child: Column(
                  children: [
                    // Back button
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, 
                            color: Colors.white,
                            size: 24,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                    // Title
                    const Text(
                      'Pengaturan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Profile Section
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Avatar
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          backgroundImage: user?.profileImagePath != null
                              ? NetworkImage(user!.profileImagePath!)
                              : null,
                          child: user?.profileImagePath == null
                              ? Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.purple.shade600,
                                )
                              : null,
                        ),
                        // Edit icon
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue.shade600,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 3,
                              ),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // User name
                    Text(
                      user?.fullName ?? settings.userName ?? 'Sarah Anderson',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Email
                    Text(
                      user?.email ?? 'sarah.anderson@email.com',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Account Section dengan menu
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'AKUN',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Edit Profil
                  _buildMenuCard(
                    icon: Icons.person_outline,
                    iconColor: Colors.purple.shade200,
                    iconBackgroundColor: Colors.purple.shade100,
                    title: 'Edit Profil',
                    subtitle: 'Ubah nama, email, dan info pribadi',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProfileSettingsPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  // Keamanan
                  _buildMenuCard(
                    icon: Icons.lock_outline,
                    iconColor: Colors.blue.shade600,
                    iconBackgroundColor: Colors.blue.shade100,
                    title: 'Keamanan',
                    subtitle: 'Password dan autentikasi',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProfileSettingsPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  // Pencapaian & Badge
                  _buildMenuCard(
                    icon: Icons.bookmark_outline,
                    iconColor: Colors.orange.shade600,
                    iconBackgroundColor: Colors.orange.shade100,
                    title: 'Pencapaian & Badge',
                    subtitle: 'Lihat semua pencapaianmu',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fitur Pencapaian & Badge sedang dikembangkan'),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  // Data Kesehatan Section
                  const Text(
                    'DATA KESEHATAN',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Riwayat Check-in
                  _buildMenuCard(
                    icon: Icons.favorite_outline,
                    iconColor: Colors.pink.shade600,
                    iconBackgroundColor: Colors.pink.shade100,
                    title: 'Riwayat Check-in',
                    subtitle: 'Lihat semua hasil screening',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fitur Riwayat Check-in sedang dikembangkan'),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  // Kalender Mood
                  _buildMenuCard(
                    icon: Icons.calendar_today_outlined,
                    iconColor: Colors.green.shade600,
                    iconBackgroundColor: Colors.green.shade100,
                    title: 'Kalender Mood',
                    subtitle: 'Tracking mood bulanan',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fitur Kalender Mood sedang dikembangkan'),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  // Export Data
                  _buildMenuCard(
                    icon: Icons.file_present_outlined,
                    iconColor: Colors.blue.shade600,
                    iconBackgroundColor: Colors.blue.shade100,
                    title: 'Export Data',
                    subtitle: 'Download data kesehatan mental',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fitur Export Data sedang dikembangkan'),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  // Preferensi Section
                  const Text(
                    'PREFERENSI',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Notifikasi
                  _buildPreferenceCard(
                    icon: Icons.notifications_outlined,
                    iconColor: Colors.orange.shade600,
                    iconBackgroundColor: Colors.orange.shade100,
                    title: 'Notifikasi',
                    subtitle: 'Penggiat check-in harian',
                    isToggle: true,
                    toggleValue: true,
                    onToggleChanged: (value) {
                      settings.dailyReminderEnabled = value;
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 12),
                  // Mode Gelap
                  _buildPreferenceCard(
                    icon: Icons.nights_stay_outlined,
                    iconColor: Colors.grey.shade600,
                    iconBackgroundColor: Colors.grey.shade100,
                    title: 'Mode Gelap',
                    subtitle: 'Tema gelap untuk mata',
                    isToggle: true,
                    toggleValue: settings.darkModeEnabled,
                    onToggleChanged: (value) async {
                      settings.darkModeEnabled = value;
                      await settings.save();
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 12),
                  // Pengingat Harian
                  _buildPreferenceCard(
                    icon: Icons.calendar_today_outlined,
                    iconColor: Colors.cyan.shade600,
                    iconBackgroundColor: Colors.cyan.shade100,
                    title: 'Pengingat Harian',
                    subtitle: 'Reminder pukul 09:00',
                    isToggle: true,
                    toggleValue: true,
                    onToggleChanged: (value) {
                      settings.dailyReminderEnabled = value;
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 12),
                  // Bahasa
                  _buildPreferenceCard(
                    icon: Icons.public_outlined,
                    iconColor: Colors.blue.shade600,
                    iconBackgroundColor: Colors.blue.shade100,
                    title: 'Bahasa',
                    subtitle: 'Bahasa Indonesia',
                    isToggle: false,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fitur Pengaturan Bahasa sedang dikembangkan'),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  // Tema Warna
                  _buildPreferenceCard(
                    icon: Icons.palette_outlined,
                    iconColor: Colors.purple.shade600,
                    iconBackgroundColor: Colors.purple.shade100,
                    title: 'Tema Warna',
                    subtitle: 'Personalisasi tampilan',
                    isToggle: false,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fitur Tema Warna sedang dikembangkan'),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  // Bantuan & Dukungan Section
                  const Text(
                    'BANTUAN & DUKUNGAN',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Pusat Bantuan
                  _buildMenuCard(
                    icon: Icons.help_outline,
                    iconColor: Colors.cyan.shade600,
                    iconBackgroundColor: Colors.cyan.shade100,
                    title: 'Pusat Bantuan',
                    subtitle: 'FAQ dan panduan',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fitur Pusat Bantuan sedang dikembangkan'),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  // Hubungi Kami
                  _buildMenuCard(
                    icon: Icons.chat_bubble_outline,
                    iconColor: Colors.green.shade600,
                    iconBackgroundColor: Colors.green.shade100,
                    title: 'Hubungi Kami',
                    subtitle: 'Chat dengan tim support',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fitur Hubungi Kami sedang dikembangkan'),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  // Feedback
                  _buildMenuCard(
                    icon: Icons.mail_outline,
                    iconColor: Colors.red.shade600,
                    iconBackgroundColor: Colors.red.shade100,
                    title: 'Feedback',
                    subtitle: 'Beri masukan untuk aplikasi',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fitur Feedback sedang dikembangkan'),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  // Tentang Section
                  const Text(
                    'TENTANG',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Privasi & Keamanan
                  _buildMenuCard(
                    icon: Icons.shield_outlined,
                    iconColor: Colors.teal.shade600,
                    iconBackgroundColor: Colors.teal.shade100,
                    title: 'Privasi & Keamanan',
                    subtitle: 'Kebijakan privasi data',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fitur Privasi & Keamanan sedang dikembangkan'),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  // Syarat & Ketentuan
                  _buildMenuCard(
                    icon: Icons.description_outlined,
                    iconColor: Colors.orange.shade600,
                    iconBackgroundColor: Colors.orange.shade100,
                    title: 'Syarat & Ketentuan',
                    subtitle: 'Ketentuan penggunaan',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fitur Syarat & Ketentuan sedang dikembangkan'),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  // Tentang InsighMind
                  _buildMenuCard(
                    icon: Icons.info_outline,
                    iconColor: Colors.blue.shade600,
                    iconBackgroundColor: Colors.blue.shade100,
                    title: 'Tentang InsighMind',
                    subtitle: 'Versi 1.0.0',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fitur Tentang InsightMind sedang dikembangkan'),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  // Logout/Login Button
                  if (user == null) ...[
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.blue.shade600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Masuk',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: BorderSide(
                            color: Colors.blue.shade600,
                            width: 2,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Daftar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.red.shade600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          await ref
                              .read(currentUserProvider.notifier)
                              .logout();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Anda telah logout'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => const LoginPage(),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferenceCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBackgroundColor,
    required String title,
    required String subtitle,
    required bool isToggle,
    bool toggleValue = false,
    Function(bool)? onToggleChanged,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: !isToggle ? onTap : null,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: iconBackgroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
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
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                if (isToggle)
                  Switch(
                    value: toggleValue,
                    onChanged: onToggleChanged,
                    activeThumbColor: Colors.white,
                    activeTrackColor: Colors.black87,
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: Colors.grey.shade300,
                  )
                else
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey.shade400,
                    size: 24,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBackgroundColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: iconBackgroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
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
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey.shade400,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

