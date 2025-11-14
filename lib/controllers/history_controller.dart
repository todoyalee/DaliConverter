import 'dart:convert';
import 'dart:developer';
import 'package:daliconverter/utils/app_snack_bar.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:daliconverter/models/conversion_history.dart';

class HistoryController extends GetxController {
  static const String _historyKey = 'conversion_history_v2';
  static const int _maxHistoryItems = 10;

  final _history = <ConversionHistory>[].obs;
  final _isLoading = false.obs;

  List<ConversionHistory> get history => _history;
  bool get isLoading => _isLoading.value;
  bool get hasHistory => _history.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  /// Load conversion history from storage
  Future<void> loadHistory() async {
    _isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? historyJson = prefs.getStringList(_historyKey);

      if (historyJson != null) {
        final List<ConversionHistory> loadedHistory = historyJson
            .map((jsonString) {
              try {
                return ConversionHistory.fromJson(jsonDecode(jsonString));
              } catch (e) {
                log('Error parsing history item: $e');
                return null;
              }
            })
            .where((item) => item != null)
            .cast<ConversionHistory>()
            .toList();

        _history.assignAll(loadedHistory);
      }
    } catch (e) {
      log('Error loading history: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  /// Add a new conversion to history
  Future<void> addConversion({
    required String categoryName,
    required String fromUnit,
    required String toUnit,
    required double inputValue,
    required double resultValue,
  }) async {
    try {
      // Don't save if it's the same conversion or invalid values
      if (inputValue == 0 || resultValue == 0 || fromUnit == toUnit) {
        return;
      }

      // Check if this exact conversion already exists at the top
      if (_history.isNotEmpty) {
        final latest = _history.first;
        if (latest.categoryName == categoryName &&
            latest.fromUnit == fromUnit &&
            latest.toUnit == toUnit &&
            latest.inputValue == inputValue &&
            latest.resultValue == resultValue) {
          return; // Don't add duplicate
        }
      }

      final conversion = ConversionHistory(
        categoryName: categoryName,
        fromUnit: fromUnit,
        toUnit: toUnit,
        inputValue: inputValue,
        resultValue: resultValue,
        timestamp: DateTime.now(),
      );

      // Add to the beginning of the list
      _history.insert(0, conversion);

      // Keep only the latest items
      if (_history.length > _maxHistoryItems) {
        _history.removeRange(_maxHistoryItems, _history.length);
      }

      await _saveHistoryToStorage();
    } catch (e) {
      log('Error adding conversion to history: $e');
    }
  }

  /// Save history to storage
  Future<void> _saveHistoryToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> historyJson = _history
          .map((conversion) => jsonEncode(conversion.toJson()))
          .toList();

      await prefs.setStringList(_historyKey, historyJson);
    } catch (e) {
      log('Error saving history: $e');
    }
  }

  /// Remove a specific conversion from history
  Future<void> removeConversion(int index) async {
    try {
      if (index >= 0 && index < _history.length) {
        _history.removeAt(index);
        await _saveHistoryToStorage();

        AppCustomSnackBar(
          context: Get.context!,
          text: 'Removed\nConversion removed from history',
        ).show();
      }
    } catch (e) {
      log('Error removing conversion: $e');
    }
  }

  /// Clear all history
  Future<void> clearAllHistory() async {
    try {
      _history.clear();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_historyKey);

      AppCustomSnackBar(
        context: Get.context!,
        text: 'History Cleared\nAll conversion history has been deleted',
      ).show();
    } catch (e) {
      log('Error clearing history: $e');
    }
  }

  /// Get formatted time difference
  String getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 30) {
      return '${difference.inDays}d ago';
    } else {
      return '${(difference.inDays / 30).floor()}mo ago';
    }
  }
}