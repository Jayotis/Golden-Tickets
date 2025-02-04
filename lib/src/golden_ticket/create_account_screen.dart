import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:logging/logging.dart';
import 'logging_utils.dart';
import 'package:url_launcher/url_launcher.dart';

// import 'auth/auth_state.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  static const routeName = '/create-account';

  @override
  CreateAccountScreenState createState() => CreateAccountScreenState();
}

class CreateAccountScreenState extends State<CreateAccountScreen> {
  final _log = Logger('CreateAccountScreen');
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    LoggingUtils.setupLogger(_log);
  }

  Future<void> _createAccount() async {
    if (_formKey.currentState!.validate()) {
      final url = Uri.https('governance.page', '/wp-json/apigold/v1/create-user'); // Your API endpoint
      try {
        final body = {
          'username': _usernameController.text.trim(),
          'password': _passwordController.text,
          'email': _emailController.text,
          'first_name': _firstNameController.text,
          'last_name': _lastNameController.text,
        };

        _log.fine("Request Body (before encoding): $body");

        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json', // Set the Content-Type header
          },
          body: json.encode(body), // Encode the body as JSON
        );

        _log.info("Request Body (sent): ${json.encode(body)}"); // Print the encoded body
        _log.info("Response Status Code: ${response.statusCode}");
        _log.info("Response Body: ${response.body}");

        if (!mounted) return;

        if (response.statusCode == 200) {

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Account created! Please check your email to verify.')),
          );

          // Handle deep link for email verification
          final responseData = json.decode(response.body);
          final verificationUrl = responseData['data']['verification_url']; // Assuming the API returns the verification URL
          if (verificationUrl!= null) {
            if (mounted) {
              _launchVerificationUrl(verificationUrl);
            }
          }

          // Navigate back to the sign-in screen
          if (mounted) {
            Navigator.pop(context, true);
          }
        } else {
          final responseData = json.decode(response.body);
          final errorMessage = responseData['message'] ?? 'Account creation failed.';
          _log.warning('Account creation failed: ${response.body}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
      } catch (e) {
        _log.severe('Error during account creation: $e');
        if(mounted){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('An unexpected error occurred.')),
          );
        }
      }
    }
  }
    void _showSnackBar(String text) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(text)),
      );
    }
  }

  Future<void> _launchVerificationUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      _log.warning('Could not launch verification URL: $url');
      if (mounted) {
        _showSnackBar('Could not open verification link. Please check your email.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email address';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await _createAccount();
                },
                child: const Text('Create Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }
}