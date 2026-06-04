import 'package:hive/hive.dart';

part 'symptoms_log.g.dart';

@HiveType(typeId: 5) // <--- CHANGE THIS FROM 4 TO 5
class SymptomLog extends HiveObject {
  @HiveField(0)
  final String dateKey; // format: 'yyyy-MM-dd'

  @HiveField(1)
  final Map<String, List<String>> categorySelections;

  @HiveField(2)
  final DateTime savedAt;

  SymptomLog({
    required this.dateKey,
    required this.categorySelections,
    required this.savedAt,
  });
}
