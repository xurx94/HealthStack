import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'profile.dart';
import 'profileManager.dart';

class EditProfiles extends StatefulWidget {
  final Profile? profile;

  const EditProfiles({super.key, this.profile});

  @override
  State<EditProfiles> createState() => _EditProfilesState();
}

class _EditProfilesState extends State<EditProfiles> {
  late TextEditingController name;
  late TextEditingController condition;
  late TextEditingController allergy;
  List<TextEditingController> conNameControllers = [];
  List<TextEditingController> conRelationControllers = [];
  List<TextEditingController> conNumberControllers = [];
  late TextEditingController hosName;
  late TextEditingController hosAddress;
  late TextEditingController hosAmbulance;

  @override
  void initState() {
    super.initState();

    name = TextEditingController(text: widget.profile?.name ?? '');
    condition = TextEditingController(text: widget.profile?.condition ?? '');
    allergy = TextEditingController(text: widget.profile?.allergy ?? '');

    hosName = TextEditingController(text: widget.profile?.hosName ?? '');
    hosAddress = TextEditingController(text: widget.profile?.hosAddress ?? '');
    hosAmbulance = TextEditingController(
      text: widget.profile?.hosAmbulance ?? '',
    );

    if (widget.profile != null && widget.profile!.contact.isNotEmpty) {
      for (var contact in widget.profile!.contact) {
        conNameControllers.add(TextEditingController(text: contact.name));
        conRelationControllers.add(
          TextEditingController(text: contact.relation),
        );
        conNumberControllers.add(
          TextEditingController(text: contact.contactNumber),
        );
      }
    } else {
      conNameControllers.add(TextEditingController());
      conRelationControllers.add(TextEditingController());
      conNumberControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    name.dispose();
    condition.dispose();
    allergy.dispose();
    for (var c in conNameControllers) {
      c.dispose();
    }
    for (var c in conRelationControllers) {
      c.dispose();
    }
    for (var c in conNumberControllers) {
      c.dispose();
    }
    hosName.dispose();
    hosAddress.dispose();
    hosAmbulance.dispose();
    super.dispose();
  }

  void addContact() {
    setState(() {
      conNameControllers.add(TextEditingController());
      conRelationControllers.add(TextEditingController());
      conNumberControllers.add(TextEditingController());
    });
  }

  String formatOrdinal(int number) {
    if (number >= 11 && number <= 13) {
      return '${number}th';
    }
    switch (number % 10) {
      case 1:
        return '${number}st';
      case 2:
        return '${number}nd';
      case 3:
        return '${number}rd';
      default:
        return '${number}th';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD6E2EB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF087E8B),
        foregroundColor: Colors.white,
        title: Text(widget.profile == null ? 'Add Profile' : 'Edit Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profile Name',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: name,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'e.g., Your name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Current Medical Condition',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: condition,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'e.g., Fever / Cold',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Any Allergies',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: allergy,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'e.g., Peanut / Sesame',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Emergency Contact Names',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: addContact,
                    backgroundColor: const Color(0xFF087E8B),
                    mini: true,
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Column(
                children: List.generate(conNameControllers.length, (index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${formatOrdinal(index + 1)} Contact',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextField(
                        controller: conNameControllers[index],
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'e.g., Contact name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: conRelationControllers[index],
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Relation',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: conNumberControllers[index],
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Phone number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                }),
              ),
              const SizedBox(height: 20),
              Text(
                'Hospital Name',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: hosName,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Hospital name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: hosAddress,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Hospital address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: hosAmbulance,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Ambulance number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF087E8B),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // FIX: ONLY Profile Name is strictly required now.
                    if (name.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Profile Name is required"),
                        ),
                      );
                      return; // Stops here if name is empty
                    }

                    final manager = Provider.of<Profilemanager>(
                      context,
                      listen: false,
                    );

                    List<Contact> contactList = [];
                    for (int i = 0; i < conNameControllers.length; i++) {
                      // Only add the contact if they actually typed a name
                      if (conNameControllers[i].text.trim().isNotEmpty) {
                        contactList.add(
                          Contact(
                            name: conNameControllers[i].text,
                            relation: conRelationControllers[i].text,
                            contactNumber: conNumberControllers[i].text,
                          ),
                        );
                      }
                    }

                    if (widget.profile == null) {
                      final newProfile = Profile(
                        name: name.text,
                        condition: condition.text,
                        allergy: allergy.text,
                        hosName: hosName.text,
                        hosAddress: hosAddress.text,
                        hosAmbulance: hosAmbulance.text,
                        contact: contactList,
                      );
                      manager.addProfile(newProfile);
                    } else {
                      // Uses your custom copy method from profile.dart
                      final updatedProfile = widget.profile!.copy(
                        name: name.text,
                        condition: condition.text,
                        allergy: allergy.text,
                        hosName: hosName.text,
                        hosAddress: hosAddress.text,
                        hosAmbulance: hosAmbulance.text,
                        contact: contactList,
                        // *Note: Because you are calling widget.profile!.copy(),
                        // your image variables (like photoBytes) are automatically
                        // carried over from the old profile into the updated one!
                      );
                      manager.updateProfiles(updatedProfile);
                    }
                    Navigator.pop(context);
                  },
                  child: Text(
                    widget.profile == null ? 'Save Profile' : 'Update Profile',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
