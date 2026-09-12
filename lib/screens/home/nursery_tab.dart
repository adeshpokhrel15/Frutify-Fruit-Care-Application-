import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_theme.dart';
import '../../state/app_state.dart';
import '../../utils/responsive.dart';
import '../../widgets/cart_sheet.dart';
import '../../widgets/home_header.dart';

class NurseryTab extends StatefulWidget {
  const NurseryTab({super.key});

  @override
  State<NurseryTab> createState() => _NurseryTabState();
}

class _NurseryTabState extends State<NurseryTab> {
  String _filter = 'All';

  /// Maps a plant's name to its real photo in the `images/` folder.
  /// Falls back to `common_image.png` for anything not listed.
  String _imageForPlant(String name) {
    switch (name) {
      case 'Banana':
        return 'images/banana.PNG';
      case 'Mango':
        return 'images/mango.PNG';
      case 'Watermelon':
        return 'images/watermelon.PNG';
      case 'Papaya':
        return 'images/papaya.PNG';
      default:
        return 'images/common_image.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final plants = _filter == 'All' ? app.nursery : app.nursery.where((p) => p.category.contains(_filter)).toList();

    return SafeArea(
      bottom: false,
      child: Stack(
        children: [
          Column(
            children: [
              const HomeHeader(dark: true),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Responsive.horizontalPadding(context), vertical: 14),
                child: Row(
                  children: ['All', 'Outdoor', 'Indoor'].map((label) {
                    final selected = _filter == label;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ChoiceChip(
                        label: Text(label),
                        selected: selected,
                        onSelected: (_) => setState(() => _filter = label),
                        selectedColor: AppColors.primaryRed,
                        backgroundColor: Colors.white,
                        labelStyle: TextStyle(color: selected ? Colors.white : AppColors.textDark),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: AppColors.divider)),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.fromLTRB(Responsive.horizontalPadding(context), 0, Responsive.horizontalPadding(context), 24),
                  itemCount: plants.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: Responsive.gridColumns(context),
                    mainAxisSpacing: 18,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, i) {
                    final plant = plants[i];
                    return GestureDetector(
                      onTap: () => context.read<AppState>().addToCart(plant),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(
                                _imageForPlant(plant.name),
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: plant.color.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Icon(plant.icon, size: 46, color: plant.color),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(plant.name, style: AppTextStyles.body(size: 14, weight: FontWeight.w600)),
                          Text(plant.category, style: AppTextStyles.body(size: 11, color: AppColors.textGrey)),
                          Text('\$${plant.price.toStringAsFixed(0)}',
                              style: AppTextStyles.body(size: 13, color: AppColors.primaryRed, weight: FontWeight.w600)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned(
            right: 24,
            bottom: 24,
            child: FloatingActionButton(
              heroTag: 'nurseryCartFab',
              backgroundColor: AppColors.darkGreen,
             onPressed: () => showCartSheet(context),
              child: Badge(
                label: Text('${app.cart.length}'),
                isLabelVisible: app.cart.isNotEmpty,
                child: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}