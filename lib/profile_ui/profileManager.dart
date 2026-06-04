import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'profile.dart';

class Profilemanager extends ChangeNotifier {
  // Connect directly to the opened Hive box
  final Box<Profile> _profileBox = Hive.box<Profile>('profileBox');

  List<Profile> profile = [];

  Profilemanager() {
    _loadProfiles(); // Load immediately when app starts
  }

  List<Profile> get profiles => profile;

  void _loadProfiles() {
    profile = _profileBox.values.toList();
    notifyListeners();
  }

  void addProfile(Profile record) {
    _profileBox.put(record.id, record);
    _loadProfiles();
  }

  void updateProfiles(Profile updatedRecord) {
    _profileBox.put(updatedRecord.id, updatedRecord);
    _loadProfiles();
  }
}
