import 'dart:math' as math;
import 'package:flutter/material.dart';

class SunLoader extends StatefulWidget {
  const SunLoader({super.key});

  @override
  State<SunLoader> createState() => _SunLoaderState();
}

class _SunLoaderState extends State<SunLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Rotating spikes
              Transform.rotate(
                angle: _controller.value * 2 * math.pi,
                child: CustomPaint(
                  size: const Size(160, 160),
                  painter: SunSpikesPainter(
                    progress: _controller.value,
                  ),
                ),
              ),

              // Inner sun circle
              const Icon(
                Icons.circle,
                size: 80,
                color: Colors.orange,
              ),
            ],
          );
        },
      ),
    );
  }
}

class SunSpikesPainter extends CustomPainter {
  final double progress;

  SunSpikesPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;

    for (int i = 0; i < 12; i++) {
      final angle = (i * 2 * math.pi / 12);
      final start = Offset(
        center.dx + (radius - 20) * math.cos(angle),
        center.dy + (radius - 20) * math.sin(angle),
      );
      final end = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );

      // alternate opacity for loader effect
      double opacity = (i % 2 == 0)
          ? (0.5 + 0.5 * math.sin(progress * 2 * math.pi))
          : (0.5 + 0.5 * math.cos(progress * 2 * math.pi));

      paint.color = Colors.orange.withOpacity(opacity);
      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant SunSpikesPainter oldDelegate) => true;
}
