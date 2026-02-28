import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/app_navigation_bar.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_colors.dart';
import '../providers/user_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);

    return AppScaffold(
      navigationBar: const AppNavigationBar(title: 'Profile'),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildUserSection(context, userState, ref),
          const SizedBox(height: 32),
          _buildSyncSettings(context, userState),
          const SizedBox(height: 32),
          _buildAboutSection(context),
        ],
      ),
    );
  }

  Widget _buildUserSection(
    BuildContext context,
    UserState state,
    WidgetRef ref,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CupertinoColors.secondarySystemBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(
            CupertinoIcons.person_crop_circle_fill,
            size: 80,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 16),
          if (state.googleAccount != null) ...[
            Text(
              state.googleAccount!.displayName ?? 'User',
              style: AppTextStyles.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(state.googleAccount!.email, style: AppTextStyles.bodyMedium),
            const SizedBox(height: 24),
            CupertinoButton(
              color: AppColors.error,
              child: const Text('Sign Out'),
              onPressed: () => ref.read(userProvider.notifier).signOut(),
            ),
          ] else ...[
            const Text('Not Signed In', style: AppTextStyles.titleMedium),
            const SizedBox(height: 24),
            CupertinoButton.filled(
              child: const Text('Sign in with Google'),
              onPressed: () => ref.read(userProvider.notifier).signIn(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSyncSettings(BuildContext context, UserState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8, bottom: 8),
          child: Text('CLOUD SYNC', style: AppTextStyles.caption),
        ),
        Container(
          decoration: BoxDecoration(
            color: CupertinoColors.secondarySystemBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildSettingRow(
                'Google Drive',
                CupertinoSwitch(
                  value: state.googleAccount != null,
                  onChanged: (val) {
                    // Logic to enable/disable
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Divider(height: 1, color: CupertinoColors.separator),
              ),
              _buildSettingRow(
                'iCloud (iOS Only)',
                CupertinoSwitch(
                  value: true, // Placeholder
                  onChanged: (val) {},
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingRow(String title, Widget trailing) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.bodyLarge),
          trailing,
        ],
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8, bottom: 8),
          child: Text('ABOUT', style: AppTextStyles.caption),
        ),
        Container(
          decoration: BoxDecoration(
            color: CupertinoColors.secondarySystemBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Version', style: AppTextStyles.bodyLarge),
                    Text('0.1.0', style: AppTextStyles.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Divider extends StatelessWidget {
  final double height;
  final Color color;
  const Divider({super.key, required this.height, required this.color});
  @override
  Widget build(BuildContext context) => Container(height: height, color: color);
}
