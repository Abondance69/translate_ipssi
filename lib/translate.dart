import 'package:flutter/material.dart';
import 'package:translate_ipssi/services/groq.dart';
import 'package:translate_ipssi/widgets/skeleton.dart';
class MyTranslatePage extends StatelessWidget {
  const MyTranslatePage({super.key});

  Future<dynamic> getData() async {
    dynamic groqService = await GroqService().getData();
    return groqService;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<dynamic>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Skeleton();
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erreur: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            // return Center(child: Text('Données: ${snapshot.data}'));
            return ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return Center(child: Text('Données: ${snapshot.data}'));
              },
            );
          } else {
            return const Text('Aucune donnée disponible');
          }
        },
      ),
    );
  }
}
