import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_theme.dart';
import '../../state/app_state.dart';
import 'name_step.dart';
import 'priority_step.dart';
import 'location_step.dart';
import 'reminder_step.dart';
import 'optimizing_screen.dart';

/// Hosts the 4-step onboarding journey (Full Name -> Top Priority ->
/// Your Location -> Get Reminder) behind a shared back button + progress bar,
/// matching the dashed indicator seen at the top of each design.
class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _controller = PageController();
  int _step = 0;
  static const int totalSteps = 4;

  void _next() {
    if (_step < totalSteps - 1) {
      setState(() => _step++);
      _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      context.read<AppState>().completeOnboarding();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const OptimizingScreen()));
    }
  }

  void _back() {
    if (_step == 0) {
      Navigator.pop(context);
    } else {
      setState(() => _step--);
      _controller.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.textDark), onPressed: _back),
        title: _ProgressBar(step: _step, total: totalSteps),
        titleSpacing: 0,
        centerTitle: false,
      ),
      body: PageView(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          NameStep(onNext: _next),
          PriorityStep(onNext: _next),
          LocationStep(onNext: _next),
          ReminderStep(onNext: _next),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final int step;
  final int total;
  const _ProgressBar({required this.step, required this.total});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 24),
      child: Row(
        children: List.generate(total, (i) {
          final active = i <= step;
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              height: 4,
              decoration: BoxDecoration(
                color: active ? AppColors.primaryRed : AppColors.paleRedCard,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          );
        }),
      ),
    );
  }
}
