import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // User Profile Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage:
                        authState.user?.userMetadata?['avatar_url'] != null
                        ? NetworkImage(
                            authState.user!.userMetadata!['avatar_url'],
                          )
                        : null,
                    backgroundColor: theme.colorScheme.primary,
                    child: authState.user?.userMetadata?['avatar_url'] == null
                        ? Text(
                            authState.user?.userMetadata?['full_name']
                                    ?.substring(0, 1)
                                    .toUpperCase() ??
                                authState.user?.email
                                    ?.substring(0, 1)
                                    .toUpperCase() ??
                                'U',
                            style: TextStyle(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          authState.user?.userMetadata?['full_name'] ??
                              authState.user?.email ??
                              'Unknown User',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          authState.user?.email ?? 'No email available',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Settings Options
            _buildSettingsTile(
              context,
              icon: Icons.account_circle_outlined,
              title: 'Account Settings',
              subtitle: 'Manage your account information',
              onTap: () {
                // TODO: Implement account settings
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Account settings coming soon')),
                );
              },
            ),

            _buildSettingsTile(
              context,
              icon: Icons.mic_outlined,
              title: 'Voice Settings',
              subtitle: 'Customize voice assistant preferences',
              onTap: () {
                // TODO: Implement voice settings
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Voice settings coming soon')),
                );
              },
            ),

            _buildSettingsTile(
              context,
              icon: Icons.email_outlined,
              title: 'Email Integration',
              subtitle: 'Connect and manage email accounts',
              onTap: () {
                // TODO: Implement email integration
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Email integration coming soon'),
                  ),
                );
              },
            ),

            _buildSettingsTile(
              context,
              icon: Icons.calendar_today_outlined,
              title: 'Calendar Integration',
              subtitle: 'Connect and manage calendar accounts',
              onTap: () {
                // TODO: Implement calendar integration
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Calendar integration coming soon'),
                  ),
                );
              },
            ),

            _buildSettingsTile(
              context,
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy & Security',
              subtitle: 'Data protection and privacy settings',
              onTap: () {
                // TODO: Implement privacy settings
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Privacy settings coming soon')),
                );
              },
            ),

            _buildSettingsTile(
              context,
              icon: Icons.help_outline,
              title: 'Help & Support',
              subtitle: 'Get help and contact support',
              onTap: () {
                // TODO: Implement help & support
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Help & support coming soon')),
                );
              },
            ),

            const Spacer(),

            // Sign Out Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final shouldSignOut = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Sign Out'),
                      content: const Text('Are you sure you want to sign out?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Sign Out'),
                        ),
                      ],
                    ),
                  );

                  if (shouldSignOut == true) {
                    await ref.read(authProvider.notifier).signOut();
                    if (context.mounted) {
                      Navigator.of(
                        context,
                      ).pushNamedAndRemoveUntil('/auth', (route) => false);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.error,
                  foregroundColor: theme.colorScheme.onError,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                icon: const Icon(Icons.logout),
                label: const Text(
                  'Sign Out',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // App Version
            Text(
              'Jarwik AI Assistant v1.0.0',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: theme.colorScheme.onSurface.withOpacity(0.4),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: theme.colorScheme.surfaceContainer.withOpacity(0.5),
      ),
    );
  }
}
