import 'package:flutter/material.dart';
import 'package:translate_ipssi/services/groq.dart';
import 'package:translate_ipssi/widgets/skeleton.dart';

class MyTranslatePage extends StatefulWidget {
  const MyTranslatePage({super.key});

  @override
  State<MyTranslatePage> createState() => _MyTranslatePageState();
}

class _MyTranslatePageState extends State<MyTranslatePage> {
  final List<String> languages = [
    'Anglais',
    'Français',
    'Espagnol',
    'Arabe',
    'Lingala'
  ];

  String selectedLanguage = 'Anglais';
  final List<Map<String, String>> messages = [];

  final TextEditingController textController = TextEditingController();
  bool isLoading = false;

  Future<void> getTranslationData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final groqService =
          await GroqService().getTranslation(textController, selectedLanguage);
      String content = groqService["choices"][0]["message"]["content"];
      String sender = "assistant";

      setState(() {
        messages.add({
          'content': content,
          'sender': sender,
        });
        isLoading = false;
        textController.clear();
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print("Erreur : $error");
    }
  }

  Widget translationData() {
    return messages.isEmpty
        ? const Center(child: Text('Aucune donnée disponible'))
        : messagesListView(messages);
  }

  Widget messagesListView(List messages) {
    return ListView.builder(
      itemCount: messages.length + (isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == messages.length && isLoading) {
          return const Skeleton();
        }

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
        title: const Text('Translate'),
        backgroundColor: const Color.fromARGB(255, 20, 48, 70),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          languageDropdown(),
          Expanded(child: translationData()),
          textInputArea(),
        ],
      ),
    );
  }

  Widget languageDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButtonFormField<String>(
        value: selectedLanguage,
        decoration: InputDecoration(
          focusColor: Colors.white,
          labelText: 'Choisir une langue',
          labelStyle: TextStyle(
            color: Colors.blueGrey.shade800,
            fontWeight: FontWeight.bold,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
          ),
          filled: true,
          fillColor: Colors.grey.shade200,
        ),
        icon: const Icon(Icons.language, color: Colors.blueAccent),
        dropdownColor: Colors.white,
        items: languages.map((String language) {
          return DropdownMenuItem<String>(
            value: language,
            child: Text(
              language,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedLanguage = newValue!;
          });
        },
        style: TextStyle(
          color: Colors.blueGrey.shade900,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget textInputArea() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              cursorColor: const Color.fromARGB(255, 0, 35, 91),
              controller: textController,
              decoration: InputDecoration(
                hintText: 'Texte à traduire',
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Color.fromARGB(255, 0, 35, 96))),
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
            style: IconButton.styleFrom(
              foregroundColor: const Color.fromARGB(255, 0, 36, 66),
            ),
            icon: const Icon(Icons.send),
            onPressed: () {
              if (textController.text.isNotEmpty) {
                setState(() {
                  messages.add({
                    'content': textController.text,
                    'sender': 'user',
                  });
                  getTranslationData();
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
