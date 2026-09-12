import 'package:flutter/material.dart';

/// Simple, dependency-free responsiveness helpers so the same screens work
/// well on small phones, large phones, tablets, foldables, and desktop/web
/// (Flutter apps can run on all of these) without a separate codebase.
class Responsive {
  Responsive._();

  static const double _tabletBreakpoint = 700;
  static const double _desktopBreakpoint = 1100;

  static bool isTablet(BuildContext context) => MediaQuery.of(context).size.width >= _tabletBreakpoint;

  static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= _desktopBreakpoint;

  /// Content max-width so text/forms don't stretch edge-to-edge and become
  /// hard to read on tablets or desktop browsers.
  static double maxContentWidth(BuildContext context) {
    if (isDesktop(context)) return 480;
    if (isTablet(context)) return 560;
    return double.infinity;
  }

  /// How many columns the nursery/plant grids should use.
  static int gridColumns(BuildContext context) {
    if (isDesktop(context)) return 4;
    if (isTablet(context)) return 3;
    return 2;
  }

  /// Horizontal page padding that grows slightly on bigger screens.
  static double horizontalPadding(BuildContext context) {
    if (isDesktop(context)) return 48;
    if (isTablet(context)) return 32;
    return 24;
  }
}

/// Wraps a screen's scrollable content so it's centered with a sensible max
/// width on tablets/desktop, while staying full-width on phones.
class ResponsiveCenter extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const ResponsiveCenter({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: Responsive.maxContentWidth(context)),
        child: Padding(padding: padding ?? EdgeInsets.zero, child: child),
      ),
    );
  }
}
