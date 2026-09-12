import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../widgets/primary_button.dart';
import 'sign_up_screen.dart';
import 'sign_in_screen.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 60),
              // Mango-style logo built from simple shapes.
              SizedBox(
                width: 130,
                height: 120,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: 10,
                      top: 20,
                      child: Container(
                        width: 90,
                        height: 100,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFD500),
                          borderRadius: BorderRadius.all(Radius.elliptical(45, 50)),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 15,
                      top: 40,
                      child: Transform.rotate(
                        angle: 0.5,
                        child: Container(
                          width: 70,
                          height: 55,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7941D),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 30,
                      child: Transform.rotate(
                        angle: -0.4,
                        child: Container(
                          width: 45,
                          height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4CB16B),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Your Ultimate Fruit\nCare Companion!',
                textAlign: TextAlign.center,
                style: AppTextStyles.serifHeading(size: 24, color: AppColors.darkGreen),
              ),
              const Spacer(),
              PrimaryButton(
                label: 'Get Started',
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignUpScreen())),
              ),
              const SizedBox(height: 14),
              TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignInScreen())),
                child: Text('I already have an account', style: AppTextStyles.body(color: AppColors.darkGreen, weight: FontWeight.w600)),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
