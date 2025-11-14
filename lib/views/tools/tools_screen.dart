import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:daliconverter/utils/app_theme.dart';
import 'age_calculator_screen.dart';
import 'date_calculator_screen.dart';
import 'password_generator_screen.dart';
import 'timezone_converter_screen.dart';

class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            _buildHeader(context),
            _ToolTile(
              icon: Icons.cake_outlined,
              title: 'Age Calculator',
              subtitle: 'Calculate your age precisely and see next birthday',
              onTap: () => Get.to(() => const AgeCalculatorScreen()),
            ),
            _ToolTile(
              icon: Icons.calendar_month_outlined,
              title: 'Date Calculator',
              subtitle: 'Add/Subtract days and find date differences',
              onTap: () => Get.to(() => const DateCalculatorScreen()),
            ),
            _ToolTile(
              icon: Icons.public,
              title: 'Timezone Converter',
              subtitle: 'Convert time between popular timezones',
              onTap: () => Get.to(() => const TimezoneConverterScreen()),
            ),
            _ToolTile(
              icon: Icons.password,
              title: 'Password Generator',
              subtitle: 'Create strong, customizable passwords',
              onTap: () => Get.to(() => const PasswordGeneratorScreen()),
            ),
            SizedBox(height: 2.h),
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
              Icons.grid_view_rounded,
              color: Colors.white,
              size: 6.w,
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            'Tools',
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
}

class _ToolTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ToolTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: .8.h),
      child: Card(
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.6.h),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.getPrimaryColor(context).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon,
                      color: AppTheme.getPrimaryColor(context), size: 6.w),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: AppTheme.getTextPrimaryColor(context),
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5.sp,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppTheme.getTextSecondaryColor(context),
                          fontSize: 10.5.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right,
                    color: AppTheme.getTextSecondaryColor(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}