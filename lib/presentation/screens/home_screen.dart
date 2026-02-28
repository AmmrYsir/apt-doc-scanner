import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/app_navigation_bar.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_colors.dart';
import '../providers/scanner_provider.dart';
import '../providers/document_provider.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scannerState = ref.watch(scannerProvider);
    final documents = ref.watch(documentListProvider);

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
          documents.isEmpty
              ? _buildEmptyState(context, ref)
              : _buildDocumentList(context, ref, documents),
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

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
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
          const Text('No Documents Yet', style: AppTextStyles.titleMedium),
          const SizedBox(height: 8),
          const Text(
            'Tap the scan button to start digitizing',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 40),
          CupertinoButton.filled(
            child: const Text('Start Scanning'),
            onPressed: () => _startScan(context, ref),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentList(
    BuildContext context,
    WidgetRef ref,
    List<dynamic> documents,
  ) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final doc = documents[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: CupertinoColors.secondarySystemBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 80,
                      decoration: BoxDecoration(
                        color: CupertinoColors.inactiveGray,
                        borderRadius: BorderRadius.circular(8),
                        image: doc.imagePaths.isNotEmpty
                            ? DecorationImage(
                                image: FileImage(File(doc.imagePaths.first)),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(doc.name, style: AppTextStyles.bodyLarge),
                          const SizedBox(height: 4),
                          Text(
                            'Scanned on ${doc.createdAt.toString().split(' ')[0]}',
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                    ),
                    const Icon(CupertinoIcons.chevron_right, size: 16),
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: CupertinoButton.filled(
            child: const Text('Scan New Document'),
            onPressed: () => _startScan(context, ref),
          ),
        ),
      ],
    );
  }

  Future<void> _startScan(BuildContext context, WidgetRef ref) async {
    print('DEBUG: HomeScreen _startScan() triggered');
    final images = await ref.read(scannerProvider.notifier).scanDocument();
    print('DEBUG: HomeScreen received images: ${images?.length ?? 0}');
    if (images != null && images.isNotEmpty) {
      final name = 'Document ${DateTime.now().millisecondsSinceEpoch}';
      print('DEBUG: Requesting addDocument for: $name');
      await ref.read(documentListProvider.notifier).addDocument(name, images);
      print('DEBUG: addDocument call finished in HomeScreen');
      if (context.mounted) {
        _showScanSuccess(context, images.length);
      }
    } else {
      print('DEBUG: No images returned from scanner.');
    }
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
