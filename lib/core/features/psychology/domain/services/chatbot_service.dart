import '../entities/chat_message.dart';

/// Service untuk AI Chatbot Support
/// Menggunakan rule-based responses dengan CBT (Cognitive Behavioral Therapy) approach
class ChatbotService {
  /// Generate response berdasarkan user message
  Future<ChatMessage> generateResponse(ChatMessage userMessage) async {
    // Simulasi delay untuk AI processing
    await Future.delayed(const Duration(milliseconds: 800));

    final userText = userMessage.text.toLowerCase();
    String response;

    // Deteksi emosi dari pesan user
    if (_containsKeywords(userText, ['sedih', 'depresi', 'putus asa', 'tidak berguna'])) {
      response = _getSadResponse();
    } else if (_containsKeywords(userText, ['cemas', 'khawatir', 'takut', 'panik', 'stres'])) {
      response = _getAnxiousResponse();
    } else if (_containsKeywords(userText, ['marah', 'kesal', 'frustasi', 'jengkel'])) {
      response = _getAngryResponse();
    } else if (_containsKeywords(userText, ['bahagia', 'senang', 'baik', 'bagus'])) {
      response = _getHappyResponse();
    } else if (_containsKeywords(userText, ['bunuh diri', 'mati', 'akhiri', 'tidak ada harapan'])) {
      response = _getCrisisResponse();
    } else if (_containsKeywords(userText, ['halo', 'hi', 'hai', 'selamat'])) {
      response = _getGreetingResponse();
    } else if (_containsKeywords(userText, ['terima kasih', 'thanks', 'makasih'])) {
      response = _getThankYouResponse();
    } else {
      response = _getGeneralResponse();
    }

    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: response,
      isUser: false,
      timestamp: DateTime.now(),
    );
  }

  /// Deteksi krisis dari pesan
  bool detectCrisis(String message) {
    final lowerMessage = message.toLowerCase();
    return _containsKeywords(lowerMessage, [
      'bunuh diri',
      'mati',
      'akhiri hidup',
      'tidak ada harapan',
      'lebih baik mati',
      'ingin mati',
    ]);
  }

  bool _containsKeywords(String text, List<String> keywords) {
    return keywords.any((keyword) => text.contains(keyword));
  }

  String _getGreetingResponse() {
    final responses = [
      'Halo! Saya di sini untuk mendengarkan Anda. Bagaimana perasaan Anda hari ini?',
      'Hai! Terima kasih sudah mempercayai saya. Ceritakan apa yang sedang Anda rasakan.',
      'Selamat datang! Saya siap membantu Anda. Ada yang ingin Anda bicarakan?',
    ];
    return responses[DateTime.now().millisecond % responses.length];
  }

  String _getSadResponse() {
    final responses = [
      'Saya memahami bahwa Anda sedang merasa sedih. Perasaan ini valid dan penting untuk diakui. '
          'Bisakah Anda ceritakan lebih lanjut tentang apa yang membuat Anda merasa seperti ini?',
      'Merasa sedih adalah bagian dari pengalaman manusia. Anda tidak sendirian. '
          'Mari kita coba pahami perasaan ini bersama-sama. Apa yang terjadi hari ini?',
      'Saya mendengar kesedihan Anda. Terkadang mengekspresikan perasaan bisa membantu. '
          'Ingat, perasaan ini akan berlalu. Apa yang bisa membantu Anda merasa lebih baik?',
    ];
    return responses[DateTime.now().millisecond % responses.length];
  }

  String _getAnxiousResponse() {
    final responses = [
      'Saya memahami kecemasan yang Anda rasakan. Kecemasan adalah respons normal terhadap stres. '
          'Mari kita coba teknik pernapasan dalam: tarik napas 4 hitungan, tahan 4, buang 4. '
          'Coba lakukan ini beberapa kali.',
      'Kecemasan bisa terasa sangat menakutkan, tetapi Anda bisa mengelolanya. '
          'Coba fokus pada hal yang bisa Anda kontrol saat ini. Apa yang membuat Anda merasa cemas?',
      'Saya di sini untuk membantu Anda mengelola kecemasan. '
          'Coba teknik grounding: sebutkan 5 hal yang Anda lihat, 4 yang Anda sentuh, 3 yang Anda dengar, '
          '2 yang Anda cium, 1 yang Anda rasakan.',
    ];
    return responses[DateTime.now().millisecond % responses.length];
  }

  String _getAngryResponse() {
    final responses = [
      'Saya memahami frustrasi Anda. Marah adalah emosi yang valid. '
          'Coba ambil napas dalam dan hitung sampai 10. Apa yang membuat Anda merasa seperti ini?',
      'Kemarahan bisa menjadi cara tubuh merespons situasi yang tidak adil. '
          'Mari kita coba pahami sumber kemarahan ini. Apa yang terjadi?',
      'Saya mendengar kemarahan Anda. Coba ekspresikan perasaan ini dengan cara yang konstruktif. '
          'Apa yang sebenarnya Anda butuhkan saat ini?',
    ];
    return responses[DateTime.now().millisecond % responses.length];
  }

  String _getHappyResponse() {
    final responses = [
      'Senang mendengar Anda merasa baik! Itu luar biasa. '
          'Apa yang membuat Anda merasa bahagia hari ini?',
      'Bagus sekali! Perasaan positif ini penting untuk dirayakan. '
          'Coba ingat momen ini saat Anda merasa down. Apa yang membuat Anda merasa seperti ini?',
      'Saya senang mendengar kabar baik! Terus pertahankan energi positif ini. '
          'Adakah yang ingin Anda bagikan?',
    ];
    return responses[DateTime.now().millisecond % responses.length];
  }

  String _getCrisisResponse() {
    return 'Saya sangat prihatin dengan apa yang Anda katakan. '
        'Jika Anda memiliki pikiran untuk menyakiti diri sendiri, '
        'silahkan hubungi hotline darurat: 119 atau 1-800-273-8255. '
        'Anda tidak sendirian dan ada bantuan yang tersedia. '
        'Bisakah kita bicara lebih lanjut tentang apa yang Anda rasakan?';
  }

  String _getThankYouResponse() {
    final responses = [
      'Sama-sama! Saya selalu di sini untuk Anda. Jangan ragu untuk kembali kapan saja.',
      'Terima kasih sudah mempercayai saya. Saya harap saya bisa membantu. '
          'Ingat, Anda tidak sendirian dalam perjalanan ini.',
      'Saya senang bisa membantu. Jaga diri Anda baik-baik, dan jangan ragu untuk kembali.',
    ];
    return responses[DateTime.now().millisecond % responses.length];
  }

  String _getGeneralResponse() {
    final responses = [
      'Saya mendengar Anda. Bisakah Anda ceritakan lebih lanjut tentang itu?',
      'Terima kasih sudah berbagi. Bagaimana perasaan Anda tentang hal itu?',
      'Saya memahami. Mari kita eksplorasi lebih dalam. Apa yang Anda rasakan?',
      'Itu menarik. Coba ceritakan lebih detail tentang pengalaman Anda.',
      'Saya di sini untuk mendengarkan. Apa yang ingin Anda bicarakan?',
    ];
    return responses[DateTime.now().millisecond % responses.length];
  }
}
