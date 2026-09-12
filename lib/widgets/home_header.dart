import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../state/app_state.dart';

/// The "Good Morning, <name>" header with a floral watermark and
/// notification bell, reused across My Fruits / Nursery / Profile.
class HomeHeader extends StatelessWidget {
  final bool dark; // true => red background with white text (Nursery / Profile)
  const HomeHeader({super.key, this.dark = false});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final fg = dark ? Colors.white : AppColors.mutedGreen;
    final nameColor = dark ? Colors.white : AppColors.textDark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      decoration: BoxDecoration(color: dark ? AppColors.primaryRed : Colors.white),
      child: Stack(
        children: [
          // Real floral watermark graphic (only on the light/My-Fruits header —
          // Nursery/Profile/Community keep the plain solid-red header).
          if (!dark)
            Positioned(
              top: -6,
              right: 0,
              left: 0,
              child: Opacity(
                opacity: 0.7,
                child: Image.asset(
                  'images/common_image.png',
                  height: 130,
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.topRight,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Good Morning,', style: AppTextStyles.body(size: 14, color: fg, weight: FontWeight.w500)),
                    const SizedBox(height: 2),
                    Text(app.userName, style: AppTextStyles.serifHeading(size: 22, color: nameColor)),
                  ],
                ),
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: dark ? Colors.transparent : AppColors.primaryRed,
                      shape: BoxShape.circle,
                      border: dark ? Border.all(color: Colors.white, width: 1.5) : null,
                    ),
                    child: const Icon(Icons.notifications_outlined, color: Colors.white, size: 22),
                  ),
                  if (app.notificationCount > 0)
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: CircleAvatar(
                          radius: 7,
                          backgroundColor: AppColors.primaryRed,
                          child: Text('${app.notificationCount}', style: const TextStyle(fontSize: 9, color: Colors.white)),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}