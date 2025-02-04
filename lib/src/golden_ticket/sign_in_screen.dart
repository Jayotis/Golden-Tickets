import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'auth/auth_state.dart'; // Import AuthState
import 'logging_utils.dart';
import 'package:logging/logging.dart';
import 'game_draw_data.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  static const routeName = '/sign-in';

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  final _log = Logger('SignInScreen');
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _signIn() async {
    if (!mounted) return; // Ensure the widget is still mounted

    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      _showSnackBar('Please enter both username and password.');
      return;
    }

    final url = Uri.https('governance.page', '/wp-json/apigold/v1/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        _log.info('Sign in successful: $responseData');

        // Validate and log the response data
        if (responseData['code'] != 'success') {
          _log.warning('Unexpected response code: ${responseData['code']}, message: ${responseData['message'] ?? 'N/A'}');
          _showSnackBar('Unexpected response: ${responseData['message'] ?? 'N/A'}');
          return;
        }

        final data = responseData['data'];

        // Validate and log each field
        final userId = data['user_id'];
        final accountStatus = data['account_status'];
        final membershipLevel = data['membership_level'];
        final authToken = data['auth_token'];
        final nextGameDate = data['next_game_date'];
        final totalGameCombinations = data['total_game_combinations'];
        final combinationsTotalGenerated = data['combinations_total_generated'];

        _log.fine('User ID: $userId (Type: ${userId.runtimeType})');
        _log.fine('Account Status: $accountStatus (Type: ${accountStatus.runtimeType})');
        _log.fine('Membership Level: $membershipLevel (Type: ${membershipLevel.runtimeType})');
        _log.fine('Auth Token: $authToken (Type: ${authToken.runtimeType})');
        _log.fine('Next Game Date: $nextGameDate (Type: ${nextGameDate.runtimeType})');
        _log.fine('Total Game Combinations: $totalGameCombinations (Type: ${totalGameCombinations.runtimeType})');
        _log.fine('Combinations Total Generated: $combinationsTotalGenerated (Type: ${combinationsTotalGenerated.runtimeType})');

        // Validate types
        if (userId is! int) {
          _log.severe('User ID is not an int: $userId (Type: ${userId.runtimeType})');
          _showSnackBar('Invalid user ID received.');
          return;
        }

        if (accountStatus is! String) {
          _log.severe('Account Status is not a String: $accountStatus (Type: ${accountStatus.runtimeType})');
          _showSnackBar('Invalid account status received.');
          return;
        }

        if (membershipLevel is! String) {
          _log.severe('Membership Level is not a String: $membershipLevel (Type: ${membershipLevel.runtimeType})');
          _showSnackBar('Invalid membership level received.');
          return;
        }

        if (authToken is! String) {
          _log.severe('Auth Token is not a String: $authToken (Type: ${authToken.runtimeType})');
          _showSnackBar('Invalid auth token received.');
          return;
        }

        if (nextGameDate is! String) {
          _log.severe('Next Game Date is not a String: $nextGameDate (Type: ${nextGameDate.runtimeType})');
          _showSnackBar('Invalid next game date received.');
          return;
        }

        if (totalGameCombinations is! int) {
          _log.severe('Total Game Combinations is not an int: $totalGameCombinations (Type: ${totalGameCombinations.runtimeType})');
          _showSnackBar('Invalid total game combinations received.');
          return;
        }

        if (combinationsTotalGenerated is! int) {
          _log.severe('Combinations Total Generated is not an int: $combinationsTotalGenerated (Type: ${combinationsTotalGenerated.runtimeType})');
          _showSnackBar('Invalid combinations total generated received.');
          return;
        }

        // Create a GameDrawData object
        final gameDrawData = GameDrawData(
          id: 0, // Assuming a default ID if not provided
          game: 'Lotto649', // Assuming a default game if not provided
          combinationsTotalChosen: 0, // Assuming a default value if not provided
          totalGameDrawCombinations: totalGameCombinations,
          combinationsTotalGenerated: combinationsTotalGenerated,
          drawDate: nextGameDate,
        );

        final authState = Provider.of<AuthState>(context, listen: false);

        authState.setSignInStatus(
          signedIn: true,
          accountStatus: accountStatus,
          membershipLevel: membershipLevel,
          userId: userId.toString(), // Convert userId to String
          authToken: authToken,
          gameDrawData: [gameDrawData], // Wrap the single GameDrawData in a list
        );

        // Navigate to MainScreen
        _navigateToHomeScreen();
      } else {
        _log.warning('Failed to sign in: ${response.body}');
        _showSnackBar('Failed to sign in: ${response.body}');
      }
    } catch (e) {
      _log.severe('Error signing in: $e');
      _showSnackBar('An error occurred: $e');
    }
  }

  void _navigateToHomeScreen() {
    if (mounted) {
      Navigator.restorablePushNamedAndRemoveUntil(
        context,
        '/home',
        (Route<dynamic> route) => false,
      );
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
        title: const Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signIn,
              child: const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}