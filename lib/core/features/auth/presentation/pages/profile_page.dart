import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_providers.dart';
import 'package:insightmind_app/core/features/settings/presentation/pages/profile_settings_page.dart';
import 'package:insightmind_app/core/features/settings/presentation/providers/settings_providers.dart';
import 'login_page.dart';
import 'register_page.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Pengaturan Profil',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileSettingsPage()),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              child: user?.profileImagePath != null
                  ? ClipOval(
                      child: Image.network(
                        user!.profileImagePath!,
                        fit: BoxFit.cover,
                        width: 80,
                        height: 80,
                      ),
                    )
                  : const Icon(Icons.person, size: 40),
            ),
            const SizedBox(height: 12),
            Text(user?.fullName ?? settings.userName ?? 'Nama Tidak Ditemukan',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 6),
            Text(user?.email ?? 'Email tidak tersedia',
                style: const TextStyle(color: Colors.grey)),
            if (settings.userAge != null) ...[
              const SizedBox(height: 6),
              Text('Umur: ${settings.userAge}', style: const TextStyle(color: Colors.grey)),
            ],
            const SizedBox(height: 12),
            if (settings.emergencyContactName != null || settings.emergencyContactPhone != null) ...[
              const Divider(),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Kontak Darurat', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    if (settings.emergencyContactName != null)
                      Text('Nama: ${settings.emergencyContactName}'),
                    if (settings.emergencyContactPhone != null)
                      Text('Telepon: ${settings.emergencyContactPhone}'),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            if (user == null) ...[
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                  },
                  child: const Text('Masuk'),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterPage()),
                    );
                  },
                  child: const Text('Daftar'),
                ),
              ),
            ] else ...[
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () async {
                    await ref.read(currentUserProvider.notifier).logout();
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Anda telah logout')));
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                  },
                  child: const Text('Logout'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
