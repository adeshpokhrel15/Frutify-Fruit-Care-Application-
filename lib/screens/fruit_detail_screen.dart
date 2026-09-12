import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../models/fruit.dart';
import '../state/app_state.dart';
import '../utils/responsive.dart';
import '../widgets/primary_button.dart';
import 'add_care_task_screen.dart';

class FruitDetailScreen extends StatelessWidget {
  final Fruit fruit;
  const FruitDetailScreen({super.key, required this.fruit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<AppState>(
          builder: (context, app, _) {
            // Re-fetch the latest fruit instance (tasks may have changed).
            final current = app.myFruits.firstWhere((f) => f.id == fruit.id, orElse: () => fruit);
            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      current.imagePath != null
                          ? Image.file(
                              File(current.imagePath!),
                              height: 230,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _fallbackHero(current),
                            )
                          : _fallbackHero(current),
                      Positioned(
                        top: 12,
                        left: 16,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(Responsive.horizontalPadding(context), 20, Responsive.horizontalPadding(context), 0),
                    child: ResponsiveCenter(
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${current.name} Tree', style: AppTextStyles.serifHeading(size: 24, color: AppColors.darkGreen)),
                        const SizedBox(height: 14),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _Tag(icon: Icons.terrain, label: current.watering == 'Low' ? 'Easy' : 'Moderate'),
                              _Tag(icon: Icons.home_outlined, label: current.climate),
                              _Tag(icon: Icons.favorite_border, label: current.toxicity),
                              _Tag(icon: Icons.water_drop_outlined, label: current.watering),
                              _Tag(icon: Icons.wb_sunny_outlined, label: current.type),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        _InfoCard(
                          icon: Icons.eco,
                          title: 'Description',
                          child: Text(current.description, style: AppTextStyles.body(size: 13.5, color: AppColors.textGrey)),
                        ),
                        const SizedBox(height: 16),
                        _InfoCard(
                          icon: Icons.autorenew,
                          title: 'Task',
                          child: current.tasks.isEmpty
                              ? Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: AppColors.divider),
                                  ),
                                  child: Text('NO TASK FOR THIS WEEK', style: AppTextStyles.body(size: 11, weight: FontWeight.w600)),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: current.tasks
                                      .map((t) => Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 4),
                                            child: Row(
                                              children: [
                                                const Icon(Icons.check_circle_outline, size: 16, color: AppColors.darkGreen),
                                                const SizedBox(width: 8),
                                                Text('${t.name} — ${t.recurring}', style: AppTextStyles.body(size: 13)),
                                              ],
                                            ),
                                          ))
                                      .toList(),
                                ),
                        ),
                        const SizedBox(height: 28),
                        PrimaryButton(
                          label: 'Add Care Task For This Week',
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => AddCareTaskScreen(fruit: current)),
                          ),
                        ),
                      ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _fallbackHero(Fruit fruit) {
    return Container(
      height: 230,
      width: double.infinity,
      decoration: BoxDecoration(color: fruit.color.withOpacity(0.25)),
      child: Icon(fruit.icon, size: 100, color: fruit.color),
    );
  }
}

class _Tag extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Tag({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: AppColors.paleGreenCard, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Icon(icon, size: 18, color: AppColors.darkGreen),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.body(size: 11, color: AppColors.darkGreen)),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;
  const _InfoCard({required this.icon, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.paleGreenCard, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 14, backgroundColor: AppColors.darkGreen, child: Icon(icon, size: 15, color: Colors.white)),
              const SizedBox(width: 10),
              Text(title, style: AppTextStyles.body(size: 14, weight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}