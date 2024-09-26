import 'package:flutter/material.dart';
import 'package:translate_ipssi/pages/translate.dart';
import 'package:translate_ipssi/pages/correction.dart';
import 'package:translate_ipssi/widgets/navigationBar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const MyTranslatePage(),
    const CorrectionPage(),
    const Center(child: Text('Chat Page')),
  ];

  void _updateIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _updateIndex,
      ),
    );
  }
}
