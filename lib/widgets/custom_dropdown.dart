import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:daliconverter/utils/app_theme.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<T> items;
  final Function(T?) onChanged;
  final String Function(T) displayText;
  final String? hint;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.displayText,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.getTextSecondaryColor(context),
              ),
        ),
        SizedBox(height: 1.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).dividerColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              hint: hint != null
                  ? Text(
                      hint!,
                      style: TextStyle(
                        color: AppTheme.getTextSecondaryColor(context),
                        fontSize: 14.sp,
                      ),
                    )
                  : null,
              isExpanded: true,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: AppTheme.getTextSecondaryColor(context),
                size: 6.w,
              ),
              style: TextStyle(
                color: AppTheme.getTextPrimaryColor(context),
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
              dropdownColor: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              elevation: 8,
              items: items.map((T item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    child: Text(
                      displayText(item),
                      style: TextStyle(
                        color: AppTheme.getTextPrimaryColor(context),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}