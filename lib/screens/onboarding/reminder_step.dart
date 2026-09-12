import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_theme.dart';
import '../../state/app_state.dart';
import '../../utils/responsive.dart';
import '../../widgets/primary_button.dart';

class ReminderStep extends StatelessWidget {
  final VoidCallback onNext;
  const ReminderStep({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Responsive.horizontalPadding(context), vertical: 24),
          child: ResponsiveCenter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Get Reminder', style: AppTextStyles.serifHeading(size: 26)),
                const SizedBox(height: 8),
                Text('Get reminder from your fruits and community.', style: AppTextStyles.body(size: 14, color: AppColors.textGrey)),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            color: AppColors.pinkBg,
            child: Center(
              child: Icon(Icons.notifications_active_outlined, size: 90, color: AppColors.primaryRed.withValues(alpha: 0.6)),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(Responsive.horizontalPadding(context)),
          child: ResponsiveCenter(
            child: PrimaryButton(
              label: 'Enable Reminders',
              onPressed: () {
                context.read<AppState>().setReminders(true);
                onNext();
              },
            ),
          ),
        ),
      ],
    );
  }
}
