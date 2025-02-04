import 'package:flutter/material.dart';

class GameSelectorScreen extends StatelessWidget {
  const GameSelectorScreen({super.key});

  static const routeName = '/game-selector';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Placeholder for game selection UI
            const Text('Game selection options will go here.'),
            // You might use DropdownButton, ListView, or other widgets to display available games
          ],
        ),
      ),
    );
  }
}