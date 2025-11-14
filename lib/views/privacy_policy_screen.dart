import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:daliconverter/utils/app_theme.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.getBackgroundGradient(context),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(context),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(5.w),
                  child: Card(
                    elevation: 4,
                    shadowColor: Colors.black.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(6.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Privacy Policy',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.getTextPrimaryColor(context),
                            ),
                          ),
                          SizedBox(height: 3.h),
                          _buildSection(
                            context,
                            'Information We Collect',
                            'Instant Converter is designed with privacy in mind. We do not collect, store, or transmit any personal information. All conversions and calculations are performed locally on your device.',
                          ),
                          _buildSection(
                            context,
                            'Data Storage',
                            'The app stores conversion history locally on your device using secure storage methods. This data never leaves your device and can be cleared at any time through the app settings.',
                          ),
                          _buildSection(
                            context,
                            'Permissions',
                            'The app may request minimal permissions necessary for functionality, such as storage access for saving preferences. No sensitive device information is accessed.',
                          ),
                          _buildSection(
                            context,
                            'Third-Party Services',
                            'This app does not integrate with any third-party analytics, advertising, or tracking services. Your usage remains completely private.',
                          ),
                          _buildSection(
                            context,
                            'Changes to Privacy Policy',
                            'Any changes to this privacy policy will be reflected in app updates. Continued use of the app constitutes acceptance of any changes.',
                          ),
                          _buildSection(
                            context,
                            'Contact',
                            'If you have any questions about this privacy policy, please contact us at yourmail@gmail.com',
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            'Last updated: ${DateTime.now().toString().split(' ')[0]}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppTheme.getTextSecondaryColor(context),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.w),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.getPrimaryColor(context),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 6.w,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            'Privacy Policy',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.getTextPrimaryColor(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.getTextPrimaryColor(context),
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          content,
          style: TextStyle(
            fontSize: 11.sp,
            color: AppTheme.getTextSecondaryColor(context),
            height: 1.5,
          ),
        ),
        SizedBox(height: 3.h),
      ],
    );
  }
}