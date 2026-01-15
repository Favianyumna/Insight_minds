import 'package:flutter/material.dart';
import '../../features/risk_analysis/presentation/pages/assistant_bot_page.dart';
import '../../features/psychology/presentation/pages/chatbot_page.dart';

/// Widget reusable untuk tombol bot AI di toolbar
/// Menampilkan dialog untuk memilih antara Assistant Bot atau AI Support Chat
class AiBotButton extends StatelessWidget {
  const AiBotButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.support_agent),
      tooltip: 'Asisten AI',
      onPressed: () {
        _showAiBotOptions(context);
      },
    );
  }

  void _showAiBotOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Pilih Asisten AI',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.smart_toy, color: Colors.indigo),
              title: const Text('Asisten InsightMind'),
              subtitle: const Text('Bantuan tentang data dan analisis Anda'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AssistantBotPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.psychology, color: Colors.purple),
              title: const Text('AI Support Chat'),
              subtitle: const Text('Dukungan emosional dan kesehatan mental'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ChatbotPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
