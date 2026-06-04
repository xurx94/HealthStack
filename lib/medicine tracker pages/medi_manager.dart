import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../notification_helper.dart'; // NEW: Pointing to the new engine!
import 'medicine.dart';

class MediManager extends ChangeNotifier {
  // Connect directly to the opened Hive box
  final Box<medicine> _medicineBox = Hive.box<medicine>('medicineBox');

  List<medicine> _medicines = [];

  MediManager() {
    _loadMedicines(); // Load data as soon as the app starts
    _restoreNotifications(); // Sync alarms on startup
  }

  List<medicine> get medicines => _medicines;

  // Refreshes the local list from the secure database
  void _loadMedicines() {
    _medicines = _medicineBox.values.toList();

    // --- The Midnight Reset Logic ---
    final now = DateTime.now();
    bool needsSave = false;

    for (int i = 0; i < _medicines.length; i++) {
      var med = _medicines[i];

      // If the medicine was started before today, reset the checkboxes for the new day.
      if (!_isSameDay(med.start, now)) {
        List<bool> freshStatus = List.generate(med.time.length, (_) => false);

        var resetMed = med.xerox(
          status: freshStatus,
          start: DateTime(now.year, now.month, now.day),
        );

        _medicines[i] = resetMed;
        _medicineBox.put(resetMed.id, resetMed);
        needsSave = true;
      }
    }

    if (needsSave) {
      _medicines = _medicineBox.values.toList(); // Reload if we changed things
    }
    notifyListeners();
  }

  // --- NEW: Bulletproof Alarm Syncing ---
  Future<void> _restoreNotifications() async {
    final helper = NotificationHelper();

    // 1. Cancel all existing alarms to prevent duplicates
    await helper.cancelAllReminders();

    // 2. Loop through every medicine, and every dose time, and arm the alarms
    for (var med in _medicines) {
      for (int i = 0; i < med.time.length; i++) {
        if (med.time[i] != null) {
          // Recreate the exact same unique ID we used in adder_form
          int alarmId = (med.name + i.toString()).hashCode & 0x7FFFFFFF;

          await helper.scheduleDailyMedicineReminder(
            notificationId: alarmId,
            medicineName: med.name,
            timeOfDay: med.time[i]!,
          );
        }
      }
    }
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<void> addMedicine(medicine record) async {
    // Save to Hive using the unique ID as the key
    _medicineBox.put(record.id, record);
    _loadMedicines();
    await _restoreNotifications();
  }

  Future<void> updateMedicine(medicine updatedRecord) async {
    // Hive automatically overwrites the old data if the ID matches
    _medicineBox.put(updatedRecord.id, updatedRecord);
    _loadMedicines();
    await _restoreNotifications();
  }

  Future<void> deleteMedicine(String id) async {
    // Remove it completely from secure storage
    _medicineBox.delete(id);
    _loadMedicines();
    await _restoreNotifications();
  }
}
