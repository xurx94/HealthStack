// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ContactAdapter extends TypeAdapter<Contact> {
  @override
  final int typeId = 1;

  @override
  Contact read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Contact(
      name: fields[0] as String,
      relation: fields[1] as String,
      contactNumber: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Contact obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.relation)
      ..writeByte(2)
      ..write(obj.contactNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContactAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProfileAdapter extends TypeAdapter<Profile> {
  @override
  final int typeId = 2;

  @override
  Profile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Profile(
      id: fields[0] as String?,
      name: fields[1] as String,
      condition: fields[2] as String,
      allergy: fields[3] as String,
      contact: (fields[4] as List).cast<Contact>(),
      hosName: fields[5] as String,
      hosAddress: fields[6] as String,
      hosAmbulance: fields[7] as String,
      profilePhotoPath: fields[8] as String?,
      photoBytes: fields[9] as Uint8List?,
    );
  }

  @override
  void write(BinaryWriter writer, Profile obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.condition)
      ..writeByte(3)
      ..write(obj.allergy)
      ..writeByte(4)
      ..write(obj.contact)
      ..writeByte(5)
      ..write(obj.hosName)
      ..writeByte(6)
      ..write(obj.hosAddress)
      ..writeByte(7)
      ..write(obj.hosAmbulance)
      ..writeByte(8)
      ..write(obj.profilePhotoPath)
      ..writeByte(9)
      ..write(obj.photoBytes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
