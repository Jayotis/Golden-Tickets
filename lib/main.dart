import 'package:flutter/material.dart';

import 'package:logging/logging.dart';
import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';
import 'src/golden_ticket/auth/auth_state.dart';
import 'package:provider/provider.dart';

final _log = Logger('MyApp');

void formatLogfmt(LogRecord record) {
  final time = record.time;
  final level = record.level.name;
  final logger =
      record.loggerName.isNotEmpty ? ' logger=${record.loggerName}' : '';
  final msg = 'msg="${record.message}"';
  final error = record.error != null ? ' error="${record.error}"' : '';
  final stack = record.stackTrace != null ? '\n${record.stackTrace}' : '';

  final formattedLog = 'time="$time" level=$level$logger $msg$error$stack';

  // Log the formatted string using a new LogRecord
  // ignore: avoid_print
  print(formattedLog);
}

void setupLogging() {
  hierarchicalLoggingEnabled = true;

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    formatLogfmt(record);
  });
}

void main() async {
  setupLogging();
  _log.info('Application starting...');
  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
    WidgetsFlutterBinding.ensureInitialized();
  // Initialize AuthState and load data from shared_preferences
  final authState = AuthState();
  await authState.init(); // Load persisted state

  runApp(
    ChangeNotifierProvider.value(
      value: authState,
      child: MyApp(settingsController: settingsController),
    ),
  );
}
