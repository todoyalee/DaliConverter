import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:daliconverter/utils/app_theme.dart';

class ConversionInput extends StatelessWidget {
  final String label;
  final String value;
  final Function(String) onChanged;
  final VoidCallback? onSubmitted;
  final String? hint;
  final bool isValid;

  const ConversionInput({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.onSubmitted,
    this.hint,
    this.isValid = true,
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
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            onTapUpOutside: (_) {
              FocusScope.of(context).unfocus();
            },
            initialValue: value,
            onChanged: onChanged,
            onFieldSubmitted:
                onSubmitted != null ? (_) => onSubmitted!() : null,
            textInputAction: TextInputAction.done,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.getTextPrimaryColor(context),
            ),
            decoration: InputDecoration(
              hintText: hint ?? 'Enter value',
              hintStyle: TextStyle(
                color: AppTheme.getTextSecondaryColor(context),
                fontSize: 11.sp,
                fontWeight: FontWeight.normal,
              ),
              filled: true,
              fillColor: Theme.of(context).cardColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isValid
                      ? Theme.of(context).dividerColor
                      : AppTheme.errorColor,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isValid
                      ? Theme.of(context).dividerColor
                      : AppTheme.errorColor,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isValid
                      ? AppTheme.getPrimaryColor(context)
                      : AppTheme.errorColor,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.errorColor),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 4.w,
                vertical: 2.h,
              ),
              prefixIcon: Icon(
                Icons.edit,
                color: AppTheme.getTextSecondaryColor(context),
                size: 5.w,
              ),
            ),
          ),
        ),
        if (!isValid)
          Padding(
            padding: EdgeInsets.only(top: 0.5.h, left: 1.w),
            child: Text(
              'Please enter a valid number',
              style: TextStyle(
                color: AppTheme.errorColor,
                fontSize: 12.sp,
              ),
            ),
          ),
      ],
    );
  }
}