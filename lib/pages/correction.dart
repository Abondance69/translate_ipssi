import 'package:flutter/material.dart';
import 'package:translate_ipssi/widgets/navigationBar.dart';

class CorrectionPage extends StatelessWidget {
  const CorrectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Page de correction"),),
      bottomNavigationBar: MyBottomNavigationBar(),
    );
  }
}
