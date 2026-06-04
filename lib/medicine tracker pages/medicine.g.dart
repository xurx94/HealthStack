// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class medicineAdapter extends TypeAdapter<medicine> {
  @override
  final int typeId = 0;

  @override
  medicine read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return medicine(
      id: fields[0] as String?,
      name: fields[1] as String,
      dose: fields[2] as String,
      freqType: fields[3] as String,
      freqCount: fields[4] as String,
      start: fields[5] as DateTime,
      end: fields[6] as DateTime,
      time: (fields[7] as List).cast<TimeOfDay?>(),
      nowIndex: fields[9] as int,
      status: (fields[8] as List?)?.cast<bool>(),
    );
  }

  @override
  void write(BinaryWriter writer, medicine obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.dose)
      ..writeByte(3)
      ..write(obj.freqType)
      ..writeByte(4)
      ..write(obj.freqCount)
      ..writeByte(5)
      ..write(obj.start)
      ..writeByte(6)
      ..write(obj.end)
      ..writeByte(7)
      ..write(obj.time)
      ..writeByte(8)
      ..write(obj.status)
      ..writeByte(9)
      ..write(obj.nowIndex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is medicineAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
