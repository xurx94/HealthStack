import 'package:uuid/uuid.dart';
import 'dart:typed_data';
import 'package:hive/hive.dart';

part 'profile.g.dart'; // REQUIRED: build_runner will create this

@HiveType(typeId: 1) // Unique ID for Contact
class Contact {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String relation;

  @HiveField(2)
  final String contactNumber;

  Contact({
    required this.name,
    required this.relation,
    required this.contactNumber,
  });
}

@HiveType(typeId: 2) // Unique ID for Profile
class Profile {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String condition;

  @HiveField(3)
  final String allergy;

  @HiveField(4)
  List<Contact> contact = [];

  @HiveField(5)
  final String hosName;

  @HiveField(6)
  final String hosAddress;

  @HiveField(7)
  final String hosAmbulance;

  @HiveField(8)
  final String? profilePhotoPath;

  @HiveField(9)
  final Uint8List? photoBytes;

  Profile({
    String? id,
    required this.name,
    required this.condition,
    required this.allergy,
    required this.contact,
    required this.hosName,
    required this.hosAddress,
    required this.hosAmbulance,
    this.profilePhotoPath,
    this.photoBytes,
  }) : id = id ?? const Uuid().v4();

  Profile copy({
    String? name,
    String? condition,
    String? allergy,
    List<Contact>? contact,
    String? hosName,
    String? hosAddress,
    String? hosAmbulance,
    String? profilePhotoPath,
    Uint8List? photoBytes,
  }) {
    return Profile(
      id: id,
      name: name ?? this.name,
      condition: condition ?? this.condition,
      allergy: allergy ?? this.allergy,
      contact: contact ?? List.from(this.contact),
      hosName: hosName ?? this.hosName,
      hosAddress: hosAddress ?? this.hosAddress,
      hosAmbulance: hosAmbulance ?? this.hosAmbulance,
      profilePhotoPath: profilePhotoPath ?? this.profilePhotoPath,
      photoBytes: photoBytes ?? this.photoBytes,
    );
  }
}
