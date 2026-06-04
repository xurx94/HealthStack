import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';

part 'medicine.g.dart'; // REQUIRED: build_runner will create this file for you

@HiveType(typeId: 0) // Unique ID for the Medicine box
class medicine {
  @HiveField(0)
  final String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String dose;

  @HiveField(3)
  late String freqType;

  @HiveField(4)
  late String freqCount;

  @HiveField(5)
  late DateTime start;

  @HiveField(6)
  late DateTime end;

  @HiveField(7)
  List<TimeOfDay?> time = [];

  @HiveField(8)
  List<bool> status = [];

  @HiveField(9)
  int nowIndex;

  medicine({
    String? id,
    required this.name,
    required this.dose,
    required this.freqType,
    required this.freqCount,
    required this.start,
    required this.end,
    required this.time,
    this.nowIndex = 0,
    List<bool>? status,
  }) : id = id ?? const Uuid().v4(),
       status = status ?? List.generate(time.length, (_) => false);

  medicine xerox({
    String? name,
    String? dose,
    String? freqType,
    String? freqCount,
    DateTime? start,
    DateTime? end,
    List<TimeOfDay?>? time,
    List<bool>? status,
    int? nowIndex,
  }) {
    return medicine(
      id: id,
      name: name ?? this.name,
      dose: dose ?? this.dose,
      freqType: freqType ?? this.freqType,
      freqCount: freqCount ?? this.freqCount,
      start: start ?? this.start,
      end: end ?? this.end,
      time: time ?? List.from(this.time),
      status: status ?? List.from(this.status),
      nowIndex: nowIndex ?? this.nowIndex,
    );
  }
}
