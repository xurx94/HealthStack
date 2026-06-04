import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'app_state.g.dart';

@HiveType(typeId: 3)
class MedicalReport {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String type;
  @HiveField(3)
  final String doctorName;
  @HiveField(4)
  final String hospitalName;
  @HiveField(5)
  final DateTime date;
  @HiveField(6)
  final String fileName;
  @HiveField(7)
  final String filePath;
  @HiveField(8)
  final String? aiOverview;

  MedicalReport({
    required this.id,
    required this.name,
    required this.type,
    required this.doctorName,
    required this.hospitalName,
    required this.date,
    required this.fileName,
    required this.filePath,
    this.aiOverview = "",
  });
}

@HiveType(typeId: 4)
class HealthStatRecord {
  @HiveField(0)
  final DateTime date;
  @HiveField(1)
  final double weight;
  @HiveField(2)
  final String heartRate;
  @HiveField(3)
  final String bloodPressure;
  @HiveField(4)
  final String hemoglobin;
  @HiveField(5)
  final String bloodSugar;

  HealthStatRecord({
    required this.date,
    required this.weight,
    required this.heartRate,
    required this.bloodPressure,
    required this.hemoglobin,
    required this.bloodSugar,
  });
}

class AppState extends ChangeNotifier {
  final Box<MedicalReport> _reportsBox = Hive.box<MedicalReport>('reportsBox');
  final Box<HealthStatRecord> _healthStatsBox = Hive.box<HealthStatRecord>(
    'healthStatsBox',
  );
  final Box _settingsBox = Hive.box('settingsBox');

  List<MedicalReport> _reports = [];

  // Default Values
  String userName = "User";
  String userEmail = "";
  int userAge = 25;
  double userHeight = 170.0;
  double userWeight = 70.0;
  String userCondition = "None";
  String heartRate = "72";
  String bloodPressure = "120/80";
  String bloodSugar = "90";
  String hemoglobin = "14.0";
  String bloodGroup = "O+";

  // Doctor Visit Prep State
  String visitSymptoms = "";
  List<String> visitMedIds = [];
  List<String> visitReportIds = [];
  bool includeVitalsInVisit = false;

  bool get hasActiveVisit =>
      visitSymptoms.isNotEmpty ||
      visitMedIds.isNotEmpty ||
      visitReportIds.isNotEmpty ||
      includeVitalsInVisit;

  AppState() {
    _loadReports();
    _loadSettings();
  }

  List<MedicalReport> get reports => _reports;

  List<HealthStatRecord> get healthHistory {
    final list = _healthStatsBox.values.toList();
    list.sort((a, b) => a.date.compareTo(b.date));
    return list;
  }

  HealthStatRecord? get latestStat =>
      healthHistory.isNotEmpty ? healthHistory.last : null;

  Box get settingsBox => _settingsBox;

  void _loadReports() {
    _reports = _reportsBox.values.toList();
    notifyListeners();
  }

  void _loadSettings() {
    userName = _settingsBox.get('userName', defaultValue: "User");
    userEmail = _settingsBox.get('userEmail', defaultValue: "");
    userAge = _settingsBox.get('userAge', defaultValue: 25);
    userHeight = _settingsBox.get('userHeight', defaultValue: 170.0);
    userWeight = _settingsBox.get('userWeight', defaultValue: 70.0);
    userCondition = _settingsBox.get('userCondition', defaultValue: "None");
    heartRate = _settingsBox.get('heartRate', defaultValue: "72");
    bloodPressure = _settingsBox.get('bloodPressure', defaultValue: "120/80");
    bloodSugar = _settingsBox.get('bloodSugar', defaultValue: "90");
    hemoglobin = _settingsBox.get('hemoglobin', defaultValue: "14.0");
    bloodGroup = _settingsBox.get('bloodGroup', defaultValue: "O+");

    visitSymptoms = _settingsBox.get('visitSymptoms', defaultValue: "");
    includeVitalsInVisit = _settingsBox.get(
      'includeVitalsInVisit',
      defaultValue: false,
    );
    List<dynamic> rawMeds = _settingsBox.get('visitMedIds', defaultValue: []);
    List<dynamic> rawReports = _settingsBox.get(
      'visitReportIds',
      defaultValue: [],
    );
    visitMedIds = rawMeds.map((e) => e.toString()).toList();
    visitReportIds = rawReports.map((e) => e.toString()).toList();

    notifyListeners();
  }

  void addReport(MedicalReport report) {
    _reportsBox.put(report.id, report);
    _loadReports();
  }

  void deleteReport(String id) {
    _reportsBox.delete(id);
    _loadReports();
  }

  void updateProfile({
    String? newName,
    String? newEmail,
    int? newAge,
    double? newHeight,
    String? newCondition,
    String? newBloodGroup,
  }) {
    if (newName != null) {
      userName = newName;
      _settingsBox.put('userName', newName);
    }
    if (newEmail != null) {
      userEmail = newEmail;
      _settingsBox.put('userEmail', newEmail);
    }
    if (newAge != null) {
      userAge = newAge;
      _settingsBox.put('userAge', newAge);
    }
    if (newHeight != null) {
      userHeight = newHeight;
      _settingsBox.put('userHeight', newHeight);
    }
    if (newCondition != null) {
      userCondition = newCondition;
      _settingsBox.put('userCondition', newCondition);
    }
    if (newBloodGroup != null) {
      bloodGroup = newBloodGroup;
      _settingsBox.put('bloodGroup', newBloodGroup);
    }
    notifyListeners();
  }

  void saveNewHealthStat({
    double? newWeight,
    String? newHr,
    String? newBp,
    String? newBloodSugar,
    String? newHemo,
  }) {
    final w = newWeight ?? userWeight;
    final hr = newHr ?? heartRate;
    final bp = newBp ?? bloodPressure;
    final bs = newBloodSugar ?? bloodSugar;
    final hemo = newHemo ?? hemoglobin;

    final newRecord = HealthStatRecord(
      date: DateTime.now(),
      weight: w,
      heartRate: hr,
      bloodPressure: bp,
      bloodSugar: bs,
      hemoglobin: hemo,
    );
    _healthStatsBox.add(newRecord);

    userWeight = w;
    heartRate = hr;
    bloodPressure = bp;
    bloodSugar = bs;
    hemoglobin = hemo;
    _settingsBox.put('userWeight', w);
    _settingsBox.put('heartRate', hr);
    _settingsBox.put('bloodPressure', bp);
    _settingsBox.put('bloodSugar', bs);
    _settingsBox.put('hemoglobin', hemo);

    notifyListeners();
  }

  // Doctor Visit Prep Methods
  void saveVisitPrep(
    String symptoms,
    List<String> meds,
    List<String> reports,
    bool includeVitals,
  ) {
    visitSymptoms = symptoms;
    visitMedIds = meds;
    visitReportIds = reports;
    includeVitalsInVisit = includeVitals;
    _settingsBox.put('visitSymptoms', symptoms);
    _settingsBox.put('visitMedIds', meds);
    _settingsBox.put('visitReportIds', reports);
    _settingsBox.put('includeVitalsInVisit', includeVitals);
    notifyListeners();
  }

  void clearVisitPrep() {
    visitSymptoms = "";
    visitMedIds = [];
    visitReportIds = [];
    includeVitalsInVisit = false;
    _settingsBox.delete('visitSymptoms');
    _settingsBox.delete('visitMedIds');
    _settingsBox.delete('visitReportIds');
    _settingsBox.delete('includeVitalsInVisit');
    notifyListeners();
  }
}
