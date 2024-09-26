import 'package:flutter/material.dart';
import 'package:translate_ipssi/services/groq.dart';
import 'package:translate_ipssi/widgets/navigationBar.dart';
import 'package:translate_ipssi/widgets/skeleton.dart';

class MyTranslatePage extends StatefulWidget {
  const MyTranslatePage({super.key});

  @override
  State<MyTranslatePage> createState() => _MyTranslatePageState();
}

class _MyTranslatePageState extends State<MyTranslatePage> {
  final List<String> _languages = [
    'Anglais',
    'Français',
    'Espagnol',
    'Arabe',
    'Chinois'
  ];

  String _selectedLanguage = 'Anglais';
  final List<Map<String, String>> _messages = [];

  final TextEditingController textController = TextEditingController();

  Future<dynamic> getTranslationData() async {
    try {
      final groqService =
          await GroqService().getTranslation(textController, _selectedLanguage);
      textController.clear();
      return groqService;
    } catch (e) {
      throw Exception('Erreur lors de la récupération des données: $e');
    }
  }

  Widget translationData() {
    return FutureBuilder<dynamic>(
      future: _messages.isNotEmpty ? getTranslationData() : null,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Skeleton();
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Erreur: ${snapshot.error}'),
          );
        } else if (snapshot.hasData) {
          String content = snapshot.data["choices"][0]["message"]["content"];
          String sender = snapshot.data["choices"][0]["message"]["role"];

          _messages.add({
            'content': content,
            'sender': sender,
          });

          return messagesListView(_messages);
        } else {
          return _messages.isEmpty
              ? const Text('Aucune donnée disponible')
              : messagesListView(_messages);
        }
      },
    );
  }

  Widget messagesListView(List<Map<String, String>> messages) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
          child: Align(
            alignment: message['sender'] == 'assistant'
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: message['sender'] == 'assistant'
                    ? const Color.fromARGB(255, 0, 36, 65)
                    : const Color.fromARGB(255, 221, 221, 221),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                title: Text(
                  message['content'] ?? '',
                  style: TextStyle(
                      fontSize: 18,
                      color: message['sender'] == "assistant"
                          ? Colors.white
                          : const Color.fromARGB(255, 0, 0, 0)),
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      message['sender'] ?? '',
                      style: TextStyle(
                          color: message['sender'] == "assistant"
                              ? const Color.fromARGB(255, 206, 206, 206)
                              : Colors.black),
                    ),
                    const Text(
                      "12:25",
                      style:
                          TextStyle(color: Color.fromARGB(255, 206, 206, 206)),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TRANSLATE'),
        backgroundColor: const Color.fromARGB(255, 20, 48, 70),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          languageDropdown(),
          Expanded(child: translationData()),
          TextInputArea(),
        ],
      ),
      bottomNavigationBar: const MyBottomNavigationBar(),
    );
  }

  Widget languageDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButtonFormField<String>(
        value: _selectedLanguage,
        decoration: InputDecoration(
          labelText: 'Choisir une langue',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          filled: true,
          fillColor: Colors.grey.shade200,
        ),
        icon: const Icon(Icons.language, color: Colors.blue),
        items: _languages.map((String language) {
          return DropdownMenuItem<String>(
            value: language,
            child: Text(language),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedLanguage = newValue!;
          });
        },
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget TextInputArea() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textController,
              decoration: InputDecoration(
                hintText: 'The text to be translated',
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                hintStyle: TextStyle(
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
                prefixIcon: const Icon(Icons.translate, color: Colors.grey),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: () {
              if (textController.text.isNotEmpty) {
                setState(() {
                  _messages.add({
                    'content': textController.text,
                    'sender': 'user',
                  });
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
