import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'logging_utils.dart';
import 'routes.dart';

class TheSmelter extends StatefulWidget {
  const TheSmelter({super.key});

  static const routeName = '/the-smelter';

  @override
  TheSmelterState createState() => TheSmelterState();
}

class TheSmelterState extends State<TheSmelter> {
  final _log = Logger('TheSmelter');

  @override
  void initState() {
    super.initState();
    LoggingUtils.setupLogger(_log);
  }

  void _showSnackBar(String text) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(text)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('The Smelter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.theForge); // Navigate to forge screen
              },
              child: const Text('Forge a Ticket'),
            ),
            const SizedBox(height: 20), // Add spacing
            ElevatedButton(
              onPressed: () {
                // Placeholder for View Collection
                _showSnackBar('View Collection pressed');
              },
              child: const Text('View Collection'),
            ),
            const SizedBox(height: 20), // Add spacing
            ElevatedButton(
              onPressed: () {
                // Placeholder for Select a Ticket
                _showSnackBar('Select a Ticket Pressed');
              },
              child: const Text('Select a Ticket'),
            ),
          ],
        ),
      ),
    );
  }
}