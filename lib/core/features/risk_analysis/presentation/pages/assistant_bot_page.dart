import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import '../../../settings/presentation/providers/settings_providers.dart';
import '../../../settings/data/local/settings_model.dart';
import '../../data/llm_service.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class AssistantBotPage extends ConsumerStatefulWidget {
  final String? initialMessage;
  const AssistantBotPage({super.key, this.initialMessage});

  @override
  ConsumerState<AssistantBotPage> createState() => _AssistantBotPageState();
}

class ChatMessage {
  final String text;
  final bool fromUser;
  ChatMessage(this.text, {this.fromUser = false});
}

class _AssistantBotPageState extends ConsumerState<AssistantBotPage> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _sending = false;
  bool _voiceEnabled = false;
  bool _isUsingExternal = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialMessage != null && widget.initialMessage!.trim().isNotEmpty) {
      // Delay to allow widget to finish building
      Future.delayed(const Duration(milliseconds: 300), () {
        _sendMessage(widget.initialMessage!);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add(ChatMessage(text, fromUser: true));
      _sending = true;
    });
    _controller.clear();

    // Use settings to decide whether to call external LLM
    final settings = await _loadSettings();
    _isUsingExternal = settings.assistantUseExternalLLM && (settings.assistantApiKey?.isNotEmpty ?? false);
    _voiceEnabled = settings.assistantVoiceEnabled;

    String reply;
    try {
      if (_isUsingExternal) {
        final LlmService svc = LlmService(apiKey: settings.assistantApiKey!);
        reply = await svc.chatCompletion(text);
      } else {
        reply = _generateFallbackReply(text);
      }
    } catch (e) {
      // fallback on failure
      reply = '${_generateFallbackReply(text)}\n( Catatan: terjadi kesalahan layanan eksternal )';
    }

    setState(() {
      _messages.add(ChatMessage(reply));
      _sending = false;
    });

    // Save transcript if enabled
    if (settings.assistantSaveTranscript) {
      _appendTranscriptToFile(text, reply);
    }

    // TTS if enabled
    if (_voiceEnabled) {
      try {
        await _speak(reply);
      } catch (_) {}
    }
  }

  Future<SettingsModel> _loadSettings() async {
    // settingsProvider is synchronous but keep method for parity
    final settings = ref.read(settingsProvider);
    return settings;
  }

  Future<void> _appendTranscriptToFile(String user, String bot) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/assistant_transcript.txt');
      final now = DateTime.now().toIso8601String();
      final entry = '[$now] USER: $user\n[$now] BOT: $bot\n\n';
      await file.writeAsString(entry, mode: FileMode.append, flush: true);
    } catch (_) {}
  }

  Future<String?> _exportTranscript() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/assistant_transcript.txt');
      if (!await file.exists()) return null;
      // create a timestamped copy
      final dest = File('${dir.path}/assistant_transcript_${DateTime.now().millisecondsSinceEpoch}.txt');
      await dest.writeAsBytes(await file.readAsBytes());
      return dest.path;
    } catch (_) {
      return null;
    }
  }

  final FlutterTts _tts = FlutterTts();
  Future<void> _speak(String text) async {
    await _tts.setLanguage('id-ID');
    await _tts.setSpeechRate(0.45);
    await _tts.speak(text);
  }

  stt.SpeechToText? _speech;
  Future<void> _startVoiceInput() async {
    _speech ??= stt.SpeechToText();
    final available = await (_speech?.initialize() ?? Future.value(false));
    if (!available) return;
    final recognized = <String>[];
    _speech?.listen(onResult: (r) {
      if (r.finalResult) {
        recognized.add(r.recognizedWords);
      }
    });
    // Listen for 5 seconds then stop
    await Future.delayed(const Duration(seconds: 5));
    await _speech?.stop();
    final text = recognized.join(' ').trim();
    if (text.isNotEmpty) {
      _controller.text = text;
      await _sendMessage(text);
    }
  }

  String _generateFallbackReply(String input) {
    final message = input.toLowerCase();
    if (message.contains('mood')) {
      return 'Sepertinya Anda tertarik pada mood trend — buka tab "Mood Trend" untuk melihat grafik, atau pilih "Tambah Mood" untuk menambahkan entri baru.';
    }
    if (message.contains('risk')) {
      return 'Untuk melihat risk score, buka tab "Risk Scores". Jika ingin memperbarui, jalankan assessment di halaman Screening.';
    }
    if (message.contains('insight') || message.contains('insights')) {
      return 'Saya bisa memberikan ringkasan insight singkat: coba buka tab "Insights" dan pilih periode. Saya juga bisa menyalin insight tersebut untuk Anda.';
    }
    if (message.contains('export') || message.contains('pdf') || message.contains('laporan')) {
      return 'Gunakan tombol ekspor pada tab Risk Scores atau Advanced untuk membuat laporan PDF. Saya dapat menyiapkan dan menyimpan transkrip percakapan ini juga.';
    }
    if (message.contains('help') || message.contains('bantuan')) {
      return 'Halo — saya asisten InsightMind. Anda bisa tanya tentang "mood", "risk", "habit", "insights", atau minta saya mengekspor percakapan.';
    }
    if (message.contains('habit')) {
      return 'Habit-Mood correlation menunjukkan kaitan kebiasaan dan mood Anda. Pastikan mengisi beberapa entri habit agar analisis akurat.';
    }

    // Small heuristics for concise answers
    if (message.contains('berapa') || message.contains('berapa banyak')) {
      return 'Aturan umum: isi mood harian dan assessment berkala untuk mendapatkan ringkasan yang lebih akurat. Ingin saya buat ringkasan sekarang?';
    }

    // Default fallback
    return 'Maaf, saya belum paham sepenuhnya. Coba tanyakan hal terkait "mood", "risk", "insights", atau minta saya mengekspor data.';
  }

  Widget _buildMessage(ChatMessage m) {
    final alignment = m.fromUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final color = m.fromUser ? Colors.indigo : Colors.grey.shade200;
    final textColor = m.fromUser ? Colors.white : Colors.black87;

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Row(
          mainAxisAlignment: m.fromUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Flexible(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(m.text, style: TextStyle(color: textColor)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asisten InsightMind'),
        actions: [
          IconButton(
            tooltip: 'Export transcript',
            icon: const Icon(Icons.download),
            onPressed: () async {
              final path = await _exportTranscript();
              if (!mounted || path == null) return;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Transcript disimpan: $path')),
                );
              });
            },
          ),
          IconButton(
            tooltip: 'Clear history',
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              setState(() => _messages.clear());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: _messages.length,
              itemBuilder: (context, index) => _buildMessage(_messages[index]),
            ),
          ),
          if (_sending) const LinearProgressIndicator(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (t) async => await _sendMessage(t),
                    decoration: InputDecoration(
                      hintText: settings.assistantUseExternalLLM
                          ? 'Tanyakan (eksternal LLM aktif) ...'
                          : 'Tanyakan sesuatu tentang data Anda...',
                      border: const OutlineInputBorder(),
                      isDense: true,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.mic),
                        onPressed: () {
                          // Optional: voice input can be enabled from settings
                          if (!settings.assistantVoiceEnabled) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text('Aktifkan voice input di Pengaturan')));
                            return;
                          }
                          _startVoiceInput();
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async => await _sendMessage(_controller.text),
                  child: const Icon(Icons.send),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
