import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_theme.dart';
import '../../state/app_state.dart';
import '../../utils/responsive.dart';
import '../../widgets/primary_button.dart';

class LocationStep extends StatelessWidget {
  final VoidCallback onNext;
  const LocationStep({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Responsive.horizontalPadding(context), vertical: 24),
      child: ResponsiveCenter(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your Location', style: AppTextStyles.serifHeading(size: 26)),
          const SizedBox(height: 8),
          Text('For personalized instruction and cure we need your location.',
              style: AppTextStyles.body(size: 14, color: AppColors.textGrey)),
          const Spacer(),
          Center(
            child: Icon(Icons.location_on, size: 100, color: AppColors.primaryRed),
          ),
          const Spacer(),
          PrimaryButton(
            label: 'Add Your Location',
            onPressed: () {
              context.read<AppState>().setLocation('Kathmandu, Nepal');
              onNext();
            },
          ),
        ],
        ),
      ),
    );
  }
}
