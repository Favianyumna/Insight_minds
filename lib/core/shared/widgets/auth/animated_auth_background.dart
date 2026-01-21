import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../constants/app_colors.dart';

/// Animated background widget for authentication pages
class AnimatedAuthBackground extends StatefulWidget {
  final Widget child;
  final bool isDark;

  const AnimatedAuthBackground({
    super.key,
    required this.child,
    this.isDark = false,
  });

  @override
  State<AnimatedAuthBackground> createState() =>
      _AnimatedAuthBackgroundState();
}

class _AnimatedAuthBackgroundState extends State<AnimatedAuthBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.primaryDark,
                  AppColors.primary,
                  AppColors.secondaryDark,
                ]
              : [
                  AppColors.primary,
                  AppColors.secondary,
                  AppColors.secondaryLight,
                ],
        ),
      ),
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: _AnimatedCirclePainter(
                  animationValue: _controller.value,
                  isDark: isDark,
                ),
                size: Size.infinite,
              );
            },
          ),
          widget.child,
        ],
      ),
    );
  }
}

class _AnimatedCirclePainter extends CustomPainter {
  final double animationValue;
  final bool isDark;

  _AnimatedCirclePainter({
    required this.animationValue,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white.withValues(alpha: isDark ? 0.05 : 0.1);

    // Multiple animated circles
    for (int i = 0; i < 3; i++) {
      final radius = 100.0 + (i * 50.0);
      final offset = Offset(
        size.width * 0.3 + (i * 0.2) * size.width +
            math.sin(animationValue * 2 * math.pi + i) * 30,
        size.height * 0.2 + (i * 0.15) * size.height +
            math.cos(animationValue * 2 * math.pi + i) * 30,
      );

      canvas.drawCircle(offset, radius, paint);
    }
  }

  @override
  bool shouldRepaint(_AnimatedCirclePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.isDark != isDark;
  }
}
