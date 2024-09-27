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
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': apiToken,
        },
        body: utf8.encode(jsonEncode({
          "model": "Mixtral-8x7b-32768",
          "messages": [
            {"role": "user", "content": "Tu vas me traduire le mot que je te passe dans la langue indiquée,traduit moi ${text.text} en $language, traduit juste pas d'autres messages de fin"}
          ]
        })),
      );

      if (response.statusCode != 200) {
        throw Exception("Une erreur est survenue: ${response.body}");
      }

      return jsonDecode(utf8.decode(response.bodyBytes));
    } catch (error) {
      print("Une erreur: $error");
      return null;
    }
  }
}
