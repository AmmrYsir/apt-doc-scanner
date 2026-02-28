import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/app_navigation_bar.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_colors.dart';
import '../providers/scanner_provider.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scannerState = ref.watch(scannerProvider);

    return AppScaffold(
      navigationBar: AppNavigationBar(
        title: 'Documents',
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.person_circle),
          onPressed: () => context.push('/profile'),
        ),
      ),
      child: Stack(
        children: [
          _buildContent(context, ref),
          if (scannerState.isScanning)
            Container(
              color: CupertinoColors.black.withValues(alpha: 0.3),
              child: const Center(
                child: CupertinoActivityIndicator(radius: 15),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            CupertinoIcons.doc_text_viewfinder,
            size: 100,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 24),
          const Text(
            'No Documents Yet',
            style: AppTextStyles.titleMedium,
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap the scan button to start digitizing',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 40),
          CupertinoButton.filled(
            child: const Text('Start Scanning'),
            onPressed: () async {
              final images =
                  await ref.read(scannerProvider.notifier).scanDocument();
              if (images != null && images.isNotEmpty) {
                if (context.mounted) {
                  _showScanSuccess(context, images.length);
                }
              }
            },
          ),
        ],
      ),
    );
  }

  void _showScanSuccess(BuildContext context, int count) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Scan Complete'),
        content: Text('Successfully scanned $count pages.'),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
