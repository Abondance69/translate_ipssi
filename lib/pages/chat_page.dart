import 'package:flutter/material.dart';
import 'package:translate_ipssi/services/groq.dart';
import 'package:translate_ipssi/widgets/skeleton.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<String> languages = [
    'Anglais',
    'Français',
    'Espagnol',
    'Arabe',
    'Lingala',
    'Créole'
  ];

  String selectedLanguage = 'Anglais';
  final List<Map<String, String>> discusions = [];

  final TextEditingController textController = TextEditingController();
  bool isLoading = false;

  Future<void> getChatData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final groqService =
          await GroqService().getChat(textController);
      String content = groqService["choices"][0]["message"]["content"];
      String sender = groqService["choices"][0]["message"]["role"];
      DateTime now = DateTime.now();
      dynamic minutes = now.minute < 10 ? "0${now.minute}" : now.minute;
      dynamic hour = now.hour + 2 < 10
          ? "0${now.hour + 2}"
          : now.hour + 2;
      dynamic date = "$hour:$minutes";

      setState(() {
        discusions.add({'content': content, 'sender': sender, 'date': date});
        isLoading = false;
        textController.clear();
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget translationData() {
    return discusions.isEmpty
        ? const Center(child: Text('Aucune discusion disponible'))
        : messagesListView(discusions);
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
                    Text(
                      message['date'] ?? "",
                      style: TextStyle(
                          color: message['sender'] == "assistant"
                              ? const Color.fromARGB(255, 206, 206, 206)
                              : Colors.black),
                    ),
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
        title: const Text('Chat'),
        backgroundColor: const Color.fromARGB(255, 20, 48, 70),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(child: translationData()),
          textInputArea(),
        ],
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
                hintText: 'Discutons',
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 0, 35, 96))),
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
                  DateTime now = DateTime.now();
                  dynamic minutes =
                      now.minute < 10 ? "0${now.minute}" : now.minute;
                  dynamic hour = now.hour + 2 < 10
                      ? "0${now.hour + 2}"
                      : now.hour + 2; // j'ai mis +2 pour etre dans UTC+2 locale
                  dynamic date = "$hour:$minutes";

                  discusions.add({
                    'content': textController.text,
                    'sender': 'user',
                    'date': date
                  });
                  getChatData();
                });
              }
            },
          ),
        ],
      ),
    );
  }
}