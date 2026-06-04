import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'Edit_profiles.dart';
import 'profileManager.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Color primaryBlue = const Color(0xFF087E8B);

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
        withData: kIsWeb, // Crucial for Web
      );

      if (result != null) {
        final manager = context.read<Profilemanager>();
        if (manager.profiles.isEmpty) return;

        final profile = manager.profiles.first;

        if (kIsWeb) {
          // Web handling
          final bytes = result.files.single.bytes;
          if (bytes != null) {
            manager.updateProfiles(profile.copy(photoBytes: bytes));
          }
        } else {
          // Mobile handling
          final path = result.files.single.path;
          if (path != null) {
            manager.updateProfiles(profile.copy(profilePhotoPath: path));
          }
        }
      }
    } catch (e) {
      debugPrint("Error picking file: $e");
    }
  }

  // Helper to safely load the avatar image anywhere
  ImageProvider _getAvatarImage(dynamic profile) {
    if (profile?.photoBytes != null) return MemoryImage(profile.photoBytes!);
    if (profile?.profilePhotoPath != null && !kIsWeb) {
      return FileImage(File(profile.profilePhotoPath!));
    }
    return const ResizeImage(AssetImage('assets/60111.jpg'), width: 150);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD6E2EB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD6E2EB),
        shadowColor: Colors.black,
        elevation: 2,
        // This smartly checks if there is a screen to go back to!
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black87),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: const Text('Profile', style: TextStyle(color: Colors.black87)),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Consumer<Profilemanager>(
        builder: (context, manager, child) {
          final profile = manager.profiles.isNotEmpty
              ? manager.profiles.first
              : null;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          radius: 50, // Slightly larger for better look
                          backgroundImage: _getAvatarImage(profile),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickFile,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: primaryBlue,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(height: 40.0, color: Colors.blueGrey),

                  // Info Rows...
                  _buildInfoRow(
                    Icons.person_outlined,
                    'Name',
                    profile?.name.isEmpty ?? true ? 'User Name' : profile!.name,
                  ),
                  const SizedBox(height: 15),
                  _buildInfoRow(
                    Icons.health_and_safety,
                    'Current Medical Condition',
                    profile?.condition.isEmpty ?? true
                        ? 'Condition'
                        : profile!.condition,
                  ),
                  const SizedBox(height: 15),
                  _buildInfoRow(
                    Icons.warning_amber_rounded,
                    'Allergies',
                    profile?.allergy.isEmpty ?? true
                        ? 'State of allergy'
                        : profile!.allergy,
                  ),

                  const SizedBox(height: 30),
                  const Row(
                    children: [
                      Icon(
                        Icons.contact_emergency_outlined,
                        color: Colors.blueGrey,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Emergency Contact List',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  Column(
                    children:
                        profile?.contact
                            .map(
                              (c) => Card(
                                margin: const EdgeInsets.only(bottom: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  title: Text(
                                    c.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(c.contactNumber),
                                  trailing: Text(
                                    c.relation,
                                    style: TextStyle(
                                      color: primaryBlue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList() ??
                        [],
                  ),

                  const SizedBox(height: 30),
                  const Row(
                    children: [
                      Icon(Icons.local_hospital, color: Colors.blueGrey),
                      SizedBox(width: 10),
                      Text(
                        'Nearest Hospital Info',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHospitalText(
                          'Name: ',
                          profile?.hosName.isEmpty ?? true
                              ? 'Rajshahi Medical College Hospital'
                              : profile!.hosName,
                        ),
                        const SizedBox(height: 8),
                        _buildHospitalText(
                          'Address: ',
                          profile?.hosAddress.isEmpty ?? true
                              ? 'Lashmipur, Rajshahi'
                              : profile!.hosAddress,
                        ),
                        const SizedBox(height: 8),
                        _buildHospitalText(
                          'Ambulance: ',
                          profile?.hosAmbulance.isEmpty ?? true
                              ? '09********'
                              : profile!.hosAmbulance,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final manager = context.read<Profilemanager>();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditProfiles(
                profile: manager.profiles.isNotEmpty
                    ? manager.profiles.first
                    : null,
              ),
            ),
          );
        },
        backgroundColor: primaryBlue,
        child: const Icon(Icons.edit, color: Colors.white, size: 28),
      ),
    );
  }

  // Helper Widgets for cleaner code
  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.blueGrey, size: 28),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 16.0, color: Colors.blueGrey),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHospitalText(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16.0, color: Colors.blueGrey),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
