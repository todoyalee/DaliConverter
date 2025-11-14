import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:daliconverter/controllers/converter_controller.dart';
import 'package:daliconverter/widgets/custom_dropdown.dart';
import 'package:daliconverter/widgets/conversion_input.dart';
import 'package:daliconverter/widgets/result_display.dart';
import 'package:daliconverter/utils/app_theme.dart';

class ConverterScreen extends StatelessWidget {
  const ConverterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ConverterController());

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(context),
              SizedBox(height: 3.h),

              // Category Grid
              _buildCategoryGrid(controller, context),
              SizedBox(height: 2.5.h),

              // Main Converter Card
              _buildConverterCard(controller, context),
              SizedBox(height: 3.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
                    Icons.swap_horiz,
                    color: Colors.white,
                    size: 6.w,
                  ),
                ),
                SizedBox(width: 3.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Instant Converter',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.getTextPrimaryColor(context),
                      ),
                    ),
                    Text(
                      'Convert units instantly',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppTheme.getTextSecondaryColor(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryGrid(
      ConverterController controller, BuildContext context) {
    return Obx(() {
      final categories = controller.availableCategories;
      final selected = controller.selectedCategory.value;

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
                'Categories',
                style: TextStyle(
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.getTextPrimaryColor(context),
                ),
              ),
              SizedBox(height: 1.5.h),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: categories.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 2.w,
                  crossAxisSpacing: 2.w,
                  childAspectRatio: 1.1,
                ),
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final isSelected = cat == selected;
                  return InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => controller.changeCategory(cat),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.getPrimaryColor(context)
                                .withOpacity(0.12)
                            : Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.getPrimaryColor(context)
                              : Theme.of(context).dividerColor,
                        ),
                      ),
                      padding: EdgeInsets.all(3.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            cat.icon,
                            style: TextStyle(fontSize: 18.sp),
                          ),
                          SizedBox(height: 0.8.h),
                          Text(
                            cat.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? AppTheme.getPrimaryColor(context)
                                  : AppTheme.getTextPrimaryColor(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildConverterCard(
      ConverterController controller, BuildContext context) {
    return Card(
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          children: [
            // From and To Unit Selection
            Row(
              children: [
                Expanded(
                  child: Obx(() => CustomDropdown(
                        label: 'From',
                        value: controller.fromUnit.value,
                        items: controller.availableUnits,
                        onChanged: (unit) {
                          if (unit != null) {
                            controller.changeFromUnit(unit);
                          }
                        },
                        displayText: (unit) => unit.symbol,
                      )),
                ),
                SizedBox(width: 3.w),
                // Swap Button
                GestureDetector(
                  onTap: controller.swapUnits,
                  child: Container(
                    margin: EdgeInsets.only(top: 3.h),
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.getPrimaryColor(context).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            AppTheme.getPrimaryColor(context).withOpacity(0.3),
                      ),
                    ),
                    child: Icon(
                      Icons.swap_horiz,
                      color: AppTheme.getPrimaryColor(context),
                      size: 6.w,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Obx(() => CustomDropdown(
                        label: 'To',
                        value: controller.toUnit.value,
                        items: controller.availableUnits,
                        onChanged: (unit) {
                          if (unit != null) {
                            controller.changeToUnit(unit);
                          }
                        },
                        displayText: (unit) => unit.symbol,
                      )),
                ),
              ],
            ),
            SizedBox(height: 3.h),

            // Input Field
            Obx(() => ConversionInput(
                  label: 'Enter Value',
                  value: controller.inputValue.value,
                  onChanged: controller.updateInputValue,
                  onSubmitted: controller.finishInput,
                  hint: 'Enter value to convert',
                  isValid: controller.isInputValid,
                )),
            SizedBox(height: 3.h),

            // Result Display
            Obx(() => ResultDisplay(
                  result: controller.formattedResult,
                  onCopy: controller.copyResultToClipboard,
                  onTap: controller.finishInput,
                  isLoading: controller.isLoading.value,
                )),
          ],
        ),
      ),
    );
  }
}