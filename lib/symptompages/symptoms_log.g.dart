// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'symptoms_log.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SymptomLogAdapter extends TypeAdapter<SymptomLog> {
  @override
  final int typeId = 5;

  @override
  SymptomLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SymptomLog(
      dateKey: fields[0] as String,
      categorySelections: (fields[1] as Map).map((dynamic k, dynamic v) =>
          MapEntry(k as String, (v as List).cast<String>())),
      savedAt: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SymptomLog obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.dateKey)
      ..writeByte(1)
      ..write(obj.categorySelections)
      ..writeByte(2)
      ..write(obj.savedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SymptomLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
