import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/chat_message.dart';

class ChatService {
  final List<ChatMessage> _messages = [];
  // API Key de Groq - Obtener de variable de entorno o configuración
  // Para desarrollo local, crea un archivo .env o usa variables de entorno
  static const String _apiKey = String.fromEnvironment(
    'GROQ_API_KEY',
    defaultValue: '',
  );
  static const String _apiUrl =
      'https://api.groq.com/openai/v1/chat/completions';

  List<ChatMessage> getMessages() {
    return List.unmodifiable(_messages);
  }

  void addMessage(String message, {required bool isUser}) {
    _messages.add(
      ChatMessage(message: message, isUser: isUser, timestamp: DateTime.now()),
    );
  }

  Future<String> sendMessage(String userMessage) async {
    // Si no hay API key, usar respuestas predefinidas
    if (_apiKey.isEmpty) {
      return _getFallbackResponse(userMessage.toLowerCase());
    }

    try {
      // Construir el contexto del chat
      final chatMessages = <Map<String, String>>[];

      // Agregar mensaje del sistema
      chatMessages.add({
        'role': 'system',
        'content':
            'Eres un asistente experto en comunicación, oratoria y análisis de pitches. '
            'Ayudas a los usuarios a mejorar sus habilidades de presentación. '
            'Responde de manera amigable, concisa y profesional en español. '
            'Si te preguntan sobre análisis de audio, menciona que pueden grabar un pitch y obtener feedback detallado.',
      });

      // Agregar historial de conversación (últimos 10 mensajes)
      final recentMessages = _messages.length > 10
          ? _messages.sublist(_messages.length - 10)
          : _messages;

      for (final msg in recentMessages) {
        chatMessages.add({
          'role': msg.isUser ? 'user' : 'assistant',
          'content': msg.message,
        });
      }

      // Agregar el mensaje actual del usuario
      chatMessages.add({'role': 'user', 'content': userMessage});

      // Llamar a la API de Groq usando HTTP
      final response = await http
          .post(
            Uri.parse(_apiUrl),
            headers: {
              'Authorization': 'Bearer $_apiKey',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'model': 'llama-3.1-70b-versatile',
              'messages': chatMessages,
              'temperature': 0.7,
              'max_tokens': 500,
            }),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw Exception('Tiempo de espera agotado');
            },
          );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final choices = data['choices'] as List;
        if (choices.isNotEmpty) {
          final message = choices[0]['message'] as Map<String, dynamic>;
          final assistantMessage =
              message['content'] as String? ??
              'Lo siento, no pude generar una respuesta. Por favor, intenta de nuevo.';
          return assistantMessage;
        } else {
          return _getFallbackResponse(userMessage.toLowerCase());
        }
      } else {
        // Si hay error con Groq, devolver respuestas predefinidas
        return _getFallbackResponse(userMessage.toLowerCase());
      }
    } catch (e) {
      // Si hay error con Groq, devolver respuestas predefinidas
      return _getFallbackResponse(userMessage.toLowerCase());
    }
  }

  String _getFallbackResponse(String userMessage) {
    if (userMessage.contains('mejora') || userMessage.contains('mejorar')) {
      return 'Para mejorar tu pitch, te recomiendo:\n'
          '1. Mantén tus ideas concisas (máximo 12 segundos por idea)\n'
          '2. Comienza con el problema, no la solución\n'
          '3. Usa ejemplos concretos\n'
          '4. Evita tecnicismos innecesarios\n\n'
          '¡Puedes grabar un pitch y obtener análisis detallado!';
    } else if (userMessage.contains('muletilla') ||
        userMessage.contains('eh') ||
        userMessage.contains('bueno')) {
      return 'Para manejar las muletillas:\n'
          '• Haz pausas breves en lugar de usar "eh", "mm" o "bueno"\n'
          '• Practica tu pitch varias veces\n'
          '• Graba y escucha tus presentaciones para identificarlas\n\n'
          'El análisis de audio te ayudará a detectar muletillas automáticamente.';
    } else if (userMessage.contains('nervio') ||
        userMessage.contains('ansiedad')) {
      return 'Para manejar los nervios:\n'
          '• Toma 3 respiraciones profundas antes de hablar\n'
          '• Visualiza tu presentación exitosa\n'
          '• Practica regularmente\n'
          '• Recuerda que el conocimiento está de tu lado\n\n'
          'La práctica hace al maestro. ¡Sigue intentándolo!';
    } else if (userMessage.contains('análisis') ||
        userMessage.contains('analizar')) {
      return 'El análisis de audio te proporciona feedback sobre:\n'
          '✅ Claridad del mensaje\n'
          '✅ Flujo y estructura\n'
          '✅ Uso de tecnicismos\n'
          '✅ Muletillas\n'
          '✅ Tono emocional\n'
          '✅ Pausas y respiración\n\n'
          '¡Graba un pitch para obtener análisis detallado!';
    } else {
      return '¡Hola! Puedo ayudarte con:\n'
          '• Mejorar tu pitch\n'
          '• Técnicas de comunicación\n'
          '• Manejo de muletillas\n'
          '• Control de nervios\n'
          '• Análisis de audio\n\n'
          '¿Sobre qué te gustaría saber más?';
    }
  }

  void clearMessages() {
    _messages.clear();
  }
}
