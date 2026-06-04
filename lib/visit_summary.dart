import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart'; // NEW: Added to open reports!
import 'app_state.dart';
import 'medicine tracker pages/medi_manager.dart';

class VisitSummaryScreen extends StatelessWidget {
  const VisitSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final medManager = context.watch<MediManager>();

    final activeMeds = medManager.medicines
        .where((m) => appState.visitMedIds.contains(m.id))
        .toList();
    final activeReports = appState.reports
        .where((r) => appState.visitReportIds.contains(r.id))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'For The Doctor',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xFF087E8B)),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- SYMPTOMS SECTION ---
            if (appState.visitSymptoms.trim().isNotEmpty) ...[
              _buildSectionHeader(
                Icons.speaker_notes,
                'Current Symptoms & Notes',
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade100),
                ),
                child: Text(
                  appState.visitSymptoms,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],

            // --- VITALS SECTION (FIXED: NO MORE JAMMED TEXT) ---
            if (appState.includeVitalsInVisit &&
                appState.latestStat != null) ...[
              _buildSectionHeader(Icons.favorite, 'Latest Health Stats'),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.teal.shade100),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildVitalStat(
                            'Blood Pressure',
                            appState.latestStat!.bloodPressure,
                          ),
                        ),
                        Expanded(
                          child: _buildVitalStat(
                            'Blood Sugar',
                            '${appState.latestStat!.bloodSugar} mg/dL',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildVitalStat(
                            'Weight',
                            '${appState.latestStat!.weight} kg',
                          ),
                        ),
                        Expanded(
                          child: _buildVitalStat(
                            'Heart Rate',
                            '${appState.latestStat!.heartRate} bpm',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildVitalStat(
                            'Hemoglobin',
                            '${appState.latestStat!.hemoglobin} g/dL',
                          ),
                        ),
                        Expanded(
                          child: const SizedBox(),
                        ), // Empty space to keep grid aligned
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],

            // --- MEDICATIONS SECTION ---
            if (activeMeds.isNotEmpty) ...[
              _buildSectionHeader(Icons.medication, 'Current Medications'),
              const SizedBox(height: 10),
              ...activeMeds.map(
                (med) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.circle,
                        size: 10,
                        color: Color(0xFF087E8B),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              med.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${med.dose} • ${med.freqCount}x / ${med.freqType}',
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],

            // --- REPORTS SECTION (FIXED: NOW CLICKABLE!) ---
            if (activeReports.isNotEmpty) ...[
              _buildSectionHeader(Icons.folder_shared, 'Relevant Reports'),
              const SizedBox(height: 10),
              ...activeReports.map(
                (report) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () async {
                      // Opens the file when tapped!
                      if (report.filePath.isNotEmpty) {
                        final result = await OpenFilex.open(report.filePath);
                        if (result.type != ResultType.done && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Could not open file: ${result.message}',
                              ),
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('File path not found')),
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.description,
                            color: Color(0xFF087E8B),
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  report.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  '${report.type} • ${DateFormat('d MMM yyyy').format(report.date)}',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.open_in_new,
                            color: Colors.grey,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],

            // Empty State
            if (appState.visitSymptoms.trim().isEmpty &&
                activeMeds.isEmpty &&
                activeReports.isEmpty &&
                !appState.includeVitalsInVisit)
              const Center(
                child: Text(
                  "Nothing selected for this visit.",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),

            // --- MARK AS VISITED BUTTON ---
            if (appState.hasActiveVisit)
              ElevatedButton(
                onPressed: () {
                  context.read<AppState>().clearVisitPrep();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF087E8B),
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Mark as Visited',
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

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF087E8B), size: 28),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF087E8B),
          ),
        ),
      ],
    );
  }

  // A new helper widget to format the vital signs neatly into columns
  Widget _buildVitalStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.teal.shade700,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
