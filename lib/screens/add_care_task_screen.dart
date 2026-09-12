import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../models/fruit.dart';
import '../state/app_state.dart';
import '../utils/responsive.dart';
import '../widgets/app_text_field.dart';
import '../widgets/primary_button.dart';

class AddCareTaskScreen extends StatefulWidget {
  final Fruit fruit;
  const AddCareTaskScreen({super.key, required this.fruit});

  @override
  State<AddCareTaskScreen> createState() => _AddCareTaskScreenState();
}

class _AddCareTaskScreenState extends State<AddCareTaskScreen> {
  final _taskController = TextEditingController();
  String? _recurring;

  bool get _isValid => _taskController.text.trim().isNotEmpty && _recurring != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: RichText(
          text: TextSpan(
            style: AppTextStyles.body(size: 17, color: AppColors.textDark, weight: FontWeight.w400),
            children: [
              TextSpan(text: 'Fruits ', style: AppTextStyles.body(size: 17, color: AppColors.textDark, weight: FontWeight.w700)),
              const TextSpan(text: 'Care Task'),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(Responsive.horizontalPadding(context)),
        child: ResponsiveCenter(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FilledAppField(label: 'Task Name', hint: 'Watering', controller: _taskController),
            const SizedBox(height: 18),
            FilledAppDropdown(
              label: 'Recurring',
              value: _recurring,
              items: const ['Daily', 'Weekly', 'Bi-weekly', 'Monthly'],
              onChanged: (v) => setState(() => _recurring = v),
            ),
            const Spacer(),
            PrimaryButton(
              label: 'Save Task',
              onPressed: _isValid
                  ? () {
                      context.read<AppState>().addCareTaskToFruit(
                            widget.fruit.id,
                            CareTask(name: _taskController.text.trim(), recurring: _recurring!),
                          );
                      Navigator.pop(context);
                    }
                  : null,
            ),
            const SizedBox(height: 12),
          ],
          ),
        ),
      ),
    );
  }
}
