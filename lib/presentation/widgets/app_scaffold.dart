import 'package:flutter/cupertino.dart';
import '../theme/app_colors.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  final ObstructingPreferredSizeWidget? navigationBar;
  final Color? backgroundColor;

  const AppScaffold({
    super.key,
    required this.child,
    this.navigationBar,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;

    return CupertinoPageScaffold(
      navigationBar: navigationBar,
      backgroundColor:
          backgroundColor ??
          (isDark ? AppColors.backgroundDark : AppColors.background),
      child: SafeArea(child: child),
    );
  }
}
