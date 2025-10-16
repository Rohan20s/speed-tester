import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_theme.dart';

class WorldMap extends StatelessWidget {
  final String? location;
  final double? latitude;
  final double? longitude;

  const WorldMap({
    super.key,
    this.location,
    this.latitude,
    this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CustomPaint(
          size: const Size(double.infinity, 120),
          painter: WorldMapPainter(
            locationLat: latitude ?? 50.0, // Default to Europe
            locationLng: longitude ?? 10.0,
          ),
        ),
      ),
    );
  }
}

class WorldMapPainter extends CustomPainter {
  final double locationLat;
  final double locationLng;

  WorldMapPainter({
    required this.locationLat,
    required this.locationLng,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[800]!
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = Colors.grey[600]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw simplified world map continents
    _drawContinents(canvas, size, paint, strokePaint);
    
    // Draw location marker
    _drawLocationMarker(canvas, size);
  }

  void _drawContinents(Canvas canvas, Size size, Paint fillPaint, Paint strokePaint) {
    final path = Path();
    
    // Simplified continent shapes (very basic representation)
    // North America
    path.moveTo(size.width * 0.15, size.height * 0.3);
    path.quadraticBezierTo(size.width * 0.12, size.height * 0.2, size.width * 0.18, size.height * 0.15);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.1, size.width * 0.3, size.height * 0.2);
    path.quadraticBezierTo(size.width * 0.28, size.height * 0.4, size.width * 0.25, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.2, size.height * 0.55, size.width * 0.15, size.height * 0.45);
    path.close();
    
    // Europe/Africa
    path.moveTo(size.width * 0.45, size.height * 0.15);
    path.quadraticBezierTo(size.width * 0.48, size.height * 0.1, size.width * 0.52, size.height * 0.15);
    path.quadraticBezierTo(size.width * 0.55, size.height * 0.2, size.width * 0.52, size.height * 0.3);
    path.quadraticBezierTo(size.width * 0.5, size.height * 0.35, size.width * 0.48, size.height * 0.4);
    path.quadraticBezierTo(size.width * 0.46, size.height * 0.45, size.width * 0.44, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.42, size.height * 0.6, size.width * 0.4, size.height * 0.65);
    path.quadraticBezierTo(size.width * 0.38, size.height * 0.7, size.width * 0.36, size.height * 0.75);
    path.quadraticBezierTo(size.width * 0.34, size.height * 0.8, size.width * 0.32, size.height * 0.85);
    path.quadraticBezierTo(size.width * 0.3, size.height * 0.9, size.width * 0.28, size.height * 0.85);
    path.quadraticBezierTo(size.width * 0.26, size.height * 0.8, size.width * 0.28, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.3, size.height * 0.6, size.width * 0.32, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.34, size.height * 0.4, size.width * 0.36, size.height * 0.3);
    path.quadraticBezierTo(size.width * 0.38, size.height * 0.25, size.width * 0.4, size.height * 0.2);
    path.quadraticBezierTo(size.width * 0.42, size.height * 0.15, size.width * 0.45, size.height * 0.15);
    path.close();
    
    // Asia
    path.moveTo(size.width * 0.55, size.height * 0.2);
    path.quadraticBezierTo(size.width * 0.6, size.height * 0.15, size.width * 0.65, size.height * 0.2);
    path.quadraticBezierTo(size.width * 0.7, size.height * 0.25, size.width * 0.75, size.height * 0.3);
    path.quadraticBezierTo(size.width * 0.8, size.height * 0.35, size.width * 0.85, size.height * 0.4);
    path.quadraticBezierTo(size.width * 0.9, size.height * 0.45, size.width * 0.95, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.92, size.height * 0.55, size.width * 0.88, size.height * 0.6);
    path.quadraticBezierTo(size.width * 0.84, size.height * 0.65, size.width * 0.8, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.76, size.height * 0.75, size.width * 0.72, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.68, size.height * 0.85, size.width * 0.64, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.6, size.height * 0.75, size.width * 0.56, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.52, size.height * 0.65, size.width * 0.48, size.height * 0.6);
    path.quadraticBezierTo(size.width * 0.44, size.height * 0.55, size.width * 0.4, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.44, size.height * 0.4, size.width * 0.48, size.height * 0.35);
    path.quadraticBezierTo(size.width * 0.52, size.height * 0.3, size.width * 0.55, size.height * 0.25);
    path.close();
    
    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);
  }

  void _drawLocationMarker(Canvas canvas, Size size) {
    // Convert lat/lng to screen coordinates (very simplified)
    final x = _lngToX(locationLng, size.width);
    final y = _latToY(locationLat, size.height);
    
    // Draw outer glow circle
    final glowPaint = Paint()
      ..color = AppTheme.accentPurple.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(x, y), 20, glowPaint);
    
    // Draw main location circle
    final locationPaint = Paint()
      ..color = AppTheme.accentPurple.withOpacity(0.8)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(x, y), 12, locationPaint);
    
    // Draw center dot
    final centerPaint = Paint()
      ..color = AppTheme.accentPurple.withOpacity(0.6)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(x, y), 4, centerPaint);
  }

  double _lngToX(double lng, double width) {
    // Convert longitude to X coordinate
    return ((lng + 180) / 360) * width;
  }

  double _latToY(double lat, double height) {
    // Convert latitude to Y coordinate (inverted for screen coordinates)
    return height - ((lat + 90) / 180) * height;
  }

  @override
  bool shouldRepaint(WorldMapPainter oldDelegate) {
    return oldDelegate.locationLat != locationLat || oldDelegate.locationLng != locationLng;
  }
}
