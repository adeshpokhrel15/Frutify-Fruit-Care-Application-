import 'package:flutter/material.dart';
import '../app_theme.dart';

/// Underline-style field used on the "Full Name" onboarding step.
class UnderlineTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hint;

  const UnderlineTextField({super.key, required this.label, required this.controller, this.hint});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.serifHeading(size: 24)),
        const SizedBox(height: 16),
        TextField(
          controller: controller,
          style: AppTextStyles.body(size: 16),
          decoration: InputDecoration(
            hintText: hint,
            border: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primaryRed)),
            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primaryRed)),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primaryRed, width: 2)),
          ),
        ),
      ],
    );
  }
}

/// Filled pink rounded field used across "Add Fruit" / "Care Task" forms.
class FilledAppField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final int maxLines;

  const FilledAppField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.body(size: 14, weight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: AppColors.paleRedCard,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}

/// Filled pink rounded dropdown used for Type / Toxicity / Watering / Recurring etc.
class FilledAppDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const FilledAppDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.body(size: 14, weight: FontWeight.w500)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.paleRedCard,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              hint: const Text('Select'),
              icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.darkGreen),
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
