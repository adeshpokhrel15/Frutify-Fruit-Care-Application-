import 'package:flutter/material.dart';
import '../../app_theme.dart';
import 'my_fruits_tab.dart';
import 'community_tab.dart';
import 'nursery_tab.dart';
import 'profile_tab.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  final _tabs = const [
    MyFruitsTab(),
    CommunityTab(),
    NurseryTab(),
    ProfileTab(),
  ];

  final _items = const [
    {'icon': Icons.eco, 'label': 'My Fruits'},
    {'icon': Icons.groups_outlined, 'label': 'Community'},
    {'icon': Icons.storefront_outlined, 'label': 'Nursery'},
    {'icon': Icons.person_outline, 'label': 'Profile'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: AppColors.divider)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (i) {
              final selected = i == _index;
              final icon = _items[i]['icon'] as IconData;
              final label = _items[i]['label'] as String;
              return InkWell(
                onTap: () => setState(() => _index = i),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.paleGreenCard : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: 22, color: selected ? AppColors.darkGreen : AppColors.textGrey),
                      const SizedBox(height: 4),
                      Text(
                        label,
                        style: AppTextStyles.body(
                          size: 11,
                          color: selected ? AppColors.darkGreen : AppColors.textGrey,
                          weight: selected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
