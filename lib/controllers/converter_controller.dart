
import 'dart:developer';

import 'package:daliconverter/utils/app_snack_bar.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:daliconverter/models/conversion_category.dart';
import 'package:daliconverter/models/conversion_unit.dart';
import 'package:daliconverter/utils/conversion_data.dart';
import 'package:daliconverter/utils/converter_helper.dart';
import 'history_controller.dart';

class ConverterController extends GetxController {
  // Observable variables
  final selectedCategory =
      Rx<ConversionCategory>(ConversionData.categories.first);
  final fromUnit = Rx<ConversionUnit?>(null);
  final toUnit = Rx<ConversionUnit?>(null);
  final inputValue = ''.obs;
  final resultValue = '0'.obs;
  final isLoading = false.obs;
  late HistoryController historyController;

  @override
  void onInit() {
    super.onInit();
    historyController = Get.find<HistoryController>();
    _initializeUnits();
  }

  /// Initialize default units for the selected category
  void _initializeUnits() {
    final units = selectedCategory.value.units;
    if (units.isNotEmpty) {
      fromUnit.value = units.first;
      toUnit.value = units.length > 1 ? units[1] : units.first;
    }
  }

  /// Change conversion category
  void changeCategory(ConversionCategory category) {
    selectedCategory.value = category;
    _initializeUnits();
    _performConversion();
  }

  /// Change from unit
  void changeFromUnit(ConversionUnit unit) {
    fromUnit.value = unit;
    _performConversion();
  }

  /// Change to unit
  void changeToUnit(ConversionUnit unit) {
    toUnit.value = unit;
    _performConversion();
  }

  /// Update input value and perform conversion (without adding to history)
  void updateInputValue(String value) {
    inputValue.value = value;
    _performConversion();
  }

  /// Finish input and add to history (called when user presses Done or finishes input)
  void finishInput() {
    _addToHistory();
  }

  /// Swap from and to units
  void swapUnits() {
    if (fromUnit.value != null && toUnit.value != null) {
      final temp = fromUnit.value;
      fromUnit.value = toUnit.value;
      toUnit.value = temp;
      _performConversion();
    }
  }

  /// Perform the actual conversion (without adding to history)
  void _performConversion() {
    if (inputValue.value.isEmpty ||
        fromUnit.value == null ||
        toUnit.value == null) {
      resultValue.value = '0';
      return;
    }

    try {
      final double input = double.parse(inputValue.value);
      // final bool isTemperature = selectedCategory.value.hasCustomConverter;
      final bool isTemperature=false;

      final double result = ConverterHelper.convert(
        input,
        fromUnit.value!,
        toUnit.value!,
        isTemperature,
      );

      resultValue.value = ConverterHelper.formatResult(result);
    } catch (e) {
      resultValue.value = 'Error';
      log('Conversion error: $e');
    }
  }

  /// Add current conversion to history
  void _addToHistory() {
    if (inputValue.value.isEmpty ||
        fromUnit.value == null ||
        toUnit.value == null) {
      return;
    }

    try {
      final double input = double.parse(inputValue.value);
      // final bool isTemperature = selectedCategory.value.hasCustomConverter;
      final bool isTemperature=false;

      final double result = ConverterHelper.convert(
        input,
        fromUnit.value!,
        toUnit.value!,
        isTemperature,
      );

      // Only add to history if it's a valid, meaningful conversion
      if (input != 0 &&
          result != 0 &&
          fromUnit.value!.symbol != toUnit.value!.symbol) {
        historyController.addConversion(
          categoryName: selectedCategory.value.name,
          fromUnit: fromUnit.value!.symbol,
          toUnit: toUnit.value!.symbol,
          inputValue: input,
          resultValue: result,
        );
      }
    } catch (e) {
      log('History addition error: $e');
    }
  }

  /// Copy result to clipboard
  Future<void> copyResultToClipboard() async {
    if (resultValue.value != '0' && resultValue.value != 'Error') {
      await Clipboard.setData(ClipboardData(text: resultValue.value));
      AppCustomSnackBar(
        context: Get.context!,
        text: 'Copied!\nResult copied to clipboard',
      ).show();
    }
  }

  /// Get available categories
  List<ConversionCategory> get availableCategories => ConversionData.categories;

  /// Get available units for current category
  List<ConversionUnit> get availableUnits => selectedCategory.value.units;

  /// Check if input is valid
  bool get isInputValid {
    if (inputValue.value.isEmpty) return true;
    try {
      double.parse(inputValue.value);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get formatted result with units
  String get formattedResult {
    if (resultValue.value == '0' ||
        resultValue.value == 'Error' ||
        toUnit.value == null) {
      return resultValue.value;
    }
    return '${resultValue.value} ${toUnit.value!.symbol}';
  }
}
