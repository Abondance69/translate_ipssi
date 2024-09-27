import 'package:flutter/material.dart';

class CorrectionPage extends StatelessWidget {
  const CorrectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: const Text('Correction'),
        backgroundColor: const Color.fromARGB(255, 20, 48, 70),
        foregroundColor: Colors.white,
      ),
      body: const Center(child: Text("Page de correction"),),
    );
  }
}
