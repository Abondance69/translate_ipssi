import 'package:flutter/material.dart';

class MyBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const MyBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

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
        currentIndex: currentIndex,
        onTap: onTap,
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
