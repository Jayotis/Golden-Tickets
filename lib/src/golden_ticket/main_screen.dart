import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'routes.dart'; //  Routes class approach
import 'auth/auth_state.dart'; // Import your AuthState

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Golden Tickets'),
      ),
      body: Center(
        child: Consumer<AuthState>( // Use Consumer to listen for AuthState changes
          builder: (context, authState, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!authState.isSignedIn) ...[ 
                  // Buttons for users who are not signed in
                  ElevatedButton(
                    onPressed: () {
                      Navigator.restorablePushNamed(context, Routes.signIn);
                    },
                    child: const Text('Sign In'),
                  ),
                  const SizedBox(height: 16), 
                  ElevatedButton(
                    onPressed: () {
                      Navigator.restorablePushNamed(context, Routes.createAccount);
                    },
                    child: const Text('Create Free Account'),
                  ),
                ] else if (authState.accountStatus == 'subscriber') ...[
                  // Buttons for users who are signed in but pending verification
                  const Text('Account created! Please verify your email.'),
                  // You might want to add a button to resend the verification email here
                ] else ...[
                  if (authState.membershipLevel == 'Work Pool') ...[
                    const Text('Welcome, Work Pool Member!'),
                    // Special features or content for Gold members
                  ] else if (authState.membershipLevel == 'Family') ...[
                    const Text('Welcome, Family Member!'),
                    // Features for Silver members
                  ] else ...[
                    const Text('Welcome, Simple Member!'),
                    // Default features for basic members
                  ],
                  // Buttons for signed-in and verified users
                  ElevatedButton(
                    onPressed: () {
                      Navigator.restorablePushNamed(context, Routes.theSmelter);
                    },
                    child: const Text('The Smelter'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Assuming you have a route for 'Tickets'
                      // Navigator.restorablePushNamed(context, Routes.tickets);
                    },
                    child: const Text('Tickets'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Assuming you have a route for 'Game Results'
                      // Navigator.restorablePushNamed(context, Routes.gameResults);
                    },
                    child: const Text('Game Results'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                       Navigator.restorablePushNamed(context, Routes.account);
                    },
                    child: const Text('Account'),
                  ),
                ],
                const SizedBox(height: 16), // Add spacing at the bottom
              ],
            );
          },
        ),
      ),
    );
  }
}