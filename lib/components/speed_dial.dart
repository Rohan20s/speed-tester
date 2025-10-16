import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;
import '../theme/app_theme.dart';

class SpeedDial extends StatefulWidget {
  final double speed;
  final double maxSpeed;
  final bool isAnimating;
  final VoidCallback? onAnimationComplete;

  const SpeedDial({
    super.key,
    required this.speed,
    this.maxSpeed = 100.0,
    this.isAnimating = false,
    this.onAnimationComplete,
  });

  @override
  State<SpeedDial> createState() => _SpeedDialState();
}

class _SpeedDialState extends State<SpeedDial>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _progressAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onAnimationComplete?.call();
      }
    });
  }

  @override
  void didUpdateWidget(SpeedDial oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.isAnimating && !oldWidget.isAnimating) {
      _startAnimation();
    } else if (!widget.isAnimating && oldWidget.isAnimating) {
      _stopAnimation();
    }
  }

  void _startAnimation() {
    _animationController.forward();
    _pulseController.repeat(reverse: true);
  }

  void _stopAnimation() {
    _animationController.stop();
    _pulseController.stop();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: Listenable.merge([_progressAnimation, _pulseAnimation]),
          builder: (context, child) {
            return Transform.scale(
              scale: 1.0,
              child: CustomPaint(
                size: const Size(280, 140),
                painter: SpeedDialPainter(
                  progress: _progressAnimation.value,
                  currentSpeed: widget.speed,
                  maxSpeed: widget.maxSpeed,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        _buildSpeedText(),
      ],
    );
  }

  Widget _buildSpeedText() {
    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        final animatedSpeed = widget.speed * _progressAnimation.value;
        return Column(
          children: [
            Text(
              '${animatedSpeed.toStringAsFixed(1)}',
              style: AppTheme.speedText,
            ).animate().fadeIn(duration: 500.ms),
            Text(
              'Mbs',
              style: AppTheme.speedUnit,
            ).animate().fadeIn(delay: 200.ms, duration: 500.ms),
          ],
        );
      },
    );
  }
}

class SpeedDialPainter extends CustomPainter {
  final double progress;
  final double currentSpeed;
  final double maxSpeed;

  SpeedDialPainter({
    required this.progress,
    required this.currentSpeed,
    required this.maxSpeed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2 - 20;

    // Background arc (inactive portion)
    final backgroundPaint = Paint()
      ..color = AppTheme.textTertiary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    // Active arc (green portion)
    final activePaint = Paint()
      ..color = AppTheme.accentGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    // Draw background arc (semicircle)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi, // Start from left (180 degrees)
      math.pi, // Draw 180 degrees (semicircle)
      false,
      backgroundPaint,
    );

    // Draw active arc based on progress and speed
    final speedProgress = (currentSpeed / maxSpeed).clamp(0.0, 1.0);
    final sweepAngle = math.pi * speedProgress * progress;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi, // Start from left
      sweepAngle, // Draw based on progress and speed
      false,
      activePaint,
    );

    // Draw needle
    final needleAngle = math.pi + sweepAngle;
    final needleLength = radius - 20;
    final needleEnd = Offset(
      center.dx + needleLength * math.cos(needleAngle),
      center.dy + needleLength * math.sin(needleAngle),
    );

    final needlePaint = Paint()
      ..color = AppTheme.textPrimary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Draw needle line
    canvas.drawLine(center, needleEnd, needlePaint);

    // Draw needle tip (triangle)
    final triangleSize = 8.0;
    final trianglePath = Path();
    trianglePath.moveTo(needleEnd.dx, needleEnd.dy);
    
    // Calculate triangle points
    final angle1 = needleAngle + math.pi * 2 / 3;
    final angle2 = needleAngle + math.pi * 4 / 3;
    
    trianglePath.lineTo(
      needleEnd.dx + triangleSize * math.cos(angle1),
      needleEnd.dy + triangleSize * math.sin(angle1),
    );
    trianglePath.lineTo(
      needleEnd.dx + triangleSize * math.cos(angle2),
      needleEnd.dy + triangleSize * math.sin(angle2),
    );
    trianglePath.close();

    canvas.drawPath(trianglePath, Paint()..color = AppTheme.textPrimary);

    // Draw center circle
    final centerPaint = Paint()
      ..color = AppTheme.primaryDark
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 6, centerPaint);
    canvas.drawCircle(center, 6, Paint()
      ..color = AppTheme.textPrimary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1);

    // Draw speed markers
    _drawSpeedMarkers(canvas, center, radius);
  }

  void _drawSpeedMarkers(Canvas canvas, Offset center, double radius) {
    final markerPaint = Paint()
      ..color = AppTheme.textTertiary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw markers at 0, 25, 50, 75, 100
    for (int i = 0; i <= 4; i++) {
      final angle = math.pi + (math.pi / 4) * i;
      final markerLength = i % 2 == 0 ? 15.0 : 8.0;
      
      final markerStart = Offset(
        center.dx + (radius - markerLength) * math.cos(angle),
        center.dy + (radius - markerLength) * math.sin(angle),
      );
      
      final markerEnd = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      
      canvas.drawLine(markerStart, markerEnd, markerPaint);
    }
  }

  @override
  bool shouldRepaint(SpeedDialPainter oldDelegate) {
    return oldDelegate.progress != progress || 
           oldDelegate.currentSpeed != currentSpeed ||
           oldDelegate.maxSpeed != maxSpeed;
  }
}
