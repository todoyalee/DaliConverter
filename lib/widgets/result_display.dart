import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:daliconverter/utils/app_theme.dart';

class ResultDisplay extends StatelessWidget {
  final String result;
  final VoidCallback onCopy;
  final VoidCallback? onTap;
  final bool isLoading;

  const ResultDisplay({
    super.key,
    required this.result,
    required this.onCopy,
    this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(5.w),
        decoration: BoxDecoration(
          gradient: AppTheme.getPrimaryGradient(context),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.getPrimaryColor(context).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Result',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: result != '0' && result != 'Error' ? onCopy : null,
                  icon: Icon(
                    Icons.copy,
                    color: result != '0' && result != 'Error'
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                    size: 5.w,
                  ),
                ),
              ],
            ),
            if (isLoading)
              Row(
                children: [
                  SizedBox(
                    width: 4.w,
                    height: 4.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Converting...',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
            else
              Text(
                result,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            if (onTap != null && result != '0' && result != 'Error')
              Padding(
                padding: EdgeInsets.only(top: .5.h),
                child: Text(
                  'Tap to save to history',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 11.sp,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}