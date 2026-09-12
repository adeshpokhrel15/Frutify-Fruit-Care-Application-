import 'package:flutter/material.dart';
import 'package:fruitify/widgets/checkout_sheet.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../models/fruit.dart';
import '../state/app_state.dart';
import '../widgets/primary_button.dart';

void showCartSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const CartSheet(),
  );
}

class CartSheet extends StatelessWidget {
  const CartSheet({super.key});

  List<MapEntry<NurseryPlant, int>> _grouped(List<NurseryPlant> cart) {
    final Map<String, int> counts = {};
    final Map<String, NurseryPlant> plants = {};
    for (final p in cart) {
      final key = '${p.name}|${p.category}';
      counts[key] = (counts[key] ?? 0) + 1;
      plants[key] = p;
    }
    return counts.entries.map((e) => MapEntry(plants[e.key]!, e.value)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final items = _grouped(app.cart);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
                child: Row(
                  children: [
                    Expanded(child: Text('My Cart', style: AppTextStyles.serifHeading(size: 20, color: AppColors.darkGreen))),
                    IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                  ],
                ),
              ),
              Expanded(
                child: items.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.shopping_cart_outlined, size: 56, color: AppColors.paleRedCard),
                            const SizedBox(height: 12),
                            Text('Your cart is empty', style: AppTextStyles.body(color: AppColors.textGrey)),
                          ],
                        ),
                      )
                    : ListView.separated(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const Divider(height: 24),
                        itemBuilder: (context, i) {
                          final plant = items[i].key;
                          final qty = items[i].value;
                          return Row(
                            children: [
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(color: plant.color.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                                child: Icon(plant.icon, color: plant.color),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(plant.name, style: AppTextStyles.body(size: 14.5, weight: FontWeight.w600)),
                                    Text(plant.category, style: AppTextStyles.body(size: 11.5, color: AppColors.textGrey)),
                                    Text(
                                      '\$${plant.price.toStringAsFixed(0)}',
                                      style: AppTextStyles.body(size: 13, color: AppColors.primaryRed, weight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                              _QtyStepper(
                                qty: qty,
                                onDecrement: () => context.read<AppState>().decrementCartItem(plant),
                                onIncrement: () => context.read<AppState>().incrementCartItem(plant),
                              ),
                            ],
                          );
                        },
                      ),
              ),
              if (items.isNotEmpty)
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).padding.bottom + 16),
                  child: Column(
                    children: [
                      _SummaryRow(label: 'Subtotal', value: app.cartSubtotal),
                      _SummaryRow(label: 'Delivery Fee', value: app.deliveryFee),
                      const Divider(height: 20),
                      _SummaryRow(label: 'Total', value: app.cartTotal, bold: true),
                      const SizedBox(height: 16),
                      PrimaryButton(
                        label: 'Proceed to Checkout',
                        onPressed: () {
                          Navigator.pop(context);
                          showCheckoutSheet(context);
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _QtyStepper extends StatelessWidget {
  final int qty;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  const _QtyStepper({required this.qty, required this.onIncrement, required this.onDecrement});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StepperButton(icon: Icons.remove, onTap: onDecrement),
        SizedBox(width: 28, child: Center(child: Text('$qty', style: AppTextStyles.body(size: 14, weight: FontWeight.w600)))),
        _StepperButton(icon: Icons.add, onTap: onIncrement),
      ],
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _StepperButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(color: AppColors.paleGreenCard, borderRadius: BorderRadius.circular(20)),
        child: Icon(icon, size: 16, color: AppColors.darkGreen),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final double value;
  final bool bold;
  const _SummaryRow({required this.label, required this.value, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.body(
              size: bold ? 15 : 13.5,
              weight: bold ? FontWeight.w700 : FontWeight.normal,
              color: bold ? AppColors.textDark : AppColors.textGrey,
            ),
          ),
          Text(
            '\$${value.toStringAsFixed(2)}',
            style: AppTextStyles.body(
              size: bold ? 15 : 13.5,
              weight: bold ? FontWeight.w700 : FontWeight.w600,
              color: bold ? AppColors.primaryRed : AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}