import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../app_state.dart'; 
import 'upload_report.dart'; 
import 'package:open_filex/open_filex.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final Color lightBlue = const Color(0xFFD6E2EB);
  final Color primaryBlue = const Color(0xFF087E8B);

  String _selectedTypeFilter = 'All';
  String _searchQuery = '';
  DateTime? _selectedDateFilter; 

  void _openReportFile(BuildContext context, MedicalReport report) async {
    if (report.filePath != '') {
      final result = await OpenFilex.open(report.filePath);
      if (result.type != ResultType.done && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open file: ${result.message}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('File path not found (Mock report)')),
      );
    }
  }

  void _confirmDeleteReport(BuildContext context, MedicalReport report) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Report'),
          content: const Text('Are you sure you want to delete this report?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<AppState>().deleteReport(report.id);
                Navigator.of(context).pop();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Report deleted.')),
                  );
                }
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickDateFilter(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateFilter ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: primaryBlue),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDateFilter = picked;
      });
    }
  }

  // --- NEW: Intercepts the tap to show the AI Overview ---
  void _handleReportTap(BuildContext context, MedicalReport report) {
    if (report.aiOverview != null && report.aiOverview!.isNotEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Row(
              children: [
                Icon(Icons.health_and_safety, color: primaryBlue),
                const SizedBox(width: 10),
                const Text('AI Overview', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              ],
            ),
            content: SingleChildScrollView(
              child: Text(
                report.aiOverview!,
                style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Close', style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: primaryBlue),
                onPressed: () {
                  Navigator.pop(dialogContext); 
                  _openReportFile(context, report); // Pass the original context to open the file
                },
                child: const Text('View Report', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      );
    } else {
      // If no overview exists, just open the file directly
      _openReportFile(context, report);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    final reportTypes = ['All', ...appState.reports.map((r) => r.type).toSet()];

    final filteredReports = appState.reports.where((r) {
      final matchesType = _selectedTypeFilter == 'All' || r.type == _selectedTypeFilter;
      final matchesSearch = r.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                            r.doctorName.toLowerCase().contains(_searchQuery.toLowerCase());
          
      final matchesDate = _selectedDateFilter == null ||
          (r.date.year == _selectedDateFilter!.year &&
           r.date.month == _selectedDateFilter!.month &&
           r.date.day == _selectedDateFilter!.day);

      return matchesType && matchesSearch && matchesDate; 
    }).toList();

    return Scaffold(
      backgroundColor: lightBlue,
      appBar: AppBar(
        title: const Text('My Reports', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        iconTheme: IconThemeData(color: primaryBlue),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  hintText: 'Search reports...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                ),
              ),
            ),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  ...reportTypes.map((type) {
                    final isSelected = _selectedTypeFilter == type;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ChoiceChip(
                        label: Text(type),
                        selected: isSelected,
                        onSelected: (selected) => setState(() => _selectedTypeFilter = type),
                        selectedColor: primaryBlue,
                        backgroundColor: Colors.white,
                        labelStyle: TextStyle(color: isSelected ? Colors.white : primaryBlue, fontWeight: FontWeight.bold),
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                    );
                  }),

                  InkWell(
                    onTap: () => _pickDateFilter(context),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: EdgeInsets.all(_selectedDateFilter == null ? 8 : 10),
                      decoration: BoxDecoration(
                        color: _selectedDateFilter == null ? Colors.white : primaryBlue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_month, color: _selectedDateFilter == null ? primaryBlue : Colors.white, size: 20),
                          if (_selectedDateFilter != null) ...[
                            const SizedBox(width: 6),
                            Text(
                              DateFormat('MMM d').format(_selectedDateFilter!),
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: () => setState(() => _selectedDateFilter = null),
                              child: const Icon(Icons.close, color: Colors.white, size: 16),
                            )
                          ]
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: filteredReports.isEmpty
                  ? const Center(child: Text('No reports found.', style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      itemCount: filteredReports.length,
                      itemBuilder: (context, index) {
                        return _buildReportCard(context, filteredReports[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const UploadReportScreen()));
        },
        backgroundColor: primaryBlue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildReportCard(BuildContext context, MedicalReport report) {
    IconData iconData = Icons.description;
    Color statusColor = Colors.grey;

    if (report.type.contains('Blood') || report.type.contains('CBC') || report.type.contains('Profile') || report.type.contains('Test')) {
      iconData = Icons.science;
      statusColor = Colors.green;
    } else if (report.type.contains('X-Ray') || report.type.contains('Radiology')) {
      iconData = Icons.image;
      statusColor = Colors.orange;
    } else if (report.type.contains('ECG') || report.type.contains('Heart') || report.type.contains('Echo')) {
      iconData = Icons.monitor_heart;
      statusColor = Colors.red;
    } else if (report.type.contains('Scan') || report.type.contains('MRI')) {
      iconData = Icons.microwave;
      statusColor = Colors.purple.shade800;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          // --- UPDATED: Call the new interceptor function instead of opening directly ---
          onTap: () => _handleReportTap(context, report), 
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: primaryBlue.withOpacity(0.2), width: 2),
                  ),
                  child: Icon(iconData, color: primaryBlue, size: 32),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        report.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('d MMM yyyy').format(report.date),
                        style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${report.doctorName} - ${report.hospitalName}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _confirmDeleteReport(context, report),
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  tooltip: 'Delete report',
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: primaryBlue.withOpacity(0.05), shape: BoxShape.circle),
                  child: Stack(
                    children: [
                      Icon(iconData, color: primaryBlue.withOpacity(0.3), size: 24),
                      Positioned(
                        right: 0, bottom: 0,
                        child: Container(
                          width: 8, height: 8,
                          decoration: BoxDecoration(
                            color: statusColor, shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}