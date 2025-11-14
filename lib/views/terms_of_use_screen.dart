import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:daliconverter/utils/app_theme.dart';

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

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
                            'Terms of Use',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.getTextPrimaryColor(context),
                            ),
                          ),
                          SizedBox(height: 3.h),
                          _buildSection(
                            context,
                            'Acceptance of Terms',
                            'By downloading, installing, or using the Instant Converter app, you agree to be bound by these Terms of Use. If you do not agree to these terms, please do not use the app.',
                          ),
                          _buildSection(
                            context,
                            'Use of the App',
                            'This app is provided for personal, non-commercial use. You may use the app to perform unit conversions for educational, professional, or personal purposes.',
                          ),
                          _buildSection(
                            context,
                            'Accuracy of Conversions',
                            'While we strive for accuracy in all conversion calculations, the app is provided "as is" without warranty. Users should verify critical calculations independently.',
                          ),
                          _buildSection(
                            context,
                            'Intellectual Property',
                            'The app, including its design, functionality, and content, is protected by copyright and other intellectual property laws. You may not copy, modify, or distribute the app without permission.',
                          ),
                          _buildSection(
                            context,
                            'Limitation of Liability',
                            'In no event shall the developers be liable for any damages arising from the use or inability to use this app, including but not limited to direct, indirect, incidental, or consequential damages.',
                          ),
                          _buildSection(
                            context,
                            'Updates and Changes',
                            'We reserve the right to update these terms at any time. Continued use of the app after changes constitutes acceptance of the new terms.',
                          ),
                          _buildSection(
                            context,
                            'Termination',
                            'These terms remain in effect until terminated. You may terminate at any time by uninstalling the app. We may terminate your access if you violate these terms.',
                          ),
                          _buildSection(
                            context,
                            'Contact Information',
                            'For questions about these terms, please contact us at yourmail@gmail.com',
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
            'Terms of Use',
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