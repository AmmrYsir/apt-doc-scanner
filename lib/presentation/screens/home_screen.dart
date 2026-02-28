import 'package:flutter/cupertino.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/app_navigation_bar.dart';
import '../theme/app_text_styles.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      navigationBar: AppNavigationBar(
        title: 'Documents',
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.person_circle),
          onPressed: () => context.push('/profile'),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No Documents Yet', style: AppTextStyles.titleMedium),
            const SizedBox(height: 8),
            const Text(
              'Tap the scan button to start',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 32),
            CupertinoButton.filled(
              child: const Text('Start Scanning'),
              onPressed: () {
                // TODO: Implement scanner
              },
            ),
          ],
        ),
      ),
    );
  }
}
