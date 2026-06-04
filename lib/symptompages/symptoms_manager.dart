import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'symptoms_log.dart';

class SymptomManager extends ChangeNotifier {
  final Box<SymptomLog> _box = Hive.box<SymptomLog>('symptomBox');

  List<SymptomLog> get allLogs => _box.values.toList()
    ..sort((a, b) => b.savedAt.compareTo(a.savedAt));

  /// Save or overwrite the log for a given date
  void saveLog(String dateKey, Map<String, List<String>> categorySelections) {
    final log = SymptomLog(
      dateKey: dateKey,
      categorySelections: Map.from(categorySelections),
      savedAt: DateTime.now(),
    );
    _box.put(dateKey, log); // dateKey as Hive key = one entry per day
    notifyListeners();
  }

  /// Get log for a specific date, null if none
  SymptomLog? getLog(String dateKey) => _box.get(dateKey);

  /// Delete a log
  void deleteLog(String dateKey) {
    _box.delete(dateKey);
    notifyListeners();
  }

  /// All logged date keys
  List<String> get loggedDateKeys => _box.keys.cast<String>().toList();
}