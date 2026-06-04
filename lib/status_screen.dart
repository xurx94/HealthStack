import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  final Color lightBlue = const Color(0xFFD6E2EB);
  final Color primaryBlue = const Color(0xFF087E8B);

  Map<String, dynamic> _calculateBMI(double heightCm, double weightKg) {
    if (heightCm <= 0 || weightKg <= 0) {
      return {'value': 0.0, 'category': 'N/A', 'color': Colors.grey};
    }
    double heightM = heightCm / 100;
    double bmi = weightKg / (heightM * heightM);

    if (bmi < 18.5)
      return {'value': bmi, 'category': "Underweight", 'color': Colors.orange};
    if (bmi < 25)
      return {'value': bmi, 'category': "Normal", 'color': Colors.green};
    if (bmi < 30)
      return {'value': bmi, 'category': "Overweight", 'color': Colors.orange};
    return {'value': bmi, 'category': "Obese", 'color': Colors.red};
  }

  Map<String, dynamic> _analyzeHeartRate(String hrString) {
    int? hr = int.tryParse(hrString);
    if (hr == null) return {'msg': 'Unknown', 'color': Colors.grey};
    if (hr < 60) return {'msg': 'Low (Bradycardia)', 'color': Colors.orange};
    if (hr <= 100) return {'msg': 'Normal', 'color': Colors.green};
    return {'msg': 'High (Tachycardia)', 'color': Colors.red};
  }

  Map<String, dynamic> _analyzeBP(String bpString) {
    final parts = bpString.split('/');
    if (parts.length != 2)
      return {'msg': 'Invalid Format', 'color': Colors.grey};
    int? s = int.tryParse(parts[0]);
    int? d = int.tryParse(parts[1]);
    if (s == null || d == null) return {'msg': 'Unknown', 'color': Colors.grey};

    if (s > 180 || d > 120)
      return {'msg': 'Crisis – Seek Care', 'color': Colors.purple};
    if (s >= 140 || d >= 90)
      return {'msg': 'High (Stage 2)', 'color': Colors.red};
    if ((s >= 130 && s <= 139) || (d > 80 && d <= 89))
      return {'msg': 'High (Stage 1)', 'color': Colors.deepOrange};
    if (s > 120 && s <= 129 && d < 80)
      return {'msg': 'Elevated', 'color': Colors.orange};
    if (s < 90 || d <= 60)
      return {'msg': 'Low (Hypotension)', 'color': Colors.blue};
    return {'msg': 'Normal', 'color': Colors.green};
  }

  Map<String, dynamic> _analyzeBloodSugar(String bsString) {
    int? bs = int.tryParse(bsString);
    if (bs == null) return {'msg': 'Unknown', 'color': Colors.grey};
    if (bs < 70) return {'msg': 'Low (Hypoglycemia)', 'color': Colors.blue};
    if (bs <= 100) return {'msg': 'Normal', 'color': Colors.green};
    if (bs <= 125) return {'msg': 'Prediabetes', 'color': Colors.orange};
    return {'msg': 'Diabetes', 'color': Colors.red};
  }

  Map<String, dynamic> _analyzeHemoglobin(String hemoString) {
    double? hemo = double.tryParse(hemoString);
    if (hemo == null) return {'msg': 'Unknown', 'color': Colors.grey};
    if (hemo < 12.0) return {'msg': 'Low (Anemia)', 'color': Colors.red};
    if (hemo > 17.5) return {'msg': 'High', 'color': Colors.orange};
    return {'msg': 'Normal', 'color': Colors.green};
  }

  void _showEditDialog({
    required String title,
    required String currentValue,
    required Function(String) onSave,
    bool isNumber = false,
    String? suffix,
  }) {
    final controller = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit $title"),
        content: TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            suffixText: suffix,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              onSave(controller.text);
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    final bmiData = _calculateBMI(appState.userHeight, appState.userWeight);
    final hrData = _analyzeHeartRate(appState.heartRate);
    final bpData = _analyzeBP(appState.bloodPressure);
    final bsData = _analyzeBloodSugar(appState.bloodSugar);
    final hemoData = _analyzeHemoglobin(appState.hemoglobin);

    return Scaffold(
      backgroundColor: lightBlue,
      appBar: AppBar(
        title: const Text(
          'My Health Stats',
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
              "Body Composition",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            _buildBMICard(appState, bmiData),

            const SizedBox(height: 20),
            const Text(
              "Vital Signs",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 0.85,
              children: [
                _buildVitalCard(
                  title: "Heart Rate",
                  value: appState.heartRate.isEmpty ? "--" : appState.heartRate,
                  unit: "bpm",
                  icon: Icons.favorite,
                  message: hrData['msg'],
                  statusColor: hrData['color'],
                  onTap: () => _showEditDialog(
                    title: "Heart Rate",
                    currentValue: appState.heartRate,
                    isNumber: true,
                    // FIX: Saves to timeline!
                    onSave: (val) => appState.saveNewHealthStat(newHr: val),
                  ),
                ),
                _buildVitalCard(
                  title: "Blood Pressure",
                  value: appState.bloodPressure.isEmpty
                      ? "--/--"
                      : appState.bloodPressure,
                  unit: "mmHg",
                  icon: Icons.bloodtype,
                  message: bpData['msg'],
                  statusColor: bpData['color'],
                  onTap: () => _showEditDialog(
                    title: "Blood Pressure (e.g. 120/80)",
                    currentValue: appState.bloodPressure,
                    // FIX: Saves to timeline!
                    onSave: (val) => appState.saveNewHealthStat(newBp: val),
                  ),
                ),
                _buildVitalCard(
                  title: "Blood Sugar",
                  value: appState.bloodSugar.isEmpty
                      ? "--"
                      : appState.bloodSugar,
                  unit: "mg/dL",
                  icon: Icons.local_fire_department,
                  message: bsData['msg'],
                  statusColor: bsData['color'],
                  onTap: () => _showEditDialog(
                    title: "Blood Sugar Fasting",
                    currentValue: appState.bloodSugar,
                    isNumber: true,
                    // FIX: Saves to timeline!
                    onSave: (val) =>
                        appState.saveNewHealthStat(newBloodSugar: val),
                  ),
                ),
                _buildVitalCard(
                  title: "Hemoglobin",
                  value: appState.hemoglobin.isEmpty
                      ? "--"
                      : appState.hemoglobin,
                  unit: "g/dL",
                  icon: Icons.science,
                  message: hemoData['msg'],
                  statusColor: hemoData['color'],
                  onTap: () => _showEditDialog(
                    title: "Hemoglobin",
                    currentValue: appState.hemoglobin,
                    isNumber: true,
                    // FIX: Saves to timeline!
                    onSave: (val) => appState.saveNewHealthStat(newHemo: val),
                  ),
                ),
                _buildVitalCard(
                  title: "Condition",
                  value: appState.userCondition.isEmpty
                      ? "None"
                      : appState.userCondition,
                  unit: "",
                  icon: Icons.medical_services,
                  message: "Ongoing",
                  statusColor: primaryBlue,
                  onTap: () => _showEditDialog(
                    title: "Current Condition",
                    currentValue: appState.userCondition,
                    onSave: (val) => appState.updateProfile(
                      newCondition: val,
                    ), // Not a stat, just update profile
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),
            const Text(
              "Other Information",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            _buildStaticRow(
              "Age",
              "${appState.userAge} years",
              Icons.cake,
              () => _showEditDialog(
                title: "Age",
                currentValue: appState.userAge.toString(),
                isNumber: true,
                onSave: (val) =>
                    appState.updateProfile(newAge: int.tryParse(val) ?? 0),
              ),
            ),
            _buildStaticRow(
              "Blood Group",
              appState.bloodGroup.isEmpty ? "Not Set" : appState.bloodGroup,
              Icons.opacity,
              () => _showEditDialog(
                title: "Blood Group",
                currentValue: appState.bloodGroup,
                onSave: (val) => appState.updateProfile(newBloodGroup: val),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/medilist'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                'My Meds',
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

  Widget _buildBMICard(AppState appState, Map<String, dynamic> bmiData) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildClickableValue(
                    "Height",
                    "${appState.userHeight} cm",
                    () {
                      _showEditDialog(
                        title: "Height (cm)",
                        currentValue: appState.userHeight.toString(),
                        isNumber: true,
                        onSave: (val) => appState.updateProfile(
                          newHeight: double.tryParse(val) ?? 0,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  _buildClickableValue(
                    "Weight",
                    "${appState.userWeight} kg",
                    () {
                      _showEditDialog(
                        title: "Weight (kg)",
                        currentValue: appState.userWeight.toString(),
                        isNumber: true,
                        // FIX: Weight is a health stat, save to timeline!
                        onSave: (val) => appState.saveNewHealthStat(
                          newWeight:
                              double.tryParse(val) ?? appState.userWeight,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Container(
              width: 1,
              height: 60,
              color: Colors.grey[300],
              margin: const EdgeInsets.symmetric(horizontal: 15),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Text(
                    "BMI",
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  Text(
                    (bmiData['value'] as double).toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: bmiData['color'],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: (bmiData['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      bmiData['category'],
                      style: TextStyle(
                        color: bmiData['color'],
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClickableValue(String label, String value, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Row(
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Icon(Icons.edit, size: 14, color: primaryBlue),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVitalCard({
    required String title,
    required String value,
    required String unit,
    required IconData icon,
    required String message,
    required Color statusColor,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(icon, color: statusColor, size: 28),
                  const Icon(Icons.edit, color: Colors.grey, size: 16),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          value,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          unit,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  message,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStaticRow(
    String title,
    String value,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.grey),
        title: Text(
          title,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(width: 10),
            Icon(Icons.edit, size: 16, color: primaryBlue),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
