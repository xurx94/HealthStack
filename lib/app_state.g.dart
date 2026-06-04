// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MedicalReportAdapter extends TypeAdapter<MedicalReport> {
  @override
  final int typeId = 3;

  @override
  MedicalReport read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MedicalReport(
      id: fields[0] as String,
      name: fields[1] as String,
      type: fields[2] as String,
      doctorName: fields[3] as String,
      hospitalName: fields[4] as String,
      date: fields[5] as DateTime,
      fileName: fields[6] as String,
      filePath: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MedicalReport obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.doctorName)
      ..writeByte(4)
      ..write(obj.hospitalName)
      ..writeByte(5)
      ..write(obj.date)
      ..writeByte(6)
      ..write(obj.fileName)
      ..writeByte(7)
      ..write(obj.filePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicalReportAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HealthStatRecordAdapter extends TypeAdapter<HealthStatRecord> {
  @override
  final int typeId = 4;

  @override
  HealthStatRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HealthStatRecord(
      date: fields[0] as DateTime,
      weight: fields[1] as double,
      heartRate: fields[2] as String,
      bloodPressure: fields[3] as String,
      hemoglobin: fields[4] as String,
      bloodSugar: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HealthStatRecord obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.weight)
      ..writeByte(2)
      ..write(obj.heartRate)
      ..writeByte(3)
      ..write(obj.bloodPressure)
      ..writeByte(4)
      ..write(obj.hemoglobin)
      ..writeByte(5)
      ..write(obj.bloodSugar);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthStatRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
