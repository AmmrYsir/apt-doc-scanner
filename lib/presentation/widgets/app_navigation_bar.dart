import 'package:flutter/cupertino.dart';
import '../theme/app_text_styles.dart';

class AppNavigationBar extends StatelessWidget
    implements ObstructingPreferredSizeWidget {
  final String title;
  final Widget? trailing;
  final Widget? leading;

  const AppNavigationBar({
    super.key,
    required this.title,
    this.trailing,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoNavigationBar(
      middle: Text(title, style: AppTextStyles.titleMedium),
      trailing: trailing,
      leading: leading,
      border: null,
      backgroundColor: CupertinoColors.systemBackground.withValues(alpha: 0.8),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(44);

  @override
  bool shouldFullyObstruct(BuildContext context) => true;
}
