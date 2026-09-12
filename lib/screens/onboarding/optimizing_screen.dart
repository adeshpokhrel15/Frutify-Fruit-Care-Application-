import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../widgets/primary_button.dart';
import '../home/home_shell.dart';

class OptimizingScreen extends StatefulWidget {
  const OptimizingScreen({super.key});

  @override
  State<OptimizingScreen> createState() => _OptimizingScreenState();
}

class _OptimizingScreenState extends State<OptimizingScreen> {
  double _progress = 0;
  final List<String> _steps = [
    'Optimizing navigation bar for you',
    'Finding fruit lovers near by you.',
    'Selecting collection you might like',
  ];
  int _visibleSteps = 0;

  @override
  void initState() {
    super.initState();
    _run();
  }

  Future<void> _run() async {
    for (int i = 1; i <= _steps.length; i++) {
      await Future.delayed(const Duration(milliseconds: 700));
      if (!mounted) return;
      setState(() {
        _visibleSteps = i;
        _progress = i / _steps.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final percent = (_progress * 100).round();
    final done = percent >= 100;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 60),
              SizedBox(
                width: 160,
                height: 160,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 160,
                      height: 160,
                      child: CircularProgressIndicator(
                        value: _progress,
                        strokeWidth: 8,
                        backgroundColor: AppColors.paleRedCard,
                        valueColor: const AlwaysStoppedAnimation(AppColors.primaryRed),
                      ),
                    ),
                    Text('$percent%', style: AppTextStyles.serifHeading(size: 28)),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Just a moment while we\npersonalize your experience',
                textAlign: TextAlign.center,
                style: AppTextStyles.serifHeading(size: 20, color: AppColors.lightRed),
              ),
              const SizedBox(height: 24),
              Column(
                children: List.generate(_visibleSteps, (i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        const Icon(Icons.check, size: 16, color: AppColors.darkGreen),
                        const SizedBox(width: 8),
                        Text(_steps[i], style: AppTextStyles.body(size: 14)),
                      ],
                    ),
                  );
                }),
              ),
              const Spacer(),
              if (done)
                PrimaryButton(
                  label: 'Explore Fruit Pal',
                  onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeShell()),
                    (route) => false,
                  ),
                ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
