import 'package:flutter/cupertino.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/app_navigation_bar.dart';
import '../theme/app_text_styles.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      navigationBar: AppNavigationBar(title: 'Profile'),
      child: Center(
        child: Text('User Profile', style: AppTextStyles.titleMedium),
      ),
    );
  }
}
