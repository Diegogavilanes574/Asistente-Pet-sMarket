import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

class HomeOptions extends StatelessWidget {
  const HomeOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('AA'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Beamer.of(context).beamToNamed('/results');
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.restaurant_menu_outlined),
                  SizedBox(width: 8),
                  Text('Resultados'),
                ],
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Beamer.of(context).beamToNamed('/chatbot');
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.chat_outlined),
                  SizedBox(width: 8),
                  Text('Chatbot'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
