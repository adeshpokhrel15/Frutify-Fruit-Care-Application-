import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_theme.dart';
import '../../state/app_state.dart';
import '../../utils/responsive.dart';
import '../../widgets/primary_button.dart';

class PriorityStep extends StatefulWidget {
  final VoidCallback onNext;
  const PriorityStep({super.key, required this.onNext});

  @override
  State<PriorityStep> createState() => _PriorityStepState();
}

class _PriorityStepState extends State<PriorityStep> {
  String? _selected;

  static const options = [
    {'label': 'Fruits Care', 'icon': Icons.eco_outlined},
    {'label': 'Fruits Lover Community', 'icon': Icons.extension_outlined},
    {'label': 'Fruits Marketplace', 'icon': Icons.shopping_bag_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Responsive.horizontalPadding(context), vertical: 24),
      child: ResponsiveCenter(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Top Priority', style: AppTextStyles.serifHeading(size: 26)),
          const SizedBox(height: 8),
          Text('Choose the feature that is most essential for you.', style: AppTextStyles.body(size: 14, color: AppColors.textGrey)),
          const SizedBox(height: 24),
          ...options.map((o) {
            final label = o['label'] as String;
            final icon = o['icon'] as IconData;
            final selected = _selected == label;
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => setState(() => _selected = label),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: selected ? AppColors.primaryRed : AppColors.divider),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Icon(icon, size: 22, color: AppColors.textDark),
                      const SizedBox(width: 14),
                      Expanded(child: Text(label, style: AppTextStyles.body(size: 15, weight: FontWeight.w500))),
                      Radio<String>(
                        value: label,
                        groupValue: _selected,
                        activeColor: AppColors.primaryRed,
                        onChanged: (v) => setState(() => _selected = v),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          const Spacer(),
          PrimaryButton(
            label: 'Next',
            onPressed: () {
              if (_selected != null) {
                context.read<AppState>().setPriority(_selected!);
              }
              widget.onNext();
            },
          ),
        ],
        ),
      ),
    );
  }
}
