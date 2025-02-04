import 'package:flutter/foundation.dart'; // Import foundation.dart
import 'package:logging/logging.dart';

class LoggingUtils {
  static void setupLogger(Logger logger,
      {Level level = Level.ALL, Function(LogRecord)? onLogRecord}) {
    logger.level = level;

    if (onLogRecord != null) {
      logger.onRecord.listen(onLogRecord);
    } else {
      // Default handler: print during development, do nothing in release
      logger.onRecord.listen((record) {
        if (kDebugMode) { // Check if in debug mode
          print(
              '${record.level.name}: ${record.time}: ${record.loggerName}: ${record.message}');
        }
      });
    }
  }
}