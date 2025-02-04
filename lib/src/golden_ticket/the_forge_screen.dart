import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:confetti/confetti.dart';
import 'package:logging/logging.dart';
import 'logging_utils.dart';
import 'auth/auth_state.dart'; // Import AuthState
import 'package:provider/provider.dart';
import 'dart:math';

class TheForgeScreen extends StatefulWidget {
  const TheForgeScreen({super.key});

  static const routeName = '/forge';

  @override
  TheForgeScreenState createState() => TheForgeScreenState();
}

class TheForgeScreenState extends State<TheForgeScreen> {
  final _log = Logger('TheForgeScreen');
  String? _combinationData;
  bool _showCelebration = false;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    LoggingUtils.setupLogger(_log);
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 5));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

Future<void> _getCombination() async {
  final authState = Provider.of<AuthState>(context, listen: false);
  final gameDrawData = authState.gameDrawData;

  if (gameDrawData.isEmpty) {
    _log.warning('No game draw data available.');
    _showSnackBar('No game draw data available.');
    return;
  }

  // Generate a random index within the range of available game draw data
  final randomIndex = Random().nextInt(gameDrawData.length);
  final selectedGameDrawData = gameDrawData[randomIndex];
  final gameId = selectedGameDrawData.id;
  final gameName = selectedGameDrawData.game;
  final url = Uri.https('governance.page', '/wp-json/apigold/v1/request-combination');

  final totalGameDrawCombinations = selectedGameDrawData.totalGameDrawCombinations;
  // Generate a random number within the range of 1 to totalGameDrawCombinations
  final randomNumber = Random().nextInt(totalGameDrawCombinations) + 1;

  try {
    final authToken = authState.authToken;

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json', // Set Content-Type for JSON
      },
      body: jsonEncode({  // Send data in the request body
        'game': gameName,
        'combination_number': randomNumber, // Include the random number in the request body
      }),
    );

    _log.info('Response status code: ${response.statusCode}');
    _log.info('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      _log.info('Decoded response data: $responseData');

      // Validate the combination format
      final combination = responseData['numbers'];
      _log.info('Combination numbers: $combination');

      if (combination is List && combination.length == 6 && combination.every((element) => element is int)) {
        // Valid combination format - proceed with celebration
        setState(() {
            _combinationData = combination.join(' '); // Join numbers with spaces
            _showCelebration = true;
          });
           _confettiController.play(); // Commented out for debugging
      } else {
        // Handle invalid combination format
        _showSnackBar('Invalid combination format.');
      }
    } else {
      _log.warning('Failed to get combination: ${response.body}');
      final responseData = json.decode(response.body);
      final message = responseData['message'] ?? 'An error occurred.';
      if (response.statusCode == 429) {
        _showSnackBar('Rate limit exceeded. Please try again later.');
      } else {
        _showSnackBar(message);
      }
    }
  } catch (e) {
    _log.severe('Error getting combination: $e');
    _showSnackBar('An error occurred: $e');
  }
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
        title: const Text('The Forge'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _getCombination,
                  child: const Text('Get Combination'),
                ),
                const SizedBox(height: 20),
                if (_showCelebration)
                  Column(
                    children: [
                      ConfettiWidget(
                        confettiController: _confettiController,
                        blastDirectionality: BlastDirectionality.explosive,
                        emissionFrequency: 0.05,
                        numberOfParticles: 20,
                        gravity: 0.05,
                      ),
                      const Text(
                        'Congratulations!',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Your Combination: $_combinationData',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  )
                else if (_combinationData!= null)
                  Text(
                    'Your Combination: $_combinationData',
                    style: const TextStyle(fontSize: 18),
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Back'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}