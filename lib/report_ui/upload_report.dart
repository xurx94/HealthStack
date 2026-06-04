import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../app_state.dart';

class UploadReportScreen extends StatefulWidget {
  const UploadReportScreen({super.key});

  @override
  State<UploadReportScreen> createState() => _UploadReportScreenState();
}

class _UploadReportScreenState extends State<UploadReportScreen> {
  final Color lightBlue = const Color(0xFFD6E2EB);
  final Color primaryBlue = const Color(0xFF087E8B);

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _doctorController = TextEditingController();
  final _hospitalController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  String? _selectedFileName;
  String? _selectedFilePath;
  String? _selectedReportType;
  bool _isScanning = false;

  final List<String> _reportTypes = [
    'Prescription',
    'CBC/Blood Test',
    'X-Ray',
    'MRI',
    'CT Scan',
    'Ultrasound',
    'ECG',
    'Echo',
    'Liver Function Test',
    'Kidney Function Test',
    'Lipid Profile',
    'Thyroid Profile',
    'Urine Test',
    'Biopsy Report',
    'Endoscopy Report',
    'Vaccination Record',
    'Operation/Surgery Report',
    'Other',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _doctorController.dispose();
    _hospitalController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
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
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        setState(() {
          _selectedFileName = result.files.single.name;
          _selectedFilePath = result.files.single.path;
        });
      }
    } catch (e) {
      debugPrint("Error picking file: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('File system not supported on this device.'),
        ),
      );
    }
  }

  Future<String?> _saveToAppStorage(String sourcePath) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = path.basename(sourcePath);
      final uniqueName = '${DateTime.now().millisecondsSinceEpoch}_$fileName';
      final newPath = '${appDir.path}/$uniqueName';
      await File(sourcePath).copy(newPath);
      return newPath;
    } catch (e) {
      debugPrint("Error saving file: $e");
      return null;
    }
  }

  Future<void> _showAIConfirmationDialog({
    String? bp,
    String? sugar,
    String? hemo,
    String? hr,
    double? weight,
    String? overview,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.auto_awesome, color: Colors.deepPurple),
              SizedBox(width: 10),
              Text(
                'AI Report Analysis',
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (overview != null && overview.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade100),
                    ),
                    child: Text(
                      overview,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.4,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                const Text(
                  "Extracted Vitals:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),
                if (bp != null)
                  Text(
                    "• Blood Pressure: $bp",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                if (sugar != null)
                  Text(
                    "• Blood Sugar: $sugar",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                if (hemo != null)
                  Text(
                    "• Hemoglobin: $hemo",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                if (hr != null)
                  Text(
                    "• Heart Rate: $hr",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                if (weight != null)
                  Text(
                    "• Weight: $weight kg",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                if (bp == null &&
                    sugar == null &&
                    hemo == null &&
                    hr == null &&
                    weight == null)
                  const Text(
                    "No specific vitals found to update.",
                    style: TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pop();
              },
            ),
            if (bp != null ||
                sugar != null ||
                hemo != null ||
                hr != null ||
                weight != null)
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: primaryBlue),
                child: const Text(
                  'Update Stats',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  context.read<AppState>().saveNewHealthStat(
                    newBp: bp,
                    newBloodSugar: sugar,
                    newHemo: hemo,
                    newHr: hr,
                    newWeight: weight,
                  );
                  Navigator.of(dialogContext).pop();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Report & Stats Saved Successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
              ),
          ],
        );
      },
    );
  }

  Future<void> _saveAndAnalyzeReport() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedFileName == null || _selectedFilePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a file to upload')),
      );
      return;
    }

    setState(() => _isScanning = true);

    try {
      // 1. SAVE THE FILE LOCALLY FIRST
      final String? safePath = await _saveToAppStorage(_selectedFilePath!);
      if (safePath == null) throw Exception("Failed to save file securely.");

      // 2. PREPARE FILE FOR SCANNING
      String extension = _selectedFilePath!.split('.').last.toLowerCase();
      String rawText = "";
      Uint8List? pdfBytes;
      String? foundOverview;

      if (extension == 'pdf') {
        pdfBytes = await File(_selectedFilePath!).readAsBytes();
      } else if (['jpg', 'jpeg', 'png'].contains(extension)) {
        final inputImage = InputImage.fromFilePath(_selectedFilePath!);
        final textRecognizer = TextRecognizer(
          script: TextRecognitionScript.latin,
        );
        final RecognizedText recognizedText = await textRecognizer.processImage(
          inputImage,
        );
        rawText = recognizedText.text;
        await textRecognizer.close();
      }

      // 3. THE AI BRAIN
      String? foundBp, foundSugar, foundHemo, foundHr;
      double? foundWeight;

      if (rawText.trim().isNotEmpty || pdfBytes != null) {
        final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
        if (apiKey.isEmpty) throw Exception("API Key not found in .env file.");

        final model = GenerativeModel(
          model: 'gemini-2.5-flash',
          apiKey: apiKey,
        );

        final promptText =
            '''
          You are an expert medical AI assistant. Read this lab report carefully.
          1. Find the current patient vitals if they exist.
          2. Write a brief, easy-to-understand overview of the report IN BENGALI (Bangla). Explain any major normal or abnormal findings (e.g., high WBC means fighting infection) and give basic helpful tips like drinking water or consulting a doctor.

          Return ONLY a raw JSON object with the exact keys: "bp", "sugar", "hemo", "hr", "weight", and "overview_bn".
          Do not include markdown formatting, backticks, or extra text. Just the JSON.
          If a vital is missing or you are unsure, use null.
          ${rawText.isNotEmpty ? '\nRAW TEXT:\n$rawText' : ''}
        ''';

        final content = pdfBytes != null
            ? Content.multi([
                TextPart(promptText),
                DataPart('application/pdf', pdfBytes),
              ])
            : Content.text(promptText);

        try {
          final response = await model.generateContent([content]);
          String jsonString =
              response.text
                  ?.replaceAll('```json', '')
                  .replaceAll('```', '')
                  .trim() ??
              '{}';
          final Map<String, dynamic> data = jsonDecode(jsonString);

          foundBp = data['bp']?.toString();
          foundSugar = data['sugar']?.toString();
          foundHemo = data['hemo']?.toString();
          foundHr = data['hr']?.toString();
          foundWeight = data['weight'] != null
              ? double.tryParse(data['weight'].toString())
              : null;
          foundOverview = data['overview_bn']?.toString();
        } catch (e) {
          debugPrint("AI JSON Parsing skipped or failed: $e");
        }
      }

      // 4. SAVE REPORT TO STATE WITH THE AI OVERVIEW
      final newReport = MedicalReport(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        type: _selectedReportType!,
        doctorName: _doctorController.text,
        hospitalName: _hospitalController.text,
        date: _selectedDate,
        fileName: _selectedFileName!,
        filePath: safePath,
        aiOverview: foundOverview, // Saves the Bangla text to your database!
      );

      if (mounted) context.read<AppState>().addReport(newReport);

      // 5. ROUTE TO POPUP IF DATA FOUND
      if (foundBp != null ||
          foundSugar != null ||
          foundHemo != null ||
          foundHr != null ||
          foundOverview != null) {
        if (mounted) {
          setState(() => _isScanning = false);
          await _showAIConfirmationDialog(
            bp: foundBp,
            sugar: foundSugar,
            hemo: foundHemo,
            hr: foundHr,
            weight: foundWeight,
            overview: foundOverview,
          );
          return;
        }
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Report Saved!'),
            backgroundColor: Colors.blueGrey,
          ),
        );
      }
    } catch (e) {
      debugPrint("Scan Error: $e");
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Report Saved. (AI Scan failed)'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isScanning = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBlue,
      appBar: AppBar(
        title: const Text(
          'Upload Report',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: primaryBlue),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(
                _nameController,
                'Report Name',
                'e.g., Lipid Profile',
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedReportType,
                  decoration: InputDecoration(
                    labelText: 'Report Type',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                  ),
                  items: _reportTypes.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (String? newValue) =>
                      setState(() => _selectedReportType = newValue),
                  validator: (value) =>
                      value == null ? 'Please select a type' : null,
                ),
              ),
              _buildTextField(
                _doctorController,
                'Doctor Name',
                'e.g., Dr. Smith',
              ),
              _buildTextField(
                _hospitalController,
                'Hospital/Clinic',
                'e.g., City General',
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () => _pickDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Date: ${DateFormat('d MMM yyyy').format(_selectedDate)}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      Icon(Icons.calendar_today, color: primaryBlue),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: _pickFile,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _selectedFileName == null
                        ? Colors.white
                        : primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: _selectedFileName == null
                          ? Colors.grey.shade300
                          : primaryBlue,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _selectedFileName == null
                            ? Icons.cloud_upload_outlined
                            : Icons.check_circle,
                        size: 40,
                        color: _selectedFileName == null
                            ? Colors.grey
                            : primaryBlue,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _selectedFileName ?? "Tap to select file (PDF, JPG)",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _selectedFileName == null
                              ? Colors.grey
                              : primaryBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isScanning ? null : _saveAndAnalyzeReport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: _isScanning
                    ? const SizedBox(
                        width: 25,
                        height: 25,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : const Text(
                        'Save & Analyze Report',
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
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String hint,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? 'Required' : null,
      ),
    );
  }
}
