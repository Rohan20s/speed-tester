import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../components/speed_dial.dart';
import '../components/speed_test_card.dart';
import '../components/world_map.dart';
import '../services/speed_test_service.dart';
import '../services/hive_service.dart';
import '../models/speed_test_result.dart';
import '../utils/debug_helper.dart';
import 'detailed_info_screen.dart';

class SpeedTestScreen extends StatefulWidget {
  const SpeedTestScreen({super.key});

  @override
  State<SpeedTestScreen> createState() => _SpeedTestScreenState();
}

class _SpeedTestScreenState extends State<SpeedTestScreen> {
  final SpeedTestService _speedTestService = SpeedTestService();
  
  bool _isRunning = false;
  bool _isSaving = false;
  bool _hasDataFetched = false;
  bool _isManualStop = false; // Track if user manually stopped the test
  double _downloadSpeed = 0.0;
  double _uploadSpeed = 0.0;
  List<SpeedTestResult> _testResults = [];
  double? _currentLatitude;
  double? _currentLongitude;

  @override
  void initState() {
    super.initState();
    _loadTestResults();
  }

  Future<void> _loadTestResults() async {
    DebugHelper.log('Loading test results from Hive...', tag: 'SpeedTestScreen');
    try {
      final results = HiveService.getAllSpeedTestResults();
      DebugHelper.log('Loaded ${results.length} test results', tag: 'SpeedTestScreen');
      
      setState(() {
        _testResults = results;
        // Set location from latest test if available
        if (results.isNotEmpty) {
          final latestResult = results.first;
          DebugHelper.data('Latest Result', {
            'downloadSpeed': latestResult.downloadSpeed,
            'uploadSpeed': latestResult.uploadSpeed,
            'testDuration': latestResult.testDuration,
            'location': latestResult.location,
          }, tag: 'SpeedTestScreen');
          
          // Parse location if it contains coordinates
          if (latestResult.location.contains(',')) {
            try {
              final coords = latestResult.location.split(',');
              if (coords.length == 2) {
                _currentLatitude = double.tryParse(coords[0].trim());
                _currentLongitude = double.tryParse(coords[1].trim());
                DebugHelper.log('Parsed location: $_currentLatitude, $_currentLongitude', tag: 'SpeedTestScreen');
              }
            } catch (e) {
              DebugHelper.error('Failed to parse location', tag: 'SpeedTestScreen', error: e);
              // Use default location if parsing fails
              _currentLatitude = 20.5937; // India
              _currentLongitude = 78.9629;
            }
          }
        } else {
          // Default location (India)
          _currentLatitude = 20.5937;
          _currentLongitude = 78.9629;
        }
      });
      DebugHelper.log('Test results loaded successfully', tag: 'SpeedTestScreen');
    } catch (e) {
      DebugHelper.error('Failed to load test results', tag: 'SpeedTestScreen', error: e);
    }
  }

  Future<void> _startSpeedTest() async {
    DebugHelper.log('Starting speed test from UI', tag: 'SpeedTestScreen');
    setState(() {
      _isRunning = true;
      _hasDataFetched = false;
      _isManualStop = false; // Reset manual stop flag
      _downloadSpeed = 0.0;
      _uploadSpeed = 0.0;
    });

    try {
      DebugHelper.log('Calling speed test service...', tag: 'SpeedTestScreen');
      final result = await _speedTestService.performSpeedTest(
        onProgress: (progress) {
          // Progress tracking removed - no longer needed
        },
        onSpeedUpdate: (download, upload) {
          DebugHelper.log('Speed update: Download=$download, Upload=$upload', tag: 'SpeedTestScreen');
          setState(() {
            _downloadSpeed = download;
            _uploadSpeed = upload;
            // Mark data as fetched when we get speed updates
            if (download > 0 || upload > 0) {
              _hasDataFetched = true;
            }
          });
        },
      );

      DebugHelper.log('Speed test completed, saving result...', tag: 'SpeedTestScreen');
      DebugHelper.data('Speed Test Result', {
        'downloadSpeed': result.downloadSpeed,
        'uploadSpeed': result.uploadSpeed,
        'ping': result.ping,
        'testDuration': result.testDuration,
      }, tag: 'SpeedTestScreen');

          // Save result to Hive with loading indicator
          setState(() {
            _isRunning = false;
            _isSaving = true;
          });
          
          DebugHelper.log('Starting save process...', tag: 'SpeedTestScreen');

      DebugHelper.log('Saving to Hive database...', tag: 'SpeedTestScreen');
      await HiveService.saveSpeedTestResult(result);
      DebugHelper.log('Saved to Hive, loading test results...', tag: 'SpeedTestScreen');
      await _loadTestResults();
      
      setState(() {
        _isSaving = false;
      });
      
      DebugHelper.log('Speed test completed successfully', tag: 'SpeedTestScreen');
      
      // Only close dialog if it was a manual stop
      if (_isManualStop && mounted) {
        try {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
            DebugHelper.log('Dialog closed successfully after manual stop', tag: 'SpeedTestScreen');
          } else {
            DebugHelper.log('No dialog to close after manual stop', tag: 'SpeedTestScreen');
          }
        } catch (e) {
          DebugHelper.error('Error closing dialog after manual stop', tag: 'SpeedTestScreen', error: e);
        }
      } else {
        DebugHelper.log('Test completed automatically, no dialog to close', tag: 'SpeedTestScreen');
      }
      
      // Reset manual stop flag after processing
      _isManualStop = false;

    } catch (e) {
      DebugHelper.error('Speed test failed', tag: 'SpeedTestScreen', error: e);
      setState(() {
        _isRunning = false;
        _isSaving = false;
      });
      
      // Only close dialog if it was a manual stop
      if (_isManualStop && mounted) {
        try {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
            DebugHelper.log('Dialog closed after error', tag: 'SpeedTestScreen');
          }
        } catch (dialogError) {
          DebugHelper.error('Error closing dialog after error', tag: 'SpeedTestScreen', error: dialogError);
        }
      }
      
      // Reset manual stop flag after processing
      _isManualStop = false;
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Speed test failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _stopSpeedTest() {
    // Check if user is trying to stop before data is fetched
    if (!_hasDataFetched) {
      _showStopAlert();
      return;
    }
    
    // Mark as manual stop and show loading dialog
    _isManualStop = true;
    _showSavingDialog();
    
    setState(() {
      _isRunning = false;
    });
  }
  
  void _showSavingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppTheme.secondaryDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Loading indicator
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.accentGreen.withOpacity(0.3),
                      width: 3,
                    ),
                  ),
                  child: const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentGreen),
                    strokeWidth: 3,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Title
                Text(
                  'Saving Test Results',
                  style: AppTheme.headingMedium.copyWith(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                                
                const SizedBox(height: 16),
                
                // Status message
                Text(
                  'Please wait while we save your test results...',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildSpeedDisplay(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: AppTheme.bodySmall.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTheme.headingSmall.copyWith(
            color: color,
          ),
        ),
        Text(
          'Mbps',
          style: AppTheme.bodySmall.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  void _showStopAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.secondaryDark,
          title: Text(
            'Stop Speed Test?',
            style: AppTheme.headingMedium,
          ),
          content: Text(
            'The speed test is still collecting data. Stopping now will not save any results. Do you want to continue?',
            style: AppTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Continue Test',
                style: TextStyle(
                  color: AppTheme.accentGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _isRunning = false;
                });
              },
              child: Text(
                'Stop Anyway',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Speed Test Section - Scrolls with content
              _buildSpeedTestSection(),
              
              const SizedBox(height: 20),
              
              // Results Section - Part of scrollable content
              _buildResultsSection(),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  

  Widget _buildSpeedTestSection() {
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.5, // ~50% of screen height
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),          
          // Speed Dial
          SpeedDial(
            speed: _isRunning ? (_downloadSpeed + _uploadSpeed) / 2 : _downloadSpeed,
            maxSpeed: 100.0,
            isAnimating: _isRunning,
          ),
          
          const SizedBox(height: 20),
          
         
          
          const SizedBox(height: 30),
          
          // Start/Stop Button
          _buildControlButton(),
          
          const SizedBox(height: 30),
          
          // // World Map
          // WorldMap(
          //   location: 'India',
          //   latitude: 20.5937,
          //   longitude: 78.9629, 
          // ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSpeedMetric(String label, String value, Color color, IconData icon) {
    return Column(
      children: [
        Text(
          label,
          style: AppTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTheme.headingMedium,
        ),
        Text(
          'Mbs',
          style: AppTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildControlButton() {
    return Container(
      width: 200,
      height: 60,
      child: ElevatedButton(
        onPressed: (_isRunning || _isSaving) ? _stopSpeedTest : _startSpeedTest,
        style: _isRunning ? AppTheme.stopButton : AppTheme.primaryButton,
        child: _isSaving
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Saving...',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            : Text(
                _isRunning ? 'Stop' : 'Start',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    ).animate().scale(duration: 300.ms);
  }

  Widget _buildResultsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with info button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _testResults.isEmpty ? 'Speed Test History' : 'Speed Test History (${_testResults.length})',
                style: AppTheme.headingSmall,
              ),
            ],
          ),
        ),
        
        // Results List - Show loader while saving, otherwise show results
        _isSaving
            ? _buildSavingState()
            : _testResults.isEmpty
                ? _buildEmptyState()
                : Column(
                    children: _testResults.map((result) {
                      return SpeedTestCard(
                        result: result,
                        isLatest: _testResults.indexOf(result) == 0,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailedInfoScreen(result: result),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
      ],
    );
  }

  Widget _buildSavingState() {
    return Container(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentGreen),
            ),
            const SizedBox(height: 16),
            Text(
              'Saving test results...',
              style: AppTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Please wait while we save your speed test data',
              style: AppTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.speed,
            size: 48,
            color: AppTheme.textSecondary,
          ),
          const SizedBox(height: 12),
          Text(
            'No speed tests yet',
            style: AppTheme.bodyLarge,
          ),
          const SizedBox(height: 4),
          Text(
            'Run your first speed test to see results here',
            style: AppTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
