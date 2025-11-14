import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:daliconverter/controllers/theme_controller.dart';
import 'package:daliconverter/controllers/settings_controller.dart';
import 'package:daliconverter/controllers/history_controller.dart';
import 'package:daliconverter/utils/app_theme.dart';
import 'privacy_policy_screen.dart';
import 'terms_of_use_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final settingsController = Get.put(SettingsController());
    final historyController = Get.find<HistoryController>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),

            // Settings List
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(3.w),
                child: Column(
                  children: [
                    _buildSettingsCard(
                      context,
                      [
                        // Theme Toggle
                        Obx(() => ListTile(
                              leading: Icon(
                                themeController.isDarkMode
                                    ? Icons.light_mode
                                    : Icons.dark_mode,
                                color: AppTheme.getPrimaryColor(context),
                                size: 6.w,
                              ),
                              title: Text(
                                'Theme',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.getTextPrimaryColor(context),
                                ),
                              ),
                              subtitle: Text(
                                themeController.isDarkMode
                                    ? 'Dark Mode'
                                    : 'Light Mode',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color:
                                      AppTheme.getTextSecondaryColor(context),
                                ),
                              ),
                              trailing: Switch(
                                value: themeController.isDarkMode,
                                onChanged: (_) => themeController.toggleTheme(),
                                activeColor: AppTheme.getPrimaryColor(context),
                              ),
                            )),

                        const Divider(height: 1),

                        // Clear History
                        Obx(() => ListTile(
                              leading: Icon(
                                Icons.history,
                                color: AppTheme.getPrimaryColor(context),
                                size: 6.w,
                              ),
                              title: Text(
                                'Clear History',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.getTextPrimaryColor(context),
                                ),
                              ),
                              subtitle: Text(
                                '${historyController.history.length} conversions saved',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color:
                                      AppTheme.getTextSecondaryColor(context),
                                ),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                color: AppTheme.getTextSecondaryColor(context),
                                size: 4.w,
                              ),
                              onTap: () => _showClearHistoryDialog(
                                  context, historyController),
                            )),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    _buildSettingsCard(
                      context,
                      [
                        // Privacy Policy
                        ListTile(
                          leading: Icon(
                            Icons.privacy_tip,
                            color: AppTheme.getPrimaryColor(context),
                            size: 6.w,
                          ),
                          title: Text(
                            'Privacy Policy',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.getTextPrimaryColor(context),
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: AppTheme.getTextSecondaryColor(context),
                            size: 4.w,
                          ),
                          onTap: () =>
                              Get.to(() => const PrivacyPolicyScreen()),
                        ),

                        const Divider(height: 1),

                        // Terms of Use
                        ListTile(
                          leading: Icon(
                            Icons.description,
                            color: AppTheme.getPrimaryColor(context),
                            size: 6.w,
                          ),
                          title: Text(
                            'Terms of Use',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.getTextPrimaryColor(context),
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: AppTheme.getTextSecondaryColor(context),
                            size: 4.w,
                          ),
                          onTap: () => Get.to(() => const TermsOfUseScreen()),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    _buildSettingsCard(
                      context,
                      [
                        // Contact Us
                        ListTile(
                          leading: Icon(
                            Icons.email,
                            color: AppTheme.getPrimaryColor(context),
                            size: 6.w,
                          ),
                          title: Text(
                            'Contact Us',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.getTextPrimaryColor(context),
                            ),
                          ),
                          subtitle: Text(
                            'Send us your feedback',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppTheme.getTextSecondaryColor(context),
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: AppTheme.getTextSecondaryColor(context),
                            size: 4.w,
                          ),
                          onTap: settingsController.contactUs,
                        ),

                        const Divider(height: 1),

                        // Share App
                        ListTile(
                          leading: Icon(
                            Icons.share,
                            color: AppTheme.getPrimaryColor(context),
                            size: 6.w,
                          ),
                          title: Text(
                            'Share App',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.getTextPrimaryColor(context),
                            ),
                          ),
                          subtitle: Text(
                            'Share with friends',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppTheme.getTextSecondaryColor(context),
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: AppTheme.getTextSecondaryColor(context),
                            size: 4.w,
                          ),
                          onTap: settingsController.shareApp,
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    _buildSettingsCard(
                      context,
                      [
                        // About App
                        ListTile(
                          leading: Icon(
                            Icons.info,
                            color: AppTheme.getPrimaryColor(context),
                            size: 6.w,
                          ),
                          title: Text(
                            'About App',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.getTextPrimaryColor(context),
                            ),
                          ),
                          subtitle: Obx(() => Text(
                                settingsController.isLoading
                                    ? 'Loading...'
                                    : settingsController.appInfo,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color:
                                      AppTheme.getTextSecondaryColor(context),
                                ),
                              )),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: AppTheme.getTextSecondaryColor(context),
                            size: 4.w,
                          ),
                          onTap: () =>
                              _showAboutDialog(context, settingsController),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.w),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.getPrimaryColor(context),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.settings,
              color: Colors.white,
              size: 6.w,
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            'Settings',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.getTextPrimaryColor(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context, List<Widget> children) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }

  void _showClearHistoryDialog(
      BuildContext context, HistoryController historyController) {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Clear History',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.getTextPrimaryColor(context),
          ),
        ),
        content: Text(
          'Are you sure you want to clear all conversion history? This action cannot be undone.',
          style: TextStyle(
            fontSize: 11.sp,
            color: AppTheme.getTextSecondaryColor(context),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: AppTheme.getTextSecondaryColor(context),
                fontSize: 10.sp,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              historyController.clearAllHistory();
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text(
              'Clear',
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(
      BuildContext context, SettingsController settingsController) {
    Get.dialog(
      AlertDialog(
        title: Text(
          'About Instant Converter',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.getTextPrimaryColor(context),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              settingsController.appInfo,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.getPrimaryColor(context),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'A modern unit converter app that allows you to convert between multiple units instantly with a beautiful design and responsive interface.',
              style: TextStyle(
                fontSize: 11.sp,
                color: AppTheme.getTextSecondaryColor(context),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Features:',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.getTextPrimaryColor(context),
              ),
            ),
            Text(
              '• Instant real-time conversion\n• 6 conversion categories\n• History tracking\n• Dark/Light theme\n• Offline functionality',
              style: TextStyle(
                fontSize: 11.sp,
                color: AppTheme.getTextSecondaryColor(context),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Close',
            ),
          ),
        ],
      ),
    );
  }
}