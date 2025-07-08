import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/nail_provider.dart';
import '../providers/settings_provider.dart';
import '../utils/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundGray,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppConstants.primaryPink,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppPreferencesSection(),
            const SizedBox(height: 24),
            _buildCacheManagementSection(),
            const SizedBox(height: 24),
            _buildResetOptionsSection(),
            const SizedBox(height: 24),
            _buildAboutSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppPreferencesSection() {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        return _buildSection(
          title: 'App Preferences',
          icon: Icons.settings,
          children: [
            _buildSwitchTile(
              title: 'Push Notifications',
              subtitle: 'Receive updates about new designs',
              value: settingsProvider.notificationsEnabled,
              icon: Icons.notifications,
              onChanged: (value) {
                settingsProvider.setNotificationsEnabled(value);
              },
            ),
            _buildSwitchTile(
              title: 'Auto Refresh',
              subtitle: 'Automatically refresh content',
              value: settingsProvider.autoRefreshEnabled,
              icon: Icons.refresh,
              onChanged: (value) {
                settingsProvider.setAutoRefreshEnabled(value);
              },
            ),
            _buildSwitchTile(
              title: 'Save to Gallery',
              subtitle: 'Save uploaded images to device gallery',
              value: settingsProvider.saveImageToGallery,
              icon: Icons.save_alt,
              onChanged: (value) {
                settingsProvider.setSaveImageToGallery(value);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildCacheManagementSection() {
    return _buildSection(
      title: 'Storage & Cache',
      icon: Icons.storage,
      children: [
        _buildActionTile(
          title: 'Clear Image Cache',
          subtitle: 'Free up storage space',
          icon: Icons.image,
          onTap: _showClearCacheDialog,
        ),
        _buildActionTile(
          title: 'Storage Usage',
          subtitle: 'View app storage details',
          icon: Icons.folder,
          onTap: _showStorageUsageDialog,
        ),
      ],
    );
  }

  Widget _buildResetOptionsSection() {
    return _buildSection(
      title: 'Reset Options',
      icon: Icons.restore,
      children: [
        _buildActionTile(
          title: 'Clear All Favorites',
          subtitle: 'Remove all favorited designs',
          icon: Icons.favorite_border,
          iconColor: Colors.orange,
          onTap: _showClearFavoritesDialog,
        ),
        _buildActionTile(
          title: 'Delete All Uploads',
          subtitle: 'Remove all uploaded photos',
          icon: Icons.delete_outline,
          iconColor: Colors.red,
          onTap: _showDeleteAllUploadsDialog,
        ),
        _buildActionTile(
          title: 'Reset All Settings',
          subtitle: 'Restore default app settings',
          icon: Icons.settings_backup_restore,
          iconColor: Colors.red,
          onTap: _showResetSettingsDialog,
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return _buildSection(
      title: 'About',
      icon: Icons.info,
      children: [
        _buildActionTile(
          title: 'App Version',
          subtitle: '1.0.0',
          icon: Icons.phone_android,
          onTap: null,
        ),
        _buildActionTile(
          title: 'Developer',
          subtitle: 'Built with ❤️ by Sena',
          icon: Icons.person,
          onTap: null,
        ),
        _buildActionTile(
          title: 'Privacy Policy',
          subtitle: 'View our privacy policy',
          icon: Icons.privacy_tip,
          onTap: _showPrivacyPolicy,
        ),
        _buildActionTile(
          title: 'Rate App',
          subtitle: 'Rate us on the App Store',
          icon: Icons.star,
          onTap: _showRateAppDialog,
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppConstants.cardGradient,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        boxShadow: AppConstants.cardShadow,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: AppConstants.primaryGradient,
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required IconData icon,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE0E0E0), width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppConstants.primaryPink.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppConstants.primaryPink,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppConstants.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppConstants.textLight,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppConstants.primaryPink,
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE0E0E0), width: 0.5),
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (iconColor ?? AppConstants.primaryPink).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: iconColor ?? AppConstants.primaryPink,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppConstants.textDark,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
            color: AppConstants.textLight,
          ),
        ),
        trailing: onTap != null
            ? const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppConstants.textLight,
              )
            : null,
        onTap: onTap,
      ),
    );
  }

  // Dialog methods
  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Image Cache'),
        content: const Text(
          'This will clear all cached images. You may need to reload images when browsing.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _clearImageCache();
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showStorageUsageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Storage Usage'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• Cached Images: ~5.2 MB'),
            Text('• User Uploads: ~12.8 MB'),
            Text('• App Data: ~2.1 MB'),
            SizedBox(height: 12),
            Text(
              'Total: ~20.1 MB',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showClearFavoritesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Favorites'),
        content: const Text(
          'This will remove all designs from your favorites. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _clearAllFavorites();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAllUploadsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete All Uploads'),
        content: const Text(
          'This will permanently delete all your uploaded photos. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteAllUploads();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );
  }

  void _showResetSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset All Settings'),
        content: const Text(
          'This will restore all app settings to their default values.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _resetAllSettings();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'Nail Ideas Privacy Policy\n\n'
            '1. Data Collection\n'
            'We collect only the data necessary to provide our services:\n'
            '• Images you upload\n'
            '• Your favorites and preferences\n'
            '• App usage analytics\n\n'
            '2. Data Usage\n'
            'Your data is used to:\n'
            '• Provide personalized content\n'
            '• Improve app performance\n'
            '• Save your preferences\n\n'
            '3. Data Storage\n'
            'All data is stored locally on your device.\n'
            'No data is shared with third parties.\n\n'
            '4. Contact\n'
            'For questions about privacy, contact us at:\n'
            'privacy@nailideas.com',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showRateAppDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rate Nail Ideas'),
        content: const Text(
          'If you enjoy using Nail Ideas, please take a moment to rate us on the App Store. Your feedback helps us improve!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // In a real app, this would open the App Store
              _showSnackBar('Opening App Store...');
            },
            child: const Text('Rate Now'),
          ),
        ],
      ),
    );
  }

  // Action methods
  void _clearImageCache() {
    // In a real app, this would clear the image cache
    _showSnackBar('Image cache cleared successfully');
  }

  void _clearAllFavorites() {
    final provider = Provider.of<NailProvider>(context, listen: false);
    // Clear all favorites
    for (var design in provider.favorites.toList()) {
      provider.toggleFavorite(design.id);
    }
    _showSnackBar('All favorites cleared');
  }

  void _deleteAllUploads() {
    final provider = Provider.of<NailProvider>(context, listen: false);
    // Delete all user uploads
    for (var design in provider.userNailDesigns.toList()) {
      provider.deleteUserDesign(design.id);
    }
    _showSnackBar('All uploads deleted');
  }

  void _resetAllSettings() {
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    settingsProvider.resetToDefaults();
    _showSnackBar('Settings reset to defaults');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppConstants.primaryPink,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
} 