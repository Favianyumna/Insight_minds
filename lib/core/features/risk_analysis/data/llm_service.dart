import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class LlmService {
  final String apiKey;
  final String baseUrl;

  LlmService({required this.apiKey, this.baseUrl = 'https://api.openai.com/v1'});

  /// Generate a reply using the OpenAI Chat Completion API (gpt-3.5-turbo)
  Future<String> chatCompletion(
    String userMessage, {
    String systemPrompt = 'You are a helpful, concise assistant that answers clearly in Indonesian when possible.',
    String model = 'gpt-3.5-turbo',
    int maxTokens = 400,
  }) async {
    final url = Uri.parse('$baseUrl/chat/completions');

    final body = {
      'model': model,
      'messages': [
        {'role': 'system', 'content': systemPrompt},
        {'role': 'user', 'content': userMessage},
      ],
      'max_tokens': maxTokens,
      'temperature': 0.7,
    };

    final resp = await http
        .post(url, headers: {
          HttpHeaders.authorizationHeader: 'Bearer $apiKey',
          HttpHeaders.contentTypeHeader: 'application/json'
        }, body: jsonEncode(body))
        .timeout(const Duration(seconds: 15));

    if (resp.statusCode ~/ 100 != 2) {
      throw Exception('LLM request failed: ${resp.statusCode} ${resp.body}');
    }

    final data = jsonDecode(resp.body);
    final choice = data['choices']?[0]?['message']?['content'];
    if (choice == null) throw Exception('No content from LLM');
    return choice.toString().trim();
  }
}
