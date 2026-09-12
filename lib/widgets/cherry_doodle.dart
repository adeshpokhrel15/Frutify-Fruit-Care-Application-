import 'package:flutter/material.dart';

/// Recreates the scattered doodle illustration (cherries, leaves, circles)
/// used on the Sign Up / Sign In screens.
class CherryDoodle extends StatelessWidget {
  const CherryDoodle({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: CustomPaint(
        size: const Size(double.infinity, 200),
        painter: _DoodlePainter(),
      ),
    );
  }
}

class _DoodlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final redPaint = Paint()
      ..color = const Color(0xFFFF3B47)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    final orangePaint = Paint()
      ..color = const Color(0xFFF7941D)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    final bluePaint = Paint()
      ..color = const Color(0xFF6EC1E4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    // Scattered small hearts (mini cherries)
    _heart(canvas, redPaint, Offset(size.width * 0.22, size.height * 0.28), 10);
    _heart(canvas, redPaint, Offset(size.width * 0.3, size.height * 0.22), 8);
    _heart(canvas, redPaint, Offset(size.width * 0.78, size.height * 0.55), 9);
    _heart(canvas, redPaint, Offset(size.width * 0.85, size.height * 0.65), 8);

    // Circles
    canvas.drawCircle(Offset(size.width * 0.3, size.height * 0.12), 8, bluePaint);
    canvas.drawCircle(Offset(size.width * 0.16, size.height * 0.55), 6, bluePaint);
    canvas.drawCircle(Offset(size.width * 0.82, size.height * 0.35), 7, bluePaint);
    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.78), 6, bluePaint);

    // Little seed/leaf shapes (orange)
    _seed(canvas, orangePaint, Offset(size.width * 0.1, size.height * 0.32));
    _seed(canvas, orangePaint, Offset(size.width * 0.08, size.height * 0.5));
    _seed(canvas, orangePaint, Offset(size.width * 0.62, size.height * 0.42));
    _seed(canvas, orangePaint, Offset(size.width * 0.6, size.height * 0.7));

    // Big central cherries
    final bigPaint = Paint()
      ..color = const Color(0xFFFF2D2D)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    final stem = Path()
      ..moveTo(size.width * 0.5, size.height * 0.05)
      ..cubicTo(size.width * 0.58, size.height * 0.2, size.width * 0.52, size.height * 0.3, size.width * 0.55, size.height * 0.4);
    final stem2 = Path()
      ..moveTo(size.width * 0.5, size.height * 0.05)
      ..cubicTo(size.width * 0.4, size.height * 0.25, size.width * 0.38, size.height * 0.35, size.width * 0.4, size.height * 0.42);
    canvas.drawPath(stem, bigPaint);
    canvas.drawPath(stem2, bigPaint);
    _heart(canvas, bigPaint, Offset(size.width * 0.4, size.height * 0.62), 28);
    _heart(canvas, bigPaint, Offset(size.width * 0.56, size.height * 0.48), 22);
  }

  void _heart(Canvas canvas, Paint paint, Offset center, double r) {
    final path = Path();
    path.moveTo(center.dx, center.dy - r * 0.3);
    path.cubicTo(center.dx - r, center.dy - r, center.dx - r, center.dy + r * 0.5, center.dx, center.dy + r);
    path.cubicTo(center.dx + r, center.dy + r * 0.5, center.dx + r, center.dy - r, center.dx, center.dy - r * 0.3);
    canvas.drawPath(path, paint);
  }

  void _seed(Canvas canvas, Paint paint, Offset center) {
    final rect = Rect.fromCenter(center: center, width: 12, height: 20);
    canvas.drawArc(rect, 0.3, 3.2, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
