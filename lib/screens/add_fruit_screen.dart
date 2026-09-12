import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../models/fruit.dart';
import '../state/app_state.dart';
import '../utils/responsive.dart';
import '../widgets/app_text_field.dart';
import '../widgets/primary_button.dart';
import 'home/home_shell.dart';
import 'fruit_detail_screen.dart';

class AddFruitScreen extends StatefulWidget {
  final String? imagePath;
  const AddFruitScreen({super.key, this.imagePath});

  @override
  State<AddFruitScreen> createState() => _AddFruitScreenState();
}

class _AddFruitScreenState extends State<AddFruitScreen> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  String? _type;
  String? _toxicity;
  String? _watering;
  String? _climate;

  bool get _isValid =>
      _nameController.text.trim().isNotEmpty &&
      _type != null &&
      _toxicity != null &&
      _watering != null &&
      _climate != null;

  void _submit() {
    final fruit = Fruit(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      description: _descController.text.trim().isEmpty
          ? 'A lovely $_type fruit that needs $_watering watering.'
          : _descController.text.trim(),
      type: _type!,
      toxicity: _toxicity!,
      watering: _watering!,
      climate: _climate!,
      icon: Icons.eco,
      color: const Color(0xFF6FA469),
      imagePath: widget.imagePath,
    );
    context.read<AppState>().addFruit(fruit);

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (_) => _FruitAddedDialog(fruit: fruit),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Fruit Care Task', style: AppTextStyles.body(size: 17, weight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Responsive.horizontalPadding(context)),
        child: ResponsiveCenter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.imagePath != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(
                    File(widget.imagePath!),
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 18),
              ],
              FilledAppField(label: 'Fruit Name', hint: 'Fruit name here', controller: _nameController),
              const SizedBox(height: 18),
              FilledAppField(label: 'Description', hint: 'Fruit name here', controller: _descController, maxLines: 4),
              const SizedBox(height: 18),
              FilledAppDropdown(
                label: 'Type',
                value: _type,
                items: const ['Tree', 'Shrub', 'Vine', 'Herb'],
                onChanged: (v) => setState(() => _type = v),
              ),
              const SizedBox(height: 18),
              FilledAppDropdown(
                label: 'Toxicity',
                value: _toxicity,
                items: const ['Toxic', 'Not toxic', 'Mildly toxic'],
                onChanged: (v) => setState(() => _toxicity = v),
              ),
              const SizedBox(height: 18),
              FilledAppDropdown(
                label: 'Watering',
                value: _watering,
                items: const ['Low', 'Medium', 'High'],
                onChanged: (v) => setState(() => _watering = v),
              ),
              const SizedBox(height: 18),
              FilledAppDropdown(
                label: 'Climate Condition',
                value: _climate,
                items: const ['Full sun', 'Part sun', 'Shade'],
                onChanged: (v) => setState(() => _climate = v),
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                label: 'Add Fruit',
                color: AppColors.primaryRed,
                onPressed: _isValid ? _submit : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FruitAddedDialog extends StatelessWidget {
  final Fruit fruit;
  const _FruitAddedDialog({required this.fruit});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${fruit.name} Fruit Added !', style: AppTextStyles.serifHeading(size: 18, color: AppColors.darkGreen)),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(45),
              child: fruit.imagePath != null
                  ? Image.file(File(fruit.imagePath!), width: 90, height: 90, fit: BoxFit.cover)
                  : Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(color: fruit.color.withOpacity(0.15), shape: BoxShape.circle),
                      child: Icon(fruit.icon, size: 44, color: fruit.color),
                    ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    label: 'Add Care Task',
                    onPressed: () {
                      Navigator.pop(context); // close dialog
                      Navigator.pop(context); // close add fruit screen
                      Navigator.push(context, MaterialPageRoute(builder: (_) => FruitDetailScreen(fruit: fruit)));
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SecondaryOutlineButton(
                    label: 'View My Fruits',
                    onPressed: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeShell()),
                      (route) => false,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}