import 'package:flutter/material.dart';

class GoogleLogo extends StatelessWidget {
  final double size;
  const GoogleLogo({super.key, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _GoogleGPainter()),
    );
  }
}

class _GoogleGPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = size.width * 0.22;
    final rect = Rect.fromCircle(center: center, radius: radius - strokeWidth / 2);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    const twoPi = 6.28318530718;
    const start = -1.1;

    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(rect, start, twoPi * 0.30, false, paint);

    paint.color = const Color(0xFF34A853);
    canvas.drawArc(rect, start + twoPi * 0.30, twoPi * 0.22, false, paint);

    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(rect, start + twoPi * 0.52, twoPi * 0.10, false, paint);

    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(rect, start + twoPi * 0.62, twoPi * 0.38, false, paint);

    final barPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(center.dx - strokeWidth * 0.05, center.dy - strokeWidth / 2, radius - strokeWidth * 0.15, strokeWidth),
      barPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ProviderIconBadge extends StatelessWidget {
  final Widget child;
  final double diameter;
  const ProviderIconBadge({super.key, required this.child, this.diameter = 26});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: child,
    );
  }
}