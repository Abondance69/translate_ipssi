// ignore_for_file: library_private_types_in_public_api, file_names
import 'package:flutter/material.dart';
import 'package:translate_ipssi/pages/correction.dart';

class MyBottomNavigationBar extends StatefulWidget {
  const MyBottomNavigationBar({super.key});

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _selectedIndex = 0;

  void navigationPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CorrectionPage()),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print(_selectedIndex);

      if (_selectedIndex == 1) {
        navigationPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            label: 'Translate',
            icon: Icon(Icons.translate, size: 30),
          ),
          BottomNavigationBarItem(
            label: 'Correction',
            icon: Icon(Icons.edit, size: 30),
          ),
          BottomNavigationBarItem(
            label: 'Chat',
            icon: Icon(Icons.chat, size: 30),
          ),
        ],
      ),
    );
  }
}
