import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'app_state.dart';
import 'medicine tracker pages/medi_manager.dart';
import 'visit_summary.dart';

class DoctorVisitScreen extends StatefulWidget {
  const DoctorVisitScreen({super.key});

  @override
  State<DoctorVisitScreen> createState() => _DoctorVisitScreenState();
}

bool includeLatestVitals = true; // Default to yes!

class _DoctorVisitScreenState extends State<DoctorVisitScreen> {
  final Color lightBlue = const Color(0xFFD6E2EB);
  final Color primaryBlue = const Color(0xFF087E8B);

  Set<String> selectedMeds = {};
  Set<String> selectedReports = {};
  final TextEditingController _symptomsController = TextEditingController();

  @override
  void dispose() {
    _symptomsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final medManager = context.watch<MediManager>();
    final appState = context.watch<AppState>();

    return Scaffold(
      backgroundColor: lightBlue,
      appBar: AppBar(
        title: const Text(
          'Doctor Visit Prep',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: primaryBlue),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How have you been feeling?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _symptomsController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText:
                    'Jot down any symptoms, pains, or questions for the doctor...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 30),

            if (appState.latestStat != null) ...[
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: SwitchListTile(
                  activeColor: primaryBlue,
                  title: const Text(
                    'Include Latest Vitals',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Recorded on: ${DateFormat('d MMM yyyy, h:mm a').format(appState.latestStat!.date)}',
                  ),
                  value: includeLatestVitals,
                  onChanged: (val) {
                    setState(() => includeLatestVitals = val);
                  },
                ),
              ),
              const SizedBox(height: 30),
            ],
            // --- SECTION 2: CURRENT MEDICATIONS ---
            const Text(
              'Select Medications to Discuss',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (medManager.medicines.isEmpty)
              const Text(
                "No active medications found.",
                style: TextStyle(color: Colors.grey),
              )
            else
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: medManager.medicines.length,
                  separatorBuilder: (context, index) =>
                      Divider(color: Colors.grey.shade200, height: 1),
                  itemBuilder: (context, index) {
                    final med = medManager.medicines[index];
                    final isSelected = selectedMeds.contains(med.id);

                    return CheckboxListTile(
                      activeColor: primaryBlue,
                      title: Text(
                        med.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${med.dose} • ${med.freqCount}x / ${med.freqType}',
                      ),
                      value: isSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selectedMeds.add(med.id);
                          } else {
                            selectedMeds.remove(med.id);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
            const SizedBox(height: 30),

            // --- SECTION 3: RELEVANT REPORTS ---
            const Text(
              'Select Reports to Show',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (appState.reports.isEmpty)
              const Text(
                "No reports uploaded yet.",
                style: TextStyle(color: Colors.grey),
              )
            else
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: appState.reports.length,
                  separatorBuilder: (context, index) =>
                      Divider(color: Colors.grey.shade200, height: 1),
                  itemBuilder: (context, index) {
                    final report = appState.reports[index];
                    final isSelected = selectedReports.contains(report.id);

                    return CheckboxListTile(
                      activeColor: primaryBlue,
                      title: Text(
                        report.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${report.type} • ${DateFormat('d MMM yyyy').format(report.date)}',
                      ),
                      value: isSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selectedReports.add(report.id);
                          } else {
                            selectedReports.remove(report.id);
                          }
                        });
                      },
                    );
                  },
                ),
              ),

            const SizedBox(height: 40),

            // --- FINISH BUTTON ---
            ElevatedButton(
              onPressed: () {
                context.read<AppState>().saveVisitPrep(
                  _symptomsController.text,
                  selectedMeds.toList(),
                  selectedReports.toList(),
                  includeLatestVitals, // Passes the switch state to the database!
                );
                Navigator.pushReplacementNamed(context, '/visit_summary');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                'Finish Prep',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
