import 'package:flutter/foundation.dart';

class DebugHelper {
  static bool _isDebugMode = kDebugMode;
  
  // Enable/disable debug mode
  static void setDebugMode(bool enabled) {
    _isDebugMode = enabled;
  }
  
  // Print debug messages
  static void log(String message, {String? tag}) {
    if (_isDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final tagStr = tag != null ? '[$tag]' : '[DEBUG]';
      print('$timestamp $tagStr $message');
    }
  }
  
  // Print error messages
  static void error(String message, {String? tag, dynamic error}) {
    if (_isDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final tagStr = tag != null ? '[$tag]' : '[ERROR]';
      print('$timestamp $tagStr $message');
      if (error != null) {
        print('$timestamp $tagStr Error details: $error');
      }
    }
  }
  
  // Print warning messages
  static void warning(String message, {String? tag}) {
    if (_isDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final tagStr = tag != null ? '[$tag]' : '[WARNING]';
      print('$timestamp $tagStr $message');
    }
  }
  
  // Print info messages
  static void info(String message, {String? tag}) {
    if (_isDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final tagStr = tag != null ? '[$tag]' : '[INFO]';
      print('$timestamp $tagStr $message');
    }
  }
  
  // Print performance timing
  static void timing(String operation, Duration duration, {String? tag}) {
    if (_isDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final tagStr = tag != null ? '[$tag]' : '[TIMING]';
      print('$timestamp $tagStr $operation took ${duration.inMilliseconds}ms');
    }
  }
  
  // Print data structures
  static void data(String label, dynamic data, {String? tag}) {
    if (_isDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final tagStr = tag != null ? '[$tag]' : '[DATA]';
      print('$timestamp $tagStr $label: $data');
    }
  }
}
