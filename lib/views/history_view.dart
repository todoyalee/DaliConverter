import 'package:daliconverter/controllers/history_controller.dart';
import 'package:daliconverter/utils/app_snack_bar.dart';
import 'package:daliconverter/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  @override
  Widget build(BuildContext context) {
    final historyController = Get.find<HistoryController>();

    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            _buildHeader(context, historyController),
            SizedBox(
              height: 1.h,
            ),
            _buildHistorySection(historyController, context),
          ],
        ),
      )),
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

  IconData getIcon(String category) {
    switch (category) {
      case 'Speed':
        return Icons.speed; // good choice
      case 'Weight':
        return Icons.fitness_center; // better than line_weight
      case 'Volume':
        return Icons.local_drink; // or Icons.water_drop
      case 'Temperature':
        return Icons.thermostat; // perfect for temperature
      case 'Area':
        return Icons.crop_square; // represents area/space
      case 'Length':
        return Icons.straighten; // ruler/length measurement
      case 'Time':
        return Icons.access_time; // classic clock icon
      default:
        return Icons.help_outline; // safer fallback
    }
  }

  Widget _buildHistorySection(
      HistoryController historyController, BuildContext context) {
    return Obx(() {
      if (!historyController.hasHistory) {
        return Padding(
          padding: EdgeInsets.only(top: 8.h),
          child: Center(
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.getPrimaryColor(context).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.history,
                    color: AppTheme.getPrimaryColor(context),
                    size: 12.w,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'No history yet',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.getTextPrimaryColor(context),
                  ),
                ),
                SizedBox(height: 0.8.h),
                Text(
                  'Start converting units to see them here',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppTheme.getTextSecondaryColor(context),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return Padding(
        padding: EdgeInsets.only(top: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...historyController.history.asMap().entries.map((entry) {
              final index = entry.key;
              final conversion = entry.value;
              return Container(
                margin: EdgeInsets.only(bottom: 1.h),
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Theme.of(context).cardColor,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.4.w),
                      decoration: BoxDecoration(
                        color:
                            AppTheme.getPrimaryColor(context).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        getIcon(conversion.categoryName),
                        color: AppTheme.getPrimaryColor(context),
                        size: 4.2.w,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  conversion.categoryName,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color:
                                        AppTheme.getTextSecondaryColor(context),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Text(
                                historyController
                                    .getTimeAgo(conversion.timestamp),
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color:
                                      AppTheme.getTextSecondaryColor(context),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 0.4.h),
                          Text(
                            conversion.formattedResult,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: AppTheme.getTextPrimaryColor(context),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 0.8.h),
                          Row(
                            children: [
                              _MiniChip(
                                label: conversion.fromUnit,
                                context: context,
                              ),
                              SizedBox(width: 2.w),
                              _MiniChip(
                                label: conversion.toUnit,
                                context: context,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () async {
                            await Clipboard.setData(ClipboardData(
                                text: conversion.formattedResult));
                            if (context.mounted) {
                              AppCustomSnackBar(
                                      context: context, text: 'Copied')
                                  .show();
                            }
                          },
                          icon: const Icon(Icons.copy),
                          tooltip: 'Copy',
                        ),
                        IconButton(
                          onPressed: () =>
                              historyController.removeConversion(index),
                          icon: const Icon(Icons.delete_outline),
                          tooltip: 'Delete',
                        ),
                      ],
                    )
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      );
    });
  }

  Widget _buildHeader(
      BuildContext context, HistoryController historyController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.getPrimaryColor(context),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.history,
                    color: Colors.white,
                    size: 6.w,
                  ),
                ),
                SizedBox(width: 3.w),
                Text(
                  'History',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.getTextPrimaryColor(context),
                  ),
                ),
              ],
            ),
            Obx(
              () => historyController.hasHistory
                  ? IconButton(
                      onPressed: () =>
                          _showClearHistoryDialog(context, historyController),
                      icon: const Icon(Icons.delete),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ],
    );
  }
}

class _MiniChip extends StatelessWidget {
  final String label;
  final BuildContext context;
  const _MiniChip({required this.label, required this.context});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: AppTheme.getPrimaryColor(this.context).withOpacity(0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: AppTheme.getPrimaryColor(this.context),
          fontWeight: FontWeight.w600,
          fontSize: 10.sp,
        ),
      ),
    );
  }
}