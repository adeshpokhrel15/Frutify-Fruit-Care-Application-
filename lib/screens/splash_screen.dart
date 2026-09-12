import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../state/app_state.dart';
import 'intro_screen.dart';
import 'sign_in_screen.dart';
import 'home/home_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final app = context.read<AppState>();
    // Load everything that was saved on-device (credentials flag, fruits,
    // profile, settings) before deciding where the user should land.
    final results = await Future.wait([
      app.init(),
      app.hasOnboarded(),
      Future.delayed(const Duration(milliseconds: 1200)), // brief splash hold
    ]);
    final onboarded = results[1] as bool;

    if (!mounted) return;

    Widget destination;
    if (app.isLoggedIn) {
      destination = const HomeShell();
    } else if (onboarded) {
      // They've been through onboarding before but aren't currently logged
      // in (logged out) — send them straight to Sign In, not the intro pitch.
      destination = const SignInScreen();
    } else {
      destination = const IntroScreen();
    }

    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => destination));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.pinkBg,
      body: Center(
        child: _CherryLogo(),
      ),
    );
  }
}

/// Simple hand-drawn-style cherry logo built purely from Flutter shapes,
/// matching the red outline cherries used across the app.
class _CherryLogo extends StatelessWidget {
  const _CherryLogo();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(110, 130),
      painter: _CherryPainter(),
    );
  }
}

class _CherryPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryRed
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final stemPath = Path()
      ..moveTo(size.width * 0.62, 0)
      ..cubicTo(size.width * 0.55, size.height * 0.25, size.width * 0.62, size.height * 0.35, size.width * 0.68, size.height * 0.42);
    final stemPath2 = Path()
      ..moveTo(size.width * 0.62, 0)
      ..cubicTo(size.width * 0.4, size.height * 0.3, size.width * 0.32, size.height * 0.4, size.width * 0.3, size.height * 0.48);
    canvas.drawPath(stemPath, paint);
    canvas.drawPath(stemPath2, paint);

    _drawHeart(canvas, paint, Offset(size.width * 0.3, size.height * 0.72), 34);
    _drawHeart(canvas, paint, Offset(size.width * 0.68, size.height * 0.55), 26);
  }

  void _drawHeart(Canvas canvas, Paint paint, Offset center, double r) {
    final path = Path();
    path.moveTo(center.dx, center.dy - r * 0.3);
    path.cubicTo(center.dx - r, center.dy - r, center.dx - r, center.dy + r * 0.5, center.dx, center.dy + r);
    path.cubicTo(center.dx + r, center.dy + r * 0.5, center.dx + r, center.dy - r, center.dx, center.dy - r * 0.3);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
