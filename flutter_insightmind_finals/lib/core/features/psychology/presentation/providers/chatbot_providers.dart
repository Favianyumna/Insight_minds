import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/services/chatbot_service.dart';
import '../../domain/entities/chat_message.dart';
import 'package:uuid/uuid.dart';

final chatbotServiceProvider = Provider<ChatbotService>((ref) {
  return ChatbotService();
});

final chatMessagesProvider = StateNotifierProvider<ChatMessagesNotifier, List<ChatMessage>>((ref) {
  return ChatMessagesNotifier();
});

final isTypingProvider = StateProvider<bool>((ref) => false);

class ChatMessagesNotifier extends StateNotifier<List<ChatMessage>> {
  ChatMessagesNotifier() : super([]) {
    // Add welcome message
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    state = [
      ChatMessage(
        id: const Uuid().v4(),
        text: 'Halo! Saya adalah AI Support untuk InsightMind. '
            'Saya di sini untuk mendengarkan dan membantu Anda. '
            'Bagaimana perasaan Anda hari ini?',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    ];
  }

  void addMessage(ChatMessage message) {
    state = [...state, message];
  }

  void clearMessages() {
    _addWelcomeMessage();
  }
}
