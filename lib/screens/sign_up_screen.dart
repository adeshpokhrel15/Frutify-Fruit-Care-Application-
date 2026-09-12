import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../state/app_state.dart';
import '../utils/responsive.dart';
import '../widgets/cherry_doodle.dart';
import '../widgets/primary_button.dart';
import 'onboarding/onboarding_flow.dart';
import 'sign_in_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;
  bool _submitting = false;
  String? _error;

  void _goToOnboarding() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const OnboardingFlow()),
      (route) => false,
    );
  }

  Future<void> _submitEmailForm() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _submitting = true;
      _error = null;
    });
    final result = await context.read<AppState>().register(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
    if (!mounted) return;
    setState(() => _submitting = false);
    if (result == AuthResult.success) {
      _goToOnboarding();
    } else if (result == AuthResult.accountExists) {
      setState(() => _error = 'An account with that email already exists on this device. Try logging in instead.');
    }
  }

  Future<void> _continueWithProvider() async {
    await context.read<AppState>().loginWithProvider();
    if (!mounted) return;
    _goToOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(color: AppColors.textDark),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: Responsive.horizontalPadding(context)),
          child: ResponsiveCenter(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Create Account', style: AppTextStyles.serifHeading(size: 30)),
                  const SizedBox(height: 8),
                  Text('Done! Register your account to save your data.',
                      style: AppTextStyles.body(size: 14, color: AppColors.textGrey)),
                  const CherryDoodle(),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Enter your email';
                      if (!v.contains('@') || !v.contains('.')) return 'Enter a valid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (v) {
                      if (v == null || v.length < 6) return 'At least 6 characters';
                      return null;
                    },
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 10),
                    Text(_error!, style: AppTextStyles.body(size: 12.5, color: AppColors.primaryRed)),
                  ],
                  const SizedBox(height: 18),
                  PrimaryButton(
                    label: _submitting ? 'Creating account...' : 'Create Account',
                    onPressed: _submitting ? null : _submitEmailForm,
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text('or', style: AppTextStyles.body(size: 12, color: AppColors.textGrey)),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 18),
                  PrimaryButton(
                    label: 'Create with Google',
                    color: AppColors.lightRed,
                    icon: const Icon(Icons.g_mobiledata, color: Colors.white, size: 26),
                    onPressed: _continueWithProvider,
                  ),
                  const SizedBox(height: 14),
                  PrimaryButton(
                    label: 'Create with Apple',
                    color: AppColors.lightRed,
                    icon: const Icon(Icons.apple, color: Colors.black, size: 22),
                    onPressed: _continueWithProvider,
                  ),
                  const SizedBox(height: 18),
                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SignInScreen())),
                      child: RichText(
                        text: TextSpan(
                          style: AppTextStyles.body(size: 14, color: AppColors.textDark),
                          children: [
                            const TextSpan(text: 'Existing User? '),
                            TextSpan(text: 'Login', style: AppTextStyles.body(size: 14, color: AppColors.darkGreen, weight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: Text.rich(
                      TextSpan(
                        style: AppTextStyles.body(size: 12, color: AppColors.textGrey),
                        children: [
                          const TextSpan(text: 'By continuing, you agree to Fruits Pal\n'),
                          TextSpan(text: 'Privacy Policy', style: AppTextStyles.body(size: 12, color: AppColors.darkGreen, weight: FontWeight.w500)),
                          const TextSpan(text: ' and '),
                          TextSpan(text: 'Terms of Use', style: AppTextStyles.body(size: 12, color: AppColors.darkGreen, weight: FontWeight.w500)),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
