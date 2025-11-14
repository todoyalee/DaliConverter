
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:daliconverter/utils/app_theme.dart';

class AgeCalculatorScreen extends StatefulWidget {
  const AgeCalculatorScreen({super.key});

  @override
  State<AgeCalculatorScreen> createState() => _AgeCalculatorScreenState();
}

class _AgeCalculatorScreenState extends State<AgeCalculatorScreen> {
  DateTime? _dob;
  final DateTime _today = DateTime.now();

  void _pickDob() async {
    final now = DateTime.now();
    final initial = _dob ?? DateTime(now.year - 20, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: now,
      initialDate: initial,
    );
    if (picked != null) {
      setState(() => _dob = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final result = _dob == null ? null : _calculateAge(_dob!, _today);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            Padding(
              padding: EdgeInsets.all(5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Date of Birth',
                    style: TextStyle(
                      color: AppTheme.getTextPrimaryColor(context),
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _pickDob,
                          icon: const Icon(Icons.cake_outlined),
                          label: Text(
                            _dob == null
                                ? 'Choose Date'
                                : DateFormat.yMMMMd().format(_dob!),
                          ),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.5.h),
                  if (result != null) _buildResult(context, result),
                ],
              ),
            )
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
            'Age Calculator',
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

  Widget _buildFactChip(BuildContext context, String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
      decoration: BoxDecoration(
        color: AppTheme.getPrimaryColor(context).withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppTheme.getTextSecondaryColor(context),
              fontSize: 10.sp,
            ),
          ),
          SizedBox(width: 2.w),
          Text(
            value,
            style: TextStyle(
              color: AppTheme.getTextPrimaryColor(context),
              fontWeight: FontWeight.w700,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResult(BuildContext context, _AgeResult result) {
    final totalDays = DateTime.now().difference(_dob!).inDays;
    final totalWeeks = (totalDays / 7).floor();
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Age',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: AppTheme.getTextPrimaryColor(context),
              ),
            ),
            SizedBox(height: .5.h),
            Text(
              '${result.years} years, ${result.months} months, ${result.days} days',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppTheme.getTextSecondaryColor(context),
              ),
            ),
            SizedBox(height: 1.2.h),
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: [
                _buildFactChip(context, 'Total days', '$totalDays'),
                _buildFactChip(context, 'Weeks', '$totalWeeks'),
                _buildFactChip(
                    context, 'DOB', DateFormat.yMMMd().format(_dob!)),
              ],
            ),
            SizedBox(height: 1.2.h),
            Divider(color: Theme.of(context).dividerColor),
            SizedBox(height: 1.2.h),
            Text(
              'Next Birthday: ${DateFormat.yMMMMd().format(result.nextBirthday)} (${result.daysToNextBirthday} days left)',
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

  _AgeResult _calculateAge(DateTime dob, DateTime today) {
    int years = today.year - dob.year;
    int months = today.month - dob.month;
    int days = today.day - dob.day;

    if (days < 0) {
      final prevMonth = DateTime(today.year, today.month, 0);
      days += prevMonth.day;
      months -= 1;
    }
    if (months < 0) {
      months += 12;
      years -= 1;
    }

    DateTime nextBirthday = DateTime(today.year, dob.month, dob.day);
    if (!nextBirthday.isAfter(today)) {
      nextBirthday = DateTime(today.year + 1, dob.month, dob.day);
    }
    final daysToNext = nextBirthday.difference(today).inDays;

    return _AgeResult(
      years: years,
      months: months,
      days: days,
      nextBirthday: nextBirthday,
      daysToNextBirthday: daysToNext,
    );
  }
}

class _AgeResult {
  final int years;
  final int months;
  final int days;
  final DateTime nextBirthday;
  final int daysToNextBirthday;
  _AgeResult({
    required this.years,
    required this.months,
    required this.days,
    required this.nextBirthday,
    required this.daysToNextBirthday,
  });
}
