import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../state/app_state.dart';
import '../utils/responsive.dart';
import '../widgets/brand_icons.dart';
import '../widgets/cherry_doodle.dart';
import '../widgets/primary_button.dart';
import 'home/home_shell.dart';
import 'sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;
  bool _submitting = false;
  String? _error;

  void _goHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeShell()),
      (route) => false,
    );
  }

  Future<void> _submitEmailForm() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _submitting = true;
      _error = null;
    });
    final result = await context.read<AppState>().login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
    if (!mounted) return;
    setState(() => _submitting = false);
    switch (result) {
      case AuthResult.success:
        _goHome();
        break;
      case AuthResult.noAccount:
        setState(() => _error = 'No account found on this device yet. Create one first.');
        break;
      case AuthResult.invalidCredentials:
        setState(() => _error = 'Incorrect email or password.');
        break;
      case AuthResult.accountExists:
        break;
    }
  }

  Future<void> _continueWithProvider() async {
    await context.read<AppState>().loginWithProvider();
    if (!mounted) return;
    _goHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pinkBg,
      appBar: AppBar(
        backgroundColor: AppColors.pinkBg,
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
                  Text('Login To Your Account', style: AppTextStyles.serifHeading(size: 26, color: AppColors.darkGreen)),
                  const SizedBox(height: 8),
                  Text('Choose the service below that you used to create account.',
                      style: AppTextStyles.body(size: 14, color: AppColors.textGrey)),
                  const CherryDoodle(),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter your email' : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: IconButton(
                        icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (v) => (v == null || v.isEmpty) ? 'Enter your password' : null,
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 10),
                    Text(_error!, style: AppTextStyles.body(size: 12.5, color: AppColors.primaryRed)),
                  ],
                  const SizedBox(height: 18),
                  PrimaryButton(
                    label: _submitting ? 'Logging in...' : 'Log In',
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
                      icon: const ProviderIconBadge(child: GoogleLogo(size: 16)),
                      onPressed: _continueWithProvider,
                    ),
                    const SizedBox(height: 14),
                    PrimaryButton(
                      label: 'Create with Apple',
                      color: AppColors.lightRed,
                      icon: const ProviderIconBadge(child: Icon(Icons.apple, color: Colors.black, size: 18)),
                      onPressed: _continueWithProvider,
                    ),                  
                  const SizedBox(height: 18),
                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SignUpScreen())),
                      child: RichText(
                        text: TextSpan(
                          style: AppTextStyles.body(size: 14, color: AppColors.textDark),
                          children: [
                            const TextSpan(text: 'New User? '),
                            TextSpan(text: 'Create Account', style: AppTextStyles.body(size: 14, color: AppColors.darkGreen, weight: FontWeight.w600)),
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
                          const TextSpan(text: 'By continuing, you agree to Fruit Pal\n'),
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
