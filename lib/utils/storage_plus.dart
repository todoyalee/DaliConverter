import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:daliconverter/models/conversion_history.dart';

class StorageHelper {
  static const String _historyKey = 'conversion_history';
  static const int _maxHistoryItems = 5;

  /// Save conversion to history
  static Future<void> saveConversion(ConversionHistory conversion) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<ConversionHistory> history = await getHistory();

      // Add new conversion at the beginning
      history.insert(0, conversion);

      // Keep only the latest 5 conversions
      if (history.length > _maxHistoryItems) {
        history = history.take(_maxHistoryItems).toList();
      }

      // Convert to JSON and save
      List<String> jsonHistory =
          history.map((conversion) => jsonEncode(conversion.toJson())).toList();

      await prefs.setStringList(_historyKey, jsonHistory);
    } catch (e) {
      print('Error saving conversion: $e');
    }
  }

  /// Get conversion history
  static Future<List<ConversionHistory>> getHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String>? jsonHistory = prefs.getStringList(_historyKey);

      if (jsonHistory == null) return [];

      return jsonHistory
          .map((jsonString) =>
              ConversionHistory.fromJson(jsonDecode(jsonString)))
          .toList();
    } catch (e) {
      print('Error loading history: $e');
      return [];
    }
  }

  /// Clear conversion history
  static Future<void> clearHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_historyKey);
    } catch (e) {
      print('Error clearing history: $e');
    }
  }

  /// Check if history is empty
  static Future<bool> isHistoryEmpty() async {
    List<ConversionHistory> history = await getHistory();
    return history.isEmpty;
  }
}