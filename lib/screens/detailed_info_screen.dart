import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../models/speed_test_result.dart';

class DetailedInfoScreen extends StatelessWidget {
  final SpeedTestResult? result;

  const DetailedInfoScreen({super.key, this.result});

  @override
  Widget build(BuildContext context) {
    final testResult = result;
    
    if (testResult == null) {
      return Scaffold(
        backgroundColor: AppTheme.primaryDark,
        appBar: AppBar(
          title: const Text('Detailed Information'),
          backgroundColor: AppTheme.primaryDark,
        ),
        body: const Center(
          child: Text(
            'No test result available',
            style: AppTheme.headingMedium,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        title: const Text('Detailed Information'),
        backgroundColor: AppTheme.primaryDark,
        foregroundColor: AppTheme.textPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTestOverview(testResult),
            const SizedBox(height: 24),
            _buildSpeedDetails(testResult),
            const SizedBox(height: 24),
            _buildDeviceInfo(testResult),
            const SizedBox(height: 24),
            _buildNetworkInfo(testResult),
            const SizedBox(height: 24),
            _buildSystemInfo(testResult),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTestOverview(SpeedTestResult result) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Test Overview',
                style: AppTheme.headingSmall,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getRatingColor(result.speedRating),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  result.speedRating,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.schedule, color: AppTheme.textSecondary, size: 16),
              const SizedBox(width: 8),
              Text(
                'Tested on ${result.formattedTimestamp}',
                style: AppTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on, color: AppTheme.textSecondary, size: 16),
              const SizedBox(width: 8),
              Text(
                result.location,
                style: AppTheme.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms);
  }

  Widget _buildSpeedDetails(SpeedTestResult result) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Speed Details',
            style: AppTheme.headingSmall,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSpeedDetailCard(
                  'Download',
                  '${result.downloadSpeed.toStringAsFixed(1)} Mbps',
                  AppTheme.accentBlue,
                  Icons.download,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSpeedDetailCard(
                  'Upload',
                  '${result.uploadSpeed.toStringAsFixed(1)} Mbps',
                  AppTheme.accentYellow,
                  Icons.upload,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildSpeedDetailCard(
                  'Ping',
                  '${result.ping.toStringAsFixed(0)} ms',
                  AppTheme.accentGreen,
                  Icons.speed,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSpeedDetailCard(
                  'Average',
                  '${((result.downloadSpeed + result.uploadSpeed) / 2).toStringAsFixed(1)} Mbps',
                  AppTheme.accentPurple,
                  Icons.trending_up,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 600.ms);
  }

  Widget _buildSpeedDetailCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: AppTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTheme.bodyLarge.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceInfo(SpeedTestResult result) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Device Information',
            style: AppTheme.headingSmall,
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Brand', result.deviceBrand, Icons.phone_android),
          const SizedBox(height: 12),
          _buildInfoRow('Model', result.deviceModel, Icons.devices),
          const SizedBox(height: 12),
          _buildInfoRow('OS Version', result.androidVersion, Icons.system_update),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms, duration: 600.ms);
  }

  Widget _buildNetworkInfo(SpeedTestResult result) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Network Information',
            style: AppTheme.headingSmall,
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Network Type', result.networkType, Icons.wifi),
          const SizedBox(height: 12),
          _buildInfoRow('Carrier', result.carrierName, Icons.network_cell),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms, duration: 600.ms);
  }

  Widget _buildSystemInfo(SpeedTestResult result) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'System Information',
            style: AppTheme.headingSmall,
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Device Name', result.deviceName, Icons.phone_android),
          const SizedBox(height: 12),
          _buildInfoRow('Product', result.product, Icons.inventory),
          const SizedBox(height: 12),
          _buildInfoRow('Hardware', result.hardware, Icons.memory),
          const SizedBox(height: 12),
          _buildInfoRow('Fingerprint', result.fingerprint.length > 20 ? '${result.fingerprint.substring(0, 20)}...' : result.fingerprint, Icons.fingerprint),
          const SizedBox(height: 12),
          _buildInfoRow('Host', result.host, Icons.computer),
          const SizedBox(height: 12),
          _buildInfoRow('Type', result.type, Icons.category),
          const SizedBox(height: 12),
          _buildInfoRow('Physical Device', result.isPhysicalDevice ? 'Yes' : 'No', Icons.phone_android),
          const SizedBox(height: 12),
          _buildInfoRow('Security Patch', result.securityPatch, Icons.security),
          const SizedBox(height: 12),
          _buildInfoRow('Codename', result.codename, Icons.label),
          const SizedBox(height: 12),
          _buildInfoRow('Incremental', result.incremental, Icons.update),
        ],
      ),
    ).animate().fadeIn(delay: 800.ms, duration: 600.ms);
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.textSecondary, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTheme.bodySmall,
              ),
              Text(
                value,
                style: AppTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUsageBar(String label, String total, double percentage, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTheme.bodyMedium,
            ),
            Text(
              '${percentage.toStringAsFixed(1)}% of $total',
              style: AppTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage / 100,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getRatingColor(String rating) {
    switch (rating.toLowerCase()) {
      case 'excellent':
        return AppTheme.accentGreen;
      case 'good':
        return AppTheme.accentBlue;
      case 'fair':
        return AppTheme.accentYellow;
      case 'poor':
        return Colors.red;
      default:
        return AppTheme.textSecondary;
    }
  }
}
