import 'package:daliconverter/models/conversion_category.dart';
import 'package:daliconverter/models/conversion_unit.dart';

class ConversionData {
  static const List<ConversionCategory> categories = [
    ConversionCategory(
      name: 'Length',
      icon: '📏',
      units: [
        ConversionUnit(name: 'Centimeter', symbol: 'cm', factor: 0.01),
        ConversionUnit(name: 'Meter', symbol: 'm', factor: 1.0),
        ConversionUnit(name: 'Kilometer', symbol: 'km', factor: 1000.0),
        ConversionUnit(name: 'Inch', symbol: 'in', factor: 0.0254),
        ConversionUnit(name: 'Foot', symbol: 'ft', factor: 0.3048),
        ConversionUnit(name: 'Yard', symbol: 'yd', factor: 0.9144),
        ConversionUnit(name: 'Mile', symbol: 'mi', factor: 1609.34),
      ],
    ),
    ConversionCategory(
      name: 'Weight',
      icon: '⚖️',
      units: [
        ConversionUnit(name: 'Gram', symbol: 'g', factor: 0.001),
        ConversionUnit(name: 'Kilogram', symbol: 'kg', factor: 1.0),
        ConversionUnit(name: 'Pound', symbol: 'lb', factor: 0.453592),
        ConversionUnit(name: 'Ounce', symbol: 'oz', factor: 0.0283495),
        ConversionUnit(name: 'Ton', symbol: 't', factor: 1000.0),
      ],
    ),
    ConversionCategory(
      name: 'Volume',
      icon: '🥤',
      units: [
        ConversionUnit(name: 'Milliliter', symbol: 'ml', factor: 0.001),
        ConversionUnit(name: 'Liter', symbol: 'L', factor: 1.0),
        ConversionUnit(name: 'Cup', symbol: 'cup', factor: 0.236588),
        ConversionUnit(name: 'Pint', symbol: 'pt', factor: 0.473176),
        ConversionUnit(name: 'Gallon', symbol: 'gal', factor: 3.78541),
      ],
    ),
    ConversionCategory(
      name: 'Temperature',
      icon: '🌡️',
      units: [
        ConversionUnit(name: 'Celsius', symbol: '°C', factor: 1.0),
        ConversionUnit(name: 'Fahrenheit', symbol: '°F', factor: 1.0),
        ConversionUnit(name: 'Kelvin', symbol: 'K', factor: 1.0),
      ],
    ),
    ConversionCategory(
      name: 'Area',
      icon: '📐',
      units: [
        ConversionUnit(name: 'Square Meter', symbol: 'm²', factor: 1.0),
        ConversionUnit(
            name: 'Square Kilometer', symbol: 'km²', factor: 1000000.0),
        ConversionUnit(name: 'Acre', symbol: 'ac', factor: 4046.86),
        ConversionUnit(name: 'Hectare', symbol: 'ha', factor: 10000.0),
      ],
    ),
    ConversionCategory(
      name: 'Speed',
      icon: '🚗',
      units: [
        ConversionUnit(
            name: 'Kilometers per Hour', symbol: 'km/h', factor: 0.277778),
        ConversionUnit(name: 'Meters per Second', symbol: 'm/s', factor: 1.0),
        ConversionUnit(name: 'Miles per Hour', symbol: 'mph', factor: 0.44704),
        ConversionUnit(name: 'Knots', symbol: 'kn', factor: 0.514444),
      ],
    ),
    ConversionCategory(
      name: 'Time',
      icon: '⏱️',
      units: [
        ConversionUnit(name: 'Millisecond', symbol: 'ms', factor: 0.001),
        ConversionUnit(name: 'Second', symbol: 's', factor: 1.0),
        ConversionUnit(name: 'Minute', symbol: 'min', factor: 60.0),
        ConversionUnit(name: 'Hour', symbol: 'h', factor: 3600.0),
        ConversionUnit(name: 'Day', symbol: 'd', factor: 86400.0),
        ConversionUnit(name: 'Week', symbol: 'wk', factor: 604800.0),
      ],
    ),
  ];
}