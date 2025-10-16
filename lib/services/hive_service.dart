import 'package:hive_flutter/hive_flutter.dart';
import '../models/speed_test_result.dart';

class HiveService {
  static const String _speedTestBox = 'speed_test_results';
  static Box<SpeedTestResult>? _speedTestBoxInstance;

  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register adapters
    Hive.registerAdapter(SpeedTestResultAdapter());
    
    try {
      // Try to open the box
      _speedTestBoxInstance = await Hive.openBox<SpeedTestResult>(_speedTestBox);
    } catch (e) {
      // If there's a schema mismatch, clear the database and try again
      print('Database schema mismatch detected, clearing database...');
      await Hive.deleteBoxFromDisk(_speedTestBox);
      _speedTestBoxInstance = await Hive.openBox<SpeedTestResult>(_speedTestBox);
    }
  }

  static Future<void> saveSpeedTestResult(SpeedTestResult result) async {
    if (_speedTestBoxInstance != null) {
      await _speedTestBoxInstance!.put(result.id, result);
    }
  }

  static List<SpeedTestResult> getAllSpeedTestResults() {
    if (_speedTestBoxInstance != null) {
      return _speedTestBoxInstance!.values.toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    }
    return [];
  }

  static SpeedTestResult? getLatestSpeedTestResult() {
    final results = getAllSpeedTestResults();
    return results.isNotEmpty ? results.first : null;
  }

  static Future<void> deleteSpeedTestResult(String id) async {
    if (_speedTestBoxInstance != null) {
      await _speedTestBoxInstance!.delete(id);
    }
  }

  static Future<void> clearAllData() async {
    if (_speedTestBoxInstance != null) {
      await _speedTestBoxInstance!.clear();
    }
  }

  static int getSpeedTestCount() {
    return _speedTestBoxInstance?.length ?? 0;
  }

  static List<SpeedTestResult> getSpeedTestResultsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) {
    final allResults = getAllSpeedTestResults();
    return allResults.where((result) {
      return result.timestamp.isAfter(startDate) && 
             result.timestamp.isBefore(endDate);
    }).toList();
  }

  static Map<String, dynamic> getStatistics() {
    final results = getAllSpeedTestResults();
    
    if (results.isEmpty) {
      return {
        'totalTests': 0,
        'avgDownloadSpeed': 0.0,
        'avgUploadSpeed': 0.0,
        'avgPing': 0.0,
        'bestDownloadSpeed': 0.0,
        'bestUploadSpeed': 0.0,
        'bestPing': 0.0,
      };
    }

    final totalTests = results.length;
    final avgDownloadSpeed = results.map((r) => r.downloadSpeed).reduce((a, b) => a + b) / totalTests;
    final avgUploadSpeed = results.map((r) => r.uploadSpeed).reduce((a, b) => a + b) / totalTests;
    final avgPing = results.map((r) => r.ping).reduce((a, b) => a + b) / totalTests;
    
    final bestDownloadSpeed = results.map((r) => r.downloadSpeed).reduce((a, b) => a > b ? a : b);
    final bestUploadSpeed = results.map((r) => r.uploadSpeed).reduce((a, b) => a > b ? a : b);
    final bestPing = results.map((r) => r.ping).reduce((a, b) => a < b ? a : b);

    return {
      'totalTests': totalTests,
      'avgDownloadSpeed': avgDownloadSpeed,
      'avgUploadSpeed': avgUploadSpeed,
      'avgPing': avgPing,
      'bestDownloadSpeed': bestDownloadSpeed,
      'bestUploadSpeed': bestUploadSpeed,
      'bestPing': bestPing,
    };
  }

  static Future<void> close() async {
    if (_speedTestBoxInstance != null) {
      await _speedTestBoxInstance!.close();
    }
  }
}
