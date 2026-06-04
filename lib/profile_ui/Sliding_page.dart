import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'profileManager.dart';

class Sliding_page extends StatefulWidget {
  const Sliding_page({super.key});

  @override
  State<Sliding_page> createState() => _Sliding_pageState();
}

class _Sliding_pageState extends State<Sliding_page> {
  final Color primaryBlue = const Color(0xFF087E8B);

  ImageProvider _getAvatarImage(dynamic profile) {
    // 1. Check for bytes (Fastest)
    if (profile?.photoBytes != null) {
      // Wrap in ResizeImage to shrink it during decode, saving massive RAM
      return ResizeImage(MemoryImage(profile.photoBytes!), width: 150);
    }

    // 2. Check for File Path
    if (profile?.profilePhotoPath != null && !kIsWeb) {
      final file = File(profile.profilePhotoPath!);
      // Ensure the file actually still exists on the device to prevent crashes
      if (file.existsSync()) {
        return ResizeImage(FileImage(file), width: 150);
      }
    }

    // 3. Fallback to Asset
    return const ResizeImage(AssetImage('assets/60111.jpg'), width: 150);
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // --- APP LOGO IN ABOUT DIALOG ---
            Image.asset(
              'assets/logo.png',
              width: 150,
              errorBuilder: (c, e, s) => const Icon(
                Icons.local_hospital,
                size: 80,
                color: Color(0xFF087E8B),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "HealthStack",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF087E8B),
              ),
            ),
            const SizedBox(height: 10),
            const Text("Version 1.1.0", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            const Text(
              "Your complete personal health companion.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 20),
            Text(
              "Created by 2303094 and 2303087",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.lightBlue.shade900,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Profilemanager>(
      builder: (context, manager, child) {
        final profile = manager.profiles.isNotEmpty
            ? manager.profiles.first
            : null;

        return Drawer(
          backgroundColor: const Color(0xFFD6E2EB),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Drawer Header Area ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 50, bottom: 20, left: 20),
                color: primaryBlue,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "HealthStack",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Menu",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // --- TOP POSITION: Profile Card ---
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    Navigator.pushNamed(
                      context,
                      '/profile',
                    ); // Navigate to profile page
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: _getAvatarImage(profile),
                          radius: 22.0,
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Text(
                            profile?.name.isEmpty ?? true
                                ? 'Your Profile Name'
                                : profile!.name,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          color: Colors.grey,
                        ), // Visual cue to tap
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // --- Menu Items ---
              // Blurred out items for future implementation
              TileBuildingBlock(
                icon: Icons.palette_outlined,
                name: 'Theme',
                isEnabled: false,
              ),
              TileBuildingBlock(
                icon: Icons.language_outlined,
                name: 'Language',
                isEnabled: false,
              ),
              TileBuildingBlock(
                icon: Icons.settings_outlined,
                name: 'Settings',
                isEnabled: false,
              ),

              // Active Items
              TileBuildingBlock(
                icon: Icons.help_outline,
                name: 'About Us',
                ontap: () {
                  Navigator.pop(context);
                  _showAboutDialog(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class TileBuildingBlock extends StatelessWidget {
  final IconData icon;
  final String name;
  final bool isred;
  final VoidCallback? ontap; // Made nullable so we can pass null when disabled
  final bool isEnabled; // Added property to handle disabled state

  const TileBuildingBlock({
    super.key,
    required this.icon,
    required this.name,
    this.ontap, // No longer required
    this.isred = false,
    this.isEnabled = true, // Defaults to true unless specified
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: Opacity(
        // Blurs the entire tile if it is not enabled
        opacity: isEnabled ? 1.0 : 0.4,
        child: ListTile(
          tileColor: Colors.black.withOpacity(.05),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          leading: Icon(
            icon,
            color: isred ? Colors.red[400] : const Color(0xFF087E8B),
          ),
          title: Text(
            name,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          // Disables tap logic and visual splash effect if not enabled
          onTap: isEnabled ? ontap : null,
        ),
      ),
    );
  }
}
