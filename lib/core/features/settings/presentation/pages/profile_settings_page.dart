import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../../../core/utils/haptic_feedback_helper.dart';
import '../../../risk_analysis/presentation/pages/assistant_bot_page.dart';

class ProfileSettingsPage extends ConsumerStatefulWidget {
  const ProfileSettingsPage({super.key});

  @override
  ConsumerState<ProfileSettingsPage> createState() =>
      _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends ConsumerState<ProfileSettingsPage> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _emergencyNameController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();

  // Assistant settings
  final _apiKeyController = TextEditingController();
  bool _obscureApiKey = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final settings = ref.read(settingsProvider);
    _nameController.text = settings.userName ?? '';
    _ageController.text = settings.userAge?.toString() ?? '';
    _emergencyNameController.text = settings.emergencyContactName ?? '';
    _emergencyPhoneController.text = settings.emergencyContactPhone ?? '';

    // Assistant settings
    _apiKeyController.text = settings.assistantApiKey ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final settings = ref.read(settingsProvider);
    settings.userName = _nameController.text.trim();
    settings.userAge = int.tryParse(_ageController.text.trim());
    settings.emergencyContactName = _emergencyNameController.text.trim();
    settings.emergencyContactPhone = _emergencyPhoneController.text.trim();
    await settings.save();

    // If a user is logged in, update the current user display name
    final currentUser = ref.read(currentUserProvider);
    if (currentUser != null) {
      ref.read(currentUserProvider.notifier).updateProfile(
        fullName: settings.userName ?? currentUser.fullName,
      );
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil disimpan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Settings'),
        backgroundColor: Colors.blue.shade600,
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Personal Info Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informasi Pribadi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama',
                      hintText: 'Masukkan nama Anda',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _ageController,
                    decoration: const InputDecoration(
                      labelText: 'Usia',
                      hintText: 'Masukkan usia',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _saveProfile,
                    icon: const Icon(Icons.save),
                    label: const Text('Simpan Profil'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Emergency Contacts Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Kontak Darurat',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Kontak yang dapat dihubungi saat darurat',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _emergencyNameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Kontak',
                      hintText: 'Masukkan nama kontak darurat',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.emergency),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _emergencyPhoneController,
                    decoration: const InputDecoration(
                      labelText: 'Nomor Telepon',
                      hintText: 'Masukkan nomor telepon',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _saveProfile,
                    icon: const Icon(Icons.save),
                    label: const Text('Simpan Kontak Darurat'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Notification Settings
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pengaturan Notifikasi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Daily Check-in Reminder'),
                    subtitle: const Text('Ingatkan untuk check-in mood harian'),
                    value: settings.dailyReminderEnabled,
                    onChanged: (value) async {
                      HapticFeedbackHelper.selection();
                      settings.dailyReminderEnabled = value;
                      await settings.save();
                      setState(() {});
                    },
                  ),
                  if (settings.dailyReminderEnabled)
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                      child: Row(
                        children: [
                          const Text('Waktu: '),
                          Expanded(
                            child: DropdownButton<String>(
                              value: settings.reminderTime ?? '09:00',
                              isExpanded: true,
                              items: [
                                '07:00',
                                '08:00',
                                '09:00',
                                '10:00',
                                '18:00',
                                '20:00',
                              ].map((time) {
                                return DropdownMenuItem(
                                  value: time,
                                  child: Text(time),
                                );
                              }).toList(),
                              onChanged: (value) async {
                                HapticFeedbackHelper.selection();
                                settings.reminderTime = value;
                                await settings.save();
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Divider(),
                  SwitchListTile(
                    title: const Text('Risk Alert Notifications'),
                    subtitle:
                        const Text('Notifikasi saat risiko tinggi terdeteksi'),
                    value: settings.riskAlertEnabled,
                    onChanged: (value) async {
                      HapticFeedbackHelper.selection();
                      settings.riskAlertEnabled = value;
                      await settings.save();
                      setState(() {});
                    },
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: const Text('Dark Mode'),
                    subtitle: const Text('Gunakan tema gelap'),
                    value: settings.darkModeEnabled,
                    onChanged: (value) async {
                      HapticFeedbackHelper.selection();
                      settings.darkModeEnabled = value;
                      await settings.save();
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Assistant Settings
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Asisten',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _apiKeyController,
                    obscureText: _obscureApiKey,
                    decoration: InputDecoration(
                      labelText: 'API Key (OpenAI)',
                      hintText: 'Masukkan API key untuk asisten (opsional)',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.vpn_key),
                      suffixIcon: IconButton(
                        icon: Icon(
                            _obscureApiKey ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _obscureApiKey = !_obscureApiKey;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: const Text('Gunakan LLM Eksternal'),
                    subtitle: const Text('Kirim pertanyaan ke layanan LLM seperti OpenAI'),
                    value: settings.assistantUseExternalLLM,
                    onChanged: (v) async {
                      settings.assistantUseExternalLLM = v;
                      await settings.save();
                      setState(() {});
                    },
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: const Text('Aktifkan Suara (TTS)'),
                    subtitle: const Text('Bacakan jawaban asisten secara otomatis'),
                    value: settings.assistantVoiceEnabled,
                    onChanged: (v) async {
                      settings.assistantVoiceEnabled = v;
                      await settings.save();
                      setState(() {});
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Simpan Transkrip'),
                    subtitle: const Text('Simpan riwayat percakapan secara lokal'),
                    value: settings.assistantSaveTranscript,
                    onChanged: (v) async {
                      settings.assistantSaveTranscript = v;
                      await settings.save();
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () async {
                            // Save API key
                            settings.assistantApiKey = _apiKeyController.text.trim();
                            await settings.save();
                            if (!mounted) return;
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Pengaturan Asisten disimpan')),
                              );
                            });
                          },
                          icon: const Icon(Icons.save),
                          label: const Text('Simpan Pengaturan'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilledButton.icon(
                        onPressed: () {
                          HapticFeedbackHelper.medium();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AssistantBotPage()),
                          );
                        },
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Uji Asisten'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Data Management
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Manajemen Data',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.download),
                    title: const Text('Ekspor Data'),
                    subtitle: const Text('Simpan semua data ke file JSON'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  const Divider(),
                  ListTile(
                    leading:
                        const Icon(Icons.delete_forever, color: Colors.red),
                    title: const Text('Hapus Semua Data',
                        style: TextStyle(color: Colors.red)),
                    subtitle: const Text('Hapus semua data yang tersimpan'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // App Info
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tentang Aplikasi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  ListTile(
                    leading: Icon(Icons.info),
                    title: Text('Versi'),
                    subtitle: Text('1.0.0'),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.description),
                    title: Text('Disclaimer'),
                    subtitle: Text(
                      'Aplikasi ini bukan diagnosis medis profesional. '
                      'Hasil hanya sebagai indikasi awal. Untuk diagnosis yang akurat, '
                      'konsultasikan dengan profesional kesehatan mental.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.lock),
                    title: Text('Privasi'),
                    subtitle: Text(
                      'Semua data disimpan lokal di perangkat Anda. '
                      'Tidak ada data yang dikirim ke server eksternal.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
