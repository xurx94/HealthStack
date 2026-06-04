import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'medi_manager.dart';
import 'medicine.dart';

class adderform extends StatefulWidget {
  final medicine? medi;

  const adderform({super.key, this.medi});

  @override
  State<adderform> createState() => _adderformState();
}

class _adderformState extends State<adderform> {
  late TextEditingController namecontrol;
  late TextEditingController dosecontrol;
  DateTime? startDate;
  DateTime? enddate;

  String? freqCount;
  String? freqType;

  int n = 0;
  List<TimeOfDay?> time = [];

  final List<String> timesPerDayOptions = ['1', '2', '3', '4', '5', '6'];
  final List<String> durationOptions = [
    '1 day',
    '3 days',
    '5 days',
    '1 week',
    '2 weeks',
    '1 month',
    '3 months',
    'Continuous',
  ];

  @override
  void initState() {
    super.initState();

    namecontrol = TextEditingController(text: widget.medi?.name ?? '');
    dosecontrol = TextEditingController(text: widget.medi?.dose ?? '');

    if (widget.medi != null) {
      startDate = widget.medi!.start;
      enddate = widget.medi!.end;
      time = widget.medi!.time;
      freqCount = widget.medi!.freqCount;
      freqType = widget.medi!.freqType;
      n = time.length;
    }
  }

  void _calculateEndDate() {
    if (startDate == null || freqType == null) return;
    DateTime calcEnd = startDate!;

    switch (freqType) {
      case '1 day':
        calcEnd = startDate!.add(const Duration(days: 1));
        break;
      case '3 days':
        calcEnd = startDate!.add(const Duration(days: 3));
        break;
      case '5 days':
        calcEnd = startDate!.add(const Duration(days: 5));
        break;
      case '1 week':
        calcEnd = startDate!.add(const Duration(days: 7));
        break;
      case '2 weeks':
        calcEnd = startDate!.add(const Duration(days: 14));
        break;
      case '1 month':
        calcEnd = DateTime(
          startDate!.year,
          startDate!.month + 1,
          startDate!.day,
        );
        break;
      case '3 months':
        calcEnd = DateTime(
          startDate!.year,
          startDate!.month + 3,
          startDate!.day,
        );
        break;
      case 'Continuous':
        calcEnd = DateTime(
          startDate!.year + 5,
          startDate!.month,
          startDate!.day,
        );
        break;
    }

    setState(() {
      enddate = calcEnd;
    });
  }

  Future<void> _pickstartDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        startDate = picked;
        _calculateEndDate();
      });
    }
  }

  Future<void> _pickTime(int index) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        time[index] = picked;
      });
    }
  }

  @override
  void dispose() {
    namecontrol.dispose();
    dosecontrol.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD6E2EB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF087E8B),
        foregroundColor: Colors.white,
        title: Text(widget.medi == null ? 'Add Medicine' : 'Edit Medicine'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Medicine Name',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: namecontrol,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'e.g., Paracetamol',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Text(
                'Dosage Size',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: dosecontrol,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'e.g., 500mg or 1 pill',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Text(
                'Prescription Details',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        hint: const Text("Times a day"),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        initialValue: freqCount,
                        onChanged: (newValue) {
                          setState(() {
                            freqCount = newValue;
                            n = int.tryParse(freqCount ?? "0") ?? 0;
                            time = List.generate(
                              n,
                              (index) =>
                                  index < time.length ? time[index] : null,
                            );
                          });
                        },
                        items: timesPerDayOptions
                            .map(
                              (val) => DropdownMenuItem(
                                value: val,
                                child: Text("$val time(s)"),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        hint: const Text("For how long?"),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        initialValue: freqType,
                        onChanged: (newValue) {
                          setState(() {
                            freqType = newValue;
                            _calculateEndDate();
                          });
                        },
                        items: durationOptions
                            .map(
                              (item) => DropdownMenuItem(
                                value: item,
                                child: Text(item),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Start Date',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          tileColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          title: Text(
                            startDate == null
                                ? "Select"
                                : DateFormat('dd MMM yy').format(startDate!),
                            style: const TextStyle(fontSize: 15),
                          ),
                          trailing: Icon(
                            Icons.calendar_today,
                            color: Colors.indigo[900],
                            size: 20,
                          ),
                          onTap: _pickstartDate,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ends On',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            freqType == 'Continuous'
                                ? "Ongoing"
                                : (enddate == null
                                      ? "Auto-Calculated"
                                      : DateFormat(
                                          'dd MMM yyyy',
                                        ).format(enddate!)),
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              if (n > 0) ...[
                Text(
                  'Dose Times',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
              ],
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: n,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      tileColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      title: Text(
                        time[index] == null
                            ? "Select Time for Dose ${index + 1}"
                            : "Dose ${index + 1}: ${time[index]!.format(context)}",
                      ),
                      trailing: Icon(
                        Icons.access_time,
                        color: Colors.indigo[900],
                      ),
                      onTap: () => _pickTime(index),
                    ),
                  );
                },
              ),

              const SizedBox(height: 40),
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
                  onPressed: () async {
                    if (namecontrol.text.isEmpty ||
                        dosecontrol.text.isEmpty ||
                        startDate == null ||
                        enddate == null ||
                        time.contains(null) ||
                        freqType == null ||
                        freqCount == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please fill all fields")),
                      );
                      return;
                    }

                    final manager = Provider.of<MediManager>(
                      context,
                      listen: false,
                    );

                    if (widget.medi == null) {
                      final newMedicine = medicine(
                        name: namecontrol.text,
                        dose: dosecontrol.text,
                        freqType: freqType!,
                        freqCount: freqCount!,
                        start: startDate!,
                        end: enddate!,
                        time: time,
                      );

                      await manager.addMedicine(newMedicine);
                    } else {
                      // CRITICAL FIX: Resize the status list to match the new frequency!
                      List<bool> adjustedStatus = List.generate(
                        time.length,
                        (index) => index < widget.medi!.status.length
                            ? widget.medi!.status[index]
                            : false,
                      );

                      final updatedMedicine = widget.medi!.xerox(
                        name: namecontrol.text,
                        dose: dosecontrol.text,
                        freqType: freqType,
                        freqCount: freqCount,
                        start: startDate,
                        end: enddate,
                        time: time,
                        status: adjustedStatus, 
                      );

                      await manager.updateMedicine(updatedMedicine);
                    }

                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    widget.medi == null ? 'Save Medicine' : 'Update Medicine',
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