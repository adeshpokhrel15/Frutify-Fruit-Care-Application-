import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../utils/responsive.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';

class NameStep extends StatefulWidget {
  final VoidCallback onNext;
  const NameStep({super.key, required this.onNext});

  @override
  State<NameStep> createState() => _NameStepState();
}

class _NameStepState extends State<NameStep> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = context.read<AppState>().userName;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Responsive.horizontalPadding(context), vertical: 24),
      child: ResponsiveCenter(
        child: Column(
        children: [
          UnderlineTextField(label: 'Full Name', controller: _controller, hint: 'Enter your name'),
          const Spacer(),
          PrimaryButton(
            label: 'Next',
            onPressed: () {
              if (_controller.text.trim().isNotEmpty) {
                context.read<AppState>().setUserName(_controller.text.trim());
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
