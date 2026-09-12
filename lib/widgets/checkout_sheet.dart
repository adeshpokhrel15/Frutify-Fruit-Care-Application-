import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../state/app_state.dart';
import '../widgets/primary_button.dart';

void showCheckoutSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const CheckoutSheet(),
  );
}

enum _PaymentMethod { card, esewa, khalti, cashOnDelivery }

class CheckoutSheet extends StatefulWidget {
  const CheckoutSheet({super.key});

  @override
  State<CheckoutSheet> createState() => _CheckoutSheetState();
}

class _CheckoutSheetState extends State<CheckoutSheet> {
  _PaymentMethod _method = _PaymentMethod.card;
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  bool _processing = false;
  bool _success = false;

  bool get _canPay =>
      _method != _PaymentMethod.card ||
      (_cardNumberController.text.trim().length >= 12 &&
          _expiryController.text.trim().length >= 4 &&
          _cvvController.text.trim().length >= 3);

  Future<void> _pay() async {
    setState(() => _processing = true);
    await Future.delayed(const Duration(seconds: 2)); // simulated payment processing
    if (!mounted) return;
    context.read<AppState>().clearCart();
    setState(() {
      _processing = false;
      _success = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: _success ? _buildSuccess(context) : _buildForm(context, scrollController, app),
        );
      },
    );
  }

  Widget _buildForm(BuildContext context, ScrollController scrollController, AppState app) {
    return ListView(
      controller: scrollController,
      padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).padding.bottom + 24),
      children: [
        Row(
          children: [
            IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
            Expanded(
              child: Text('Checkout', textAlign: TextAlign.center, style: AppTextStyles.serifHeading(size: 20, color: AppColors.darkGreen)),
            ),
            const SizedBox(width: 48),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: AppColors.paleGreenCard, borderRadius: BorderRadius.circular(14)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Order Total', style: AppTextStyles.body(size: 14, weight: FontWeight.w600)),
              Text('\$${app.cartTotal.toStringAsFixed(2)}', style: AppTextStyles.body(size: 16, weight: FontWeight.w700, color: AppColors.darkGreen)),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text('Payment Method', style: AppTextStyles.body(size: 15, weight: FontWeight.w700)),
        const SizedBox(height: 10),
        _PaymentOption(
          label: 'Credit / Debit Card',
          icon: Icons.credit_card,
          selected: _method == _PaymentMethod.card,
          onTap: () => setState(() => _method = _PaymentMethod.card),
        ),
        _PaymentOption(
          label: 'eSewa',
          icon: Icons.account_balance_wallet_outlined,
          selected: _method == _PaymentMethod.esewa,
          onTap: () => setState(() => _method = _PaymentMethod.esewa),
        ),
        _PaymentOption(
          label: 'Khalti',
          icon: Icons.account_balance_wallet_outlined,
          selected: _method == _PaymentMethod.khalti,
          onTap: () => setState(() => _method = _PaymentMethod.khalti),
        ),
        _PaymentOption(
          label: 'Cash on Delivery',
          icon: Icons.local_shipping_outlined,
          selected: _method == _PaymentMethod.cashOnDelivery,
          onTap: () => setState(() => _method = _PaymentMethod.cashOnDelivery),
        ),
        if (_method == _PaymentMethod.card) ...[
          const SizedBox(height: 16),
          TextField(
            controller: _cardNumberController,
            keyboardType: TextInputType.number,
            maxLength: 16,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              labelText: 'Card Number',
              counterText: '',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.credit_card),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _expiryController,
                  keyboardType: TextInputType.number,
                  maxLength: 5,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(labelText: 'MM/YY', counterText: '', border: OutlineInputBorder()),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _cvvController,
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                  obscureText: true,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(labelText: 'CVV', counterText: '', border: OutlineInputBorder()),
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 24),
        PrimaryButton(
          label: _processing ? 'Processing...' : 'Pay \$${app.cartTotal.toStringAsFixed(2)}',
          onPressed: (_processing || !_canPay) ? null : _pay,
        ),
      ],
    );
  }

  Widget _buildSuccess(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: const BoxDecoration(color: AppColors.paleGreenCard, shape: BoxShape.circle),
            child: const Icon(Icons.check_circle, color: AppColors.darkGreen, size: 56),
          ),
          const SizedBox(height: 20),
          Text('Order Placed!', style: AppTextStyles.serifHeading(size: 22, color: AppColors.darkGreen)),
          const SizedBox(height: 8),
          Text(
            'Your fruits are on the way. Thank you for shopping with Fruit Pal.',
            textAlign: TextAlign.center,
            style: AppTextStyles.body(size: 13.5, color: AppColors.textGrey),
          ),
          const SizedBox(height: 24),
          PrimaryButton(label: 'Continue Shopping', onPressed: () => Navigator.pop(context)),
        ],
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _PaymentOption({required this.label, required this.icon, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: selected ? AppColors.primaryRed : AppColors.divider),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: selected ? AppColors.primaryRed : AppColors.textDark),
              const SizedBox(width: 12),
              Expanded(child: Text(label, style: AppTextStyles.body(size: 14, weight: FontWeight.w500))),
              Radio<bool>(value: true, groupValue: selected ? true : null, onChanged: (_) => onTap(), activeColor: AppColors.primaryRed),
            ],
          ),
        ),
      ),
    );
  }
}