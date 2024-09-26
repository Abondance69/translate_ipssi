import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GroqService {
  static const String apiUrl = 'https://api.groq.com/openai/v1/chat/completions';
  static const String apiToken = 'Bearer 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';

  Future<dynamic> getTranslation(TextEditingController text, String language) async {  

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': apiToken,
        },
        body: jsonEncode({
          "model": "llama3-groq-70b-8192-tool-use-preview",
          "messages": [
            {"role": "user", "content": "Traduit moi ${text.text} en $language"}
          ]
        }),
      );

      if (response.statusCode != 200) {
        throw Exception("Une erreur est survenue: ${response.body}");
      }

      return jsonDecode(response.body);
    } catch (error) {
      print("Une erreur: $error");
      return null; // Ou gérer l'erreur d'une autre manière
    }
  }
}
