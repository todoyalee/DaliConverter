import 'package:daliconverter/models/conversion_unit.dart';

class ConverterHelper {
  /// Standard conversion using factors (for all categories except temperature)
  static double convertStandard(
    double value,
    ConversionUnit fromUnit,
    ConversionUnit toUnit,
  ) {
    if (value == 0) return 0;

    // Convert to base unit first, then to target unit
    double baseValue = value * fromUnit.factor;
    double result = baseValue / toUnit.factor;

    return result;
  }

  /// Temperature conversion with special formulas
  static double convertTemperature(
    double value,
    ConversionUnit fromUnit,
    ConversionUnit toUnit,
  ) {
    if (fromUnit.symbol == toUnit.symbol) return value;

    // Convert from input to Celsius first
    double celsius;
    switch (fromUnit.symbol) {
      case '°C':
        celsius = value;
        break;
      case '°F':
        celsius = (value - 32) * 5 / 9;
        break;
      case 'K':
        celsius = value - 273.15;
        break;
      default:
        celsius = value;
    }

    // Convert from Celsius to target unit
    switch (toUnit.symbol) {
      case '°C':
        return celsius;
      case '°F':
        return celsius * 9 / 5 + 32;
      case 'K':
        return celsius + 273.15;
      default:
        return celsius;
    }
  }

  /// Main conversion method that routes to appropriate converter
  static double convert(
    double value,
    ConversionUnit fromUnit,
    ConversionUnit toUnit,
    bool isTemperature,
  ) {
    if (fromUnit == toUnit) return value;

    if (isTemperature) {
      return convertTemperature(value, fromUnit, toUnit);
    } else {
      return convertStandard(value, fromUnit, toUnit);
    }
  }

  /// Format result for display
  static String formatResult(double result) {
    if (result == 0) return '0';

    // For very small numbers
    if (result.abs() < 0.0001) {
      return result.toStringAsExponential(3);
    }

    // For very large numbers
    if (result.abs() >= 1000000) {
      return result.toStringAsExponential(3);
    }

    // Remove unnecessary decimal places
    if (result == result.toInt()) {
      return result.toInt().toString();
    }

    // Limit to 6 significant digits
    String formatted = result.toStringAsFixed(6);
    formatted = formatted.replaceAll(RegExp(r'\.?0+$'), '');

    return formatted;
  }
}