import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/medicine%20tracker%20pages/hover_card.dart'; // Ensure this path matches your project exactly
import 'medi_manager.dart';
import 'adder_form.dart';

class medilist extends StatefulWidget {
  const medilist({super.key});

  @override
  State<medilist> createState() => _medilistState();
}

class _medilistState extends State<medilist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD6E2EB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD6E2EB),
        title: const Text('Medication Log'),
        centerTitle: true,
      ),
      body: Consumer<MediManager>(
        builder: (context, manager, child) {
          if (manager.medicines.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No medicine added Yet',
                    style: TextStyle(color: Colors.grey[700], fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Tap the + button to start the log!',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: manager.medicines.length,
            itemBuilder: (context, index) {
              final med = manager.medicines[index];

              return Column(
                children: [
                  HoverCard(
                    width: double.infinity,
                    height: null,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => adderform(medi: med)),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: Colors.indigo[50],
                                child: Icon(
                                  Icons.medication_outlined,
                                  color: Colors.indigo[900],
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 15),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      med.name,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      "${med.dose} • ${med.freqCount} time(s) a day for ${med.freqType}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                  size: 28,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text("Delete Medicine?"),
                                      content: Text(
                                        "Are you sure you want to remove ${med.name}?",
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(ctx),
                                          child: const Text("Cancel"),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                          ),
                                          onPressed: () {
                                            Provider.of<MediManager>(
                                              context,
                                              listen: false,
                                            ).deleteMedicine(med.id);

                                            Navigator.pop(ctx);

                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  '${med.name} deleted',
                                                ),
                                              ),
                                            );
                                          },
                                          child: const Text(
                                            "Delete",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 15),

                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: List.generate(med.time.length, (i) {
                              
                              // CRITICAL FIX: Safe database bounds check!
                              bool isTaken = i < med.status.length ? med.status[i] : false;
                              bool isOverdue =
                                  !isTaken && _isPastTime(med.time[i]);

                              final backgroundColor = isTaken
                                  ? Colors.green[100]
                                  : isOverdue
                                  ? Colors.red[100]
                                  : Colors.grey[100];
                              final borderColor = isTaken
                                  ? Colors.green
                                  : isOverdue
                                  ? Colors.red
                                  : Colors.grey[400]!;
                              final iconData = isTaken
                                  ? Icons.check_circle
                                  : isOverdue
                                  ? Icons.error_outline
                                  : Icons.circle_outlined;
                              final iconColor = isTaken
                                  ? Colors.green[800]
                                  : isOverdue
                                  ? Colors.red[800]
                                  : Colors.grey[600];
                              final label = med.time[i] != null
                                  ? '${med.time[i]!.format(context)}${isOverdue ? ' • missed' : ''}'
                                  : 'Dose ${i + 1}';

                              return InkWell(
                                onTap: () {
                                  // CRITICAL FIX: Safely recreate the status list before updating
                                  List<bool> newStatus = List.generate(
                                    med.time.length,
                                    (index) => index < med.status.length ? med.status[index] : false,
                                  );
                                  
                                  newStatus[i] = !newStatus[i];
                                  final updatedMed = med.xerox(
                                    status: newStatus,
                                  );

                                  Provider.of<MediManager>(
                                    context,
                                    listen: false,
                                  ).updateMedicine(updatedMed);
                                },
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: backgroundColor,
                                    border: Border.all(color: borderColor),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        iconData,
                                        color: iconColor,
                                        size: 22,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        label,
                                        style: TextStyle(
                                          color: isTaken
                                              ? Colors.green[900]
                                              : isOverdue
                                              ? Colors.red[900]
                                              : Colors.grey[800],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/adderform');
        },
        backgroundColor: const Color.fromARGB(255, 0, 135, 165),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }

  bool _isPastTime(TimeOfDay? scheduledTime) {
    if (scheduledTime == null) return false;
    final now = TimeOfDay.now();
    final nowMinutes = now.hour * 60 + now.minute;
    final scheduledMinutes = scheduledTime.hour * 60 + scheduledTime.minute;
    return scheduledMinutes < nowMinutes;
  }
}