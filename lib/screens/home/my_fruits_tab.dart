import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_theme.dart';
import '../../models/fruit.dart';
import '../../state/app_state.dart';
import '../../utils/responsive.dart';
import '../../widgets/home_header.dart';
import '../../widgets/primary_button.dart';
import '../fruit_detail_screen.dart';
import '../scanner_screen.dart';

/// Static "Today's facts" content — one entry per fruit, shown as a
/// horizontally scrollable row of cards on the home page.
class _FruitFact {
  final String name;
  final String imageAsset;
  final String summary;
  final String description;
  final List<String> facts;

  const _FruitFact({
    required this.name,
    required this.imageAsset,
    required this.summary,
    required this.description,
    required this.facts,
  });
}

const List<_FruitFact> _fruitFacts = [
  _FruitFact(
    name: 'Apple',
    imageAsset: 'images/apple.PNG',
    summary: 'An apple is good fruit but protected with sweetness. Smell amazing with health benefit....',
    description:
        'An apple is the round, edible fruit of an apple tree. Fruit trees of the orchard or domestic apple, the most widely grown in the genus, are cultivated worldwide.',
    facts: [
      'They make excellent companion fruits and herbs. 🌿',
      'The buds are egg-shaped and dark red or purple in color; they range in size from 3 to 5mm.',
      'Regular watering and full sun exposure will keep your apple tree healthy through every season.',
    ],
  ),
  _FruitFact(
    name: 'Banana',
    imageAsset: 'images/banana.PNG',
    summary: 'Bananas grow in clusters called hands, and each individual banana is called a finger....',
    description:
        'The banana plant is technically a giant herb, not a tree — its "trunk" is made of tightly packed leaf sheaths rather than wood.',
    facts: [
      'A bunch of bananas is called a "hand," and each individual banana is a "finger." 🍌',
      'Banana plants can grow up to 6 meters tall in just one growing season.',
      'They thrive in warm, humid climates with consistent watering and rich, well-drained soil.',
    ],
  ),
  _FruitFact(
    name: 'Mango',
    imageAsset: 'images/mango.PNG',
    summary: 'Known as the "king of fruits," mango trees can live and bear fruit for over 300 years....',
    description: 'Mango trees are evergreens native to South Asia, prized for their long lifespan and generous, fragrant harvests.',
    facts: [
      'A single mango tree can produce fruit for over 300 years if well cared for. 🥭',
      'Mangoes are related to cashews and pistachios — all part of the same plant family.',
      'They need full sun and a warm climate, with deep but infrequent watering once established.',
    ],
  ),
  _FruitFact(
    name: 'Watermelon',
    imageAsset: 'images/watermelon.PNG',
    summary: 'Watermelon is about 92% water, making it one of the most hydrating fruits you can grow....',
    description:
        'Watermelon vines sprawl along the ground and need plenty of space, sun, and consistent moisture to produce their signature sweet, juicy fruit.',
    facts: [
      'Watermelon is roughly 92% water — seriously hydrating. 💧',
      'Every part of the watermelon is edible, including the rind and seeds.',
      'Vines need full sun and steady watering, especially while the fruit is forming.',
    ],
  ),
  _FruitFact(
    name: 'Papaya',
    imageAsset: 'images/papaya.PNG',
    summary: 'Papaya trees can start producing fruit in as little as 6 to 9 months after planting....',
    description: 'Papaya is a fast-growing tropical plant that rewards patience with a rich source of vitamin C and a naturally sweet, soft flesh.',
    facts: [
      'Papaya trees can fruit within 6–9 months of planting — remarkably fast for a fruit tree. 🌴',
      'Unripe green papaya is often cooked and used in savory dishes across Southeast Asia.',
      'They prefer warm weather, full sun, and soil that drains well to avoid root rot.',
    ],
  ),
];

void _showFactSheet(BuildContext context, _FruitFact fact) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
            children: [
              Row(
                children: [
                  Expanded(child: Text(fact.name, style: AppTextStyles.serifHeading(size: 22, color: AppColors.darkGreen))),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  fact.imageAsset,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: double.infinity,
                    height: 180,
                    color: AppColors.paleRedCard,
                    alignment: Alignment.center,
                    child: const Icon(Icons.eco, size: 48, color: AppColors.primaryRed),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(fact.description, style: AppTextStyles.body(size: 14, color: AppColors.textGrey)),
              const SizedBox(height: 20),
              Text('Facts :', style: AppTextStyles.body(size: 15, weight: FontWeight.w700, color: AppColors.darkGreen)),
              const SizedBox(height: 10),
              ...fact.facts.map(
                (f) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('•  '),
                      Expanded(child: Text(f, style: AppTextStyles.body(size: 13.5))),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

class MyFruitsTab extends StatelessWidget {
  const MyFruitsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final hPad = Responsive.horizontalPadding(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'myFruitsScannerFab',
        backgroundColor: AppColors.primaryRed,
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ScannerScreen())),
        child: const Icon(Icons.camera_alt_outlined, color: Colors.white),
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeHeader(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: hPad),
                child: Text("Today's facts", style: AppTextStyles.body(size: 15, weight: FontWeight.w600)),
              ),
              const SizedBox(height: 12),
              // Horizontally scrollable row — swipe left/right to see more fruits.
              SizedBox(
                height: 118,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: hPad),
                  itemCount: _fruitFacts.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, i) => _FactCard(fact: _fruitFacts[i]),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 420),
                decoration: const BoxDecoration(color: AppColors.pinkBg),
                padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 20),
                child: ResponsiveCenter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('My fruits', style: AppTextStyles.body(size: 15, weight: FontWeight.w600)),
                      const SizedBox(height: 12),
                      if (app.myFruits.isEmpty) const _EmptyFruits() else _FruitsList(fruits: app.myFruits),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FactCard extends StatelessWidget {
  final _FruitFact fact;
  const _FactCard({required this.fact});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => _showFactSheet(context, fact),
      child: Container(
        width: 260,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(4, 5))],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                fact.imageAsset,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 56,
                  height: 56,
                  color: AppColors.paleRedCard,
                  child: const Icon(Icons.eco, color: AppColors.primaryRed),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(fact.name, style: AppTextStyles.body(size: 15, weight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(
                    fact.summary,
                    style: AppTextStyles.body(size: 12, color: AppColors.textGrey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Continue Reading', style: AppTextStyles.body(size: 11.5, color: const Color(0xFFF7941D), weight: FontWeight.w600)),
                      const Icon(Icons.chevron_right, size: 16, color: Color(0xFFF7941D)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyFruits extends StatelessWidget {
  const _EmptyFruits();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        Icon(Icons.eco_outlined, size: 130, color: const Color(0xFFF7941D).withOpacity(0.25)),
        const SizedBox(height: 16),
        Text(
          'No fruits added yet, continue\nadding to see them here',
          textAlign: TextAlign.center,
          style: AppTextStyles.serifHeading(size: 15, color: AppColors.textDark, weight: FontWeight.w500),
        ),
        const SizedBox(height: 20),
        PrimaryButton(
          label: 'Add Fruits',
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ScannerScreen())),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _FruitsList extends StatelessWidget {
  final List<Fruit> fruits;
  const _FruitsList({required this.fruits});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...fruits.map((fruit) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FruitDetailScreen(fruit: fruit))),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(26),
                      child: fruit.imagePath != null
                          ? Image.file(
                              File(fruit.imagePath!),
                              width: 52,
                              height: 52,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _fallbackAvatar(fruit),
                            )
                          : _fallbackAvatar(fruit),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(fruit.name, style: AppTextStyles.body(size: 15, weight: FontWeight.w600)),
                          Text(fruit.status, style: AppTextStyles.body(size: 12, color: AppColors.textGrey)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: AppColors.darkGreen),
                  ],
                ),
              ),
            )),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ScannerScreen())),
            icon: const Icon(Icons.add, color: AppColors.darkGreen),
            label: Text('Add more', style: AppTextStyles.body(color: AppColors.darkGreen, weight: FontWeight.w600)),
          ),
        ),
      ],
    );
  }

  Widget _fallbackAvatar(Fruit fruit) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(color: fruit.color, shape: BoxShape.circle),
      child: Icon(fruit.icon, color: Colors.white),
    );
  }
}