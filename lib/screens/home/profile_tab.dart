import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_theme.dart';
import '../../state/app_state.dart';
import '../../utils/responsive.dart';
import '../../widgets/home_header.dart';
import '../../screens/sign_in_screen.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          const HomeHeader(dark: true),
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: Responsive.maxContentWidth(context)),
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    _MenuTile(icon: Icons.people_outline, label: 'Manage Profile', onTap: () {}),
                    _MenuTile(
                      icon: Icons.face_retouching_natural_outlined,
                      label: 'Login With Biometric',
                      trailing: Switch(
                        value: app.biometricEnabled,
                        activeThumbColor: Colors.white,
                        activeTrackColor: AppColors.primaryRed,
                        onChanged: (v) => context.read<AppState>().toggleBiometric(v),
                      ),
                    ),
                    _MenuTile(
                      icon: Icons.notifications_none,
                      label: 'Notification',
                      trailing: Switch(
                        value: app.notificationsEnabled,
                        activeThumbColor: Colors.white,
                        activeTrackColor: AppColors.primaryRed,
                        onChanged: (v) => context.read<AppState>().toggleNotifications(v),
                      ),
                    ),
                    _MenuTile(icon: Icons.chat_bubble_outline, label: 'Help & Preferences', onTap: () {}),
                    _MenuTile(
                      icon: Icons.logout,
                      label: 'Log Out',
                      color: AppColors.primaryRed,
                      onTap: () async {
                        await context.read<AppState>().logout();
                        if (!context.mounted) return;
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const SignInScreen()),
                          (route) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _MenuTile({required this.icon, required this.label, this.color, this.trailing, this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.textDark;
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: c),
      title: Text(label, style: AppTextStyles.body(size: 15, color: c, weight: FontWeight.w500)),
      trailing: trailing,
    );
  }
}
