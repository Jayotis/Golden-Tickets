import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth/auth_state.dart';
import 'routes.dart'; // Assuming you're using the Routes class

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  static const routeName = '/account';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: Center(
        child: Consumer<AuthState>(
          builder: (context, authState, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Username: ${getUsername(authState)}'), // Get username
                Text('Membership Level: ${authState.membershipLevel}'),
                Text('Account Status: ${authState.accountStatus}'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    authState.signOut();
                    // Navigate to the main screen and remove the ability to go back
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      Routes.main,
                          (route) => false,
                    );
                  },
                  child: const Text('Sign Out'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  String getUsername(AuthState authState) {
    // You might need to adjust this logic based on how you store the username
    // For now, let's assume it's part of the sign-in response data
    if (authState.isSignedIn) {
      // If you have a way to retrieve the stored username, do it here
      // For example, you might have stored it in shared_preferences during sign-in
      return "User"; // Replace "User" with the actual retrieved username
    } else {
      return "Not Signed In";
    }
  }
}