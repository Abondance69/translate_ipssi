import 'package:flutter/material.dart';

class Skeleton extends StatelessWidget {
  const Skeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(5),
              height: 80,
              width: 330,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 220, 220, 220),
                borderRadius: BorderRadius.circular(5),
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(5),
              height: 80,
              width: 330,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 220, 220, 220),
                borderRadius: BorderRadius.circular(10),
              ),
            )
          ],
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(5),
              height: 80,
              width: 330,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 220, 220, 220),
                borderRadius: BorderRadius.circular(2),
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(5),
              height: 80,
              width: 330,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 220, 220, 220),
                borderRadius: BorderRadius.circular(10),
              ),
            )
          ],
        ),
      ],
    );
  }
}
