import 'package:flutter/material.dart';
import 'package:translate_ipssi/services/groq.dart';

class MyTranslatePage extends StatefulWidget {
  const MyTranslatePage({super.key});
  
  @override
  State<MyTranslatePage> createState() => _MyTranslatePageState();
}

class _MyTranslatePageState extends State<MyTranslatePage> {
  final List<String> _languages = ['Anglais', 'Français', 'Espagnol', 'Arabe', 'Chinois'];//Liste de langue dispo
  String _selectedLanguage = 'Anglais';//langue selectionné
  final List<Map<String, String>> _messages = [];//Messages enregistré (utilistaeur et IA)

  final TextEditingController _textController = TextEditingController();// recuperer l'input de l'utilisateur

  Future<dynamic> getData() async {
    dynamic groqService = await GroqService().getData();
    return groqService;
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
          const SizedBox(height: 20),//Espacement
          languageDropdown(),//Liste de langues déroulante
          Expanded(child: messagesListView()),//Pour que les messages soit entre (listLanguage et Zone de texte)
          TextInputArea(),//Zone de texte (input de l'utilisateur)
        ],
      ),
      bottomNavigationBar: navigationBar(),//Nav bar
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
          return DropdownMenuItem<String>(//menu deroulant
            value: language,
            child: Text(language),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedLanguage = newValue!;//pour que la langue selectionné soit enregistré
          });
        },
      ),
    );
  }

  Widget messagesListView() {
    return ListView.builder(
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
          child: Align(
            alignment: message['sender'] == 'user'
                ? Alignment.centerRight//avoir les messages de l'utilisateur a droite
                : Alignment.centerLeft,//"                                    " gauche
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: message['sender'] == 'user'
                    ? Colors.blue.shade100//avoir les messages de l'utilisateur en bleu
                    : Colors.green.shade100,// avoir les messages de l'IA en vert
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                message['text'] ?? '',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        );
      },
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
              controller: _textController,//pour récuperer la valeur de l'input
              decoration: InputDecoration(
                hintText: 'Le texte à traduire',
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
            icon: const Icon(Icons.send, color: Colors.blue),//a l'envoie
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                setState(() {
                  //on met dans message (le message de l'utilisateur)
                  _messages.add({
                    'text': _textController.text,
                    'sender': 'user',
                  });
                  // la réponse de l'IA
                  _messages.add({
                    'text': 'La réponse de l\'IA pour "${_textController.text}"',
                    'sender': 'ai',
                  });
                  _textController.clear();
                  print(_messages);
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget navigationBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 20, 48, 70),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        selectedItemColor: const Color.fromARGB(255, 1, 187, 243),
        unselectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            label: 'Translate',
            icon: Icon(Icons.translate, size: 30, color: Colors.white),
          ),
          BottomNavigationBarItem(
            label: 'Correction',
            icon: Icon(Icons.edit, size: 30, color: Colors.white),
          ),
          BottomNavigationBarItem(
            label: 'Rephraser',
            icon: Icon(Icons.autorenew, size: 30, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
