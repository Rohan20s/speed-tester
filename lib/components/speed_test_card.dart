import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../models/speed_test_result.dart';

class SpeedTestCard extends StatelessWidget {
  final SpeedTestResult result;
  final VoidCallback? onTap;
  final bool isLatest;

  const SpeedTestCard({
    super.key,
    required this.result,
    this.onTap,
    this.isLatest = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: AppTheme.cardDecoration.copyWith(
              border: isLatest ? Border.all(color: AppTheme.accentGreen, width: 2) : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 12),
                _buildSpeedMetrics(),
                const SizedBox(height: 12),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Speed Test',
              style: AppTheme.headingSmall,
            ),
            Text(
              result.formattedTimestamp,
              style: AppTheme.bodySmall,
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getRatingColor(result.speedRating),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            result.speedRating,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpeedMetrics() {
    return Row(
      children: [
        Expanded(
          child: _buildMetric(
            'Download',
            '${result.downloadSpeed.toStringAsFixed(1)} Mbps',
            AppTheme.accentBlue,
            Icons.download,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildMetric(
            'Upload',
            '${result.uploadSpeed.toStringAsFixed(1)} Mbps',
            AppTheme.accentYellow,
            Icons.upload,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildMetric(
            'Ping',
            '${result.ping.toStringAsFixed(0)} ms',
            AppTheme.accentGreen,
            Icons.speed,
          ),
        ),
      ],
    );
  }

  Widget _buildMetric(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: AppTheme.bodyMedium.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        Expanded(
          child: _buildInfoItem(
            'Device',
            '${result.deviceBrand} ${result.deviceModel}',
            Icons.phone_android,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildInfoItem(
            'Network',
            result.networkType,
            Icons.wifi,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.textSecondary, size: 16),
        const SizedBox(width: 8),
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
                overflow: TextOverflow.ellipsis,
              ),
            ],
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
