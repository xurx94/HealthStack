import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:test/medicine tracker pages/hover_card.dart';
import 'symptoms_manager.dart';
import 'package:test/app_state.dart';

class SymptomOption {
  final String label;
  final IconData icon;
  SymptomOption(this.label, this.icon);
}

class SymptomCategory {
  final String title;
  final IconData categoryIcon;
  final Color accentColor;
  final Color allColor;
  final Color bgColor;
  final List<SymptomOption> options;
  SymptomCategory({
    required this.title,
    required this.categoryIcon,
    required this.accentColor,
    required this.bgColor,
    required this.options,
    required this.allColor,
  });
}

final List<SymptomCategory> allCategories = [
  SymptomCategory(
    title: 'Whole Body',
    categoryIcon: Icons.man_2_outlined,
    accentColor: Color.fromARGB(255, 163, 184, 205),
    bgColor: Color(0xFFF1F5F9),
    allColor: Color.fromARGB(255, 93, 159, 250),
    options: [
      SymptomOption('Fever', Icons.thermostat_outlined),
      SymptomOption('Fatigue', Icons.bedtime_outlined),
      SymptomOption('Chills', Icons.ac_unit_outlined),
      SymptomOption('Sweating', Icons.water_drop_outlined),
      SymptomOption('Weight Change', Icons.monitor_weight_outlined),
    ],
  ),
  SymptomCategory(
    title: 'Head & Mind',
    categoryIcon: Icons.psychology_outlined,
    accentColor: Color.fromARGB(255, 215, 179, 253),
    bgColor: Color(0xFFF3E8FF),
    allColor: Color.fromARGB(255, 100, 38, 207),
    options: [
      SymptomOption('Headache', Icons.sick_outlined),
      SymptomOption('Dizziness', Icons.sync_problem_outlined),
      SymptomOption('Memory Issues', Icons.memory_outlined),
      SymptomOption('Numbness', Icons.pan_tool_outlined),
    ],
  ),
  SymptomCategory(
    title: 'Breathing & Chest',
    categoryIcon: Icons.air_outlined,
    accentColor: Color.fromARGB(255, 158, 213, 249),
    bgColor: Color(0xFFE0F2FE),
    allColor: Color.fromARGB(255, 2, 169, 199),
    options: [
      SymptomOption('Cough', Icons.sick_outlined),
      SymptomOption('Shortness of Breath', Icons.air_outlined),
      SymptomOption('Chest Tightness', Icons.compress_outlined),
      SymptomOption('Wheezing', Icons.graphic_eq_outlined),
      SymptomOption('Sneezing', Icons.masks_outlined),
    ],
  ),
  SymptomCategory(
    title: 'Stomach & Digestion',
    categoryIcon: Icons.restaurant_outlined,
    accentColor: Color.fromARGB(255, 218, 164, 94),
    bgColor: Color(0xFFFFEDD5),
    allColor: Color.fromARGB(255, 234, 97, 12),
    options: [
      SymptomOption('Nausea', Icons.sick_outlined),
      SymptomOption('Vomiting', Icons.warning_amber_outlined),
      SymptomOption('Diarrhea', Icons.run_circle_outlined),
      SymptomOption('Constipation', Icons.block_outlined),
      SymptomOption('Stomach Pain', Icons.warning_amber_outlined),
    ],
  ),
  SymptomCategory(
    title: 'Heart & Blood',
    categoryIcon: Icons.favorite_outline,
    accentColor: Color.fromARGB(255, 247, 131, 131),
    bgColor: Color(0xFFFEE2E2),
    allColor: Color(0xFFDC2626),
    options: [
      SymptomOption('Chest Pain', Icons.warning_amber_outlined),
      SymptomOption('Palpitations', Icons.monitor_heart_outlined),
      SymptomOption('High BP', Icons.speed_outlined),
      SymptomOption('Low BP', Icons.slow_motion_video_outlined),
    ],
  ),
  SymptomCategory(
    title: 'Muscles & Joints',
    categoryIcon: Icons.accessibility_new_outlined,
    accentColor: Color.fromARGB(255, 109, 236, 153),
    bgColor: Color(0xFFDCFCE7),
    allColor: Color(0xFF16A34A),
    options: [
      SymptomOption('Muscle Pain', Icons.fitness_center_outlined),
      SymptomOption('Joint Pain', Icons.accessibility_outlined),
      SymptomOption('Back Pain', Icons.airline_seat_flat_outlined),
      SymptomOption('Stiffness', Icons.lock_outline),
      SymptomOption('Swelling', Icons.bubble_chart_outlined),
    ],
  ),
  SymptomCategory(
    title: 'Skin & Hair',
    categoryIcon: Icons.face_outlined,
    accentColor: Color.fromARGB(255, 235, 114, 183),
    bgColor: Color(0xFFFCE7F3),
    allColor: Color.fromARGB(255, 240, 20, 119),
    options: [
      SymptomOption('Rash', Icons.grain_outlined),
      SymptomOption('Itching', Icons.pan_tool_outlined),
      SymptomOption('Acne', Icons.brightness_high_outlined),
      SymptomOption('Hair Loss', Icons.content_cut_outlined),
      SymptomOption('Bruising', Icons.blur_on_outlined),
    ],
  ),
  SymptomCategory(
    title: 'Sleep Quality',
    categoryIcon: Icons.nightlight_round,
    accentColor: const Color.fromARGB(255, 91, 144, 235),
    bgColor: Color(0xFFE3F2FD),
    allColor: const Color(0xFF191970),
    options: [
      SymptomOption('Great', Icons.star_outline_rounded),
      SymptomOption('Good', Icons.thumb_up_outlined),
      SymptomOption('Fair', Icons.thumbs_up_down_outlined),
      SymptomOption('Poor', Icons.thumb_down_outlined),
      SymptomOption('Insomnia', Icons.bedtime_outlined),
      SymptomOption('Oversleep', Icons.snooze_outlined),
    ],
  ),
  SymptomCategory(
    title: 'Nutrition & Hydration',
    categoryIcon: Icons.local_dining_rounded,
    accentColor: const Color.fromARGB(255, 116, 247, 234),
    bgColor: Color(0xFFE0F2F1),
    allColor: Colors.teal,
    options: [
      SymptomOption('Well Fed', Icons.restaurant_outlined),
      SymptomOption('Skipped Meal', Icons.no_meals_outlined),
      SymptomOption('Hydrated', Icons.water_drop_outlined),
      SymptomOption('Dehydrated', Icons.opacity_outlined),
      SymptomOption('Overate', Icons.fastfood_outlined),
      SymptomOption('Balanced', Icons.balance_outlined),
    ],
  ),
];

// Duration chip labels
const List<String> durationLabels = ['Just started', 'Few hours'];

// Only acute/physical symptoms that have a clear onset show duration chips
const Set<String> durationEligibleSymptoms = {
  // Whole Body
  'Fever', 'Fatigue',
  // Head & Mind
  'Headache', 'Dizziness', 'Numbness',
  // Breathing & Chest
  'Cough', 'Shortness of Breath', 'Wheezing', 'Chest Tightness', 'Sneezing',
  // Stomach & Digestion
  'Nausea', 'Vomiting', 'Diarrhea', 'Stomach Pain',
  // Heart & Blood
  'Chest Pain', 'Palpitations',
  // Muscles & Joints
  'Muscle Pain', 'Joint Pain', 'Back Pain', 'Stiffness',
};

class Symptoms extends StatefulWidget {
  const Symptoms({super.key});

  @override
  State<Symptoms> createState() => _SymptomsState();
}

class _SymptomsState extends State<Symptoms> {
  late String today;
  late DateTime selectedDate;

  // catIndex -> set of selected symptom labels
  Map<int, Set<String>> selections = {};

  // symptom label -> duration string
  Map<String, String> durations = {};

  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  late List<bool> categoryVisible;

  final DateTime _baseToday = DateTime.now();

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    today = _formatDate(selectedDate);
    categoryVisible = List.filled(allCategories.length, true);

    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text.toLowerCase();
      });
    });

    // Load existing log for today if it exists
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadExistingLog());
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _loadExistingLog() {
    final manager = context.read<SymptomManager>();
    final dateKey = DateFormat('yyyy-MM-dd').format(selectedDate);
    final existing = manager.getLog(dateKey);
    if (existing != null) {
      setState(() {
        selections.clear();
        for (final entry in existing.categorySelections.entries) {
          final catIndex = allCategories.indexWhere(
            (c) => c.title == entry.key,
          );
          if (catIndex != -1) {
            selections[catIndex] = Set<String>.from(entry.value);
          }
        }
      });
    }
  }

  String _formatDate(DateTime date) {
    DateTime now = DateTime.now();
    DateTime yesterday = now.subtract(Duration(days: 1));
    if (_isSameDay(date, now)) return 'Today';
    if (_isSameDay(date, yesterday)) return 'Yesterday';
    return DateFormat('dd MMM yyyy').format(date);
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  void _goToPreviousDay() {
    setState(() {
      selectedDate = selectedDate.subtract(const Duration(days: 1));
      today = _formatDate(selectedDate);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadExistingLog());
  }

  void _goToNextDay() {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final next = selectedDate.add(const Duration(days: 1));
    if (next.isBefore(tomorrow)) {
      setState(() {
        selectedDate = next;
        today = _formatDate(selectedDate);
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadExistingLog());
    }
  }

  bool get _isToday => _isSameDay(selectedDate, DateTime.now());

  int get _trackingDay {
    final appState = context.read<AppState>();
    final box = appState.settingsBox;
    final String? startStr = box.get('trackingStartDate');
    if (startStr == null) {
      box.put('trackingStartDate', _baseToday.toIso8601String());
      return 1;
    }
    final start = DateTime.parse(startStr);
    return _baseToday
            .difference(DateTime(start.year, start.month, start.day))
            .inDays +
        1;
  }

  void _toggleOption(int catIndex, String label) {
    setState(() {
      selections.putIfAbsent(catIndex, () => {});
      if (selections[catIndex]!.contains(label)) {
        selections[catIndex]!.remove(label);
        durations.remove(label);
      } else {
        selections[catIndex]!.add(label);
      }
    });
  }

  int get totalSelections =>
      selections.values.fold(0, (sum, s) => sum + s.length);

  void _showEditDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (ctx, setModal) {
            return DraggableScrollableSheet(
              expand: false,
              builder: (_, controller) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(20, 16, 20, 32),
                  child: SingleChildScrollView(
                    controller: controller,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Edit Categories',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12),
                        ...allCategories.asMap().entries.map((e) {
                          return CheckboxListTile(
                            activeColor: Colors.teal,
                            title: Text(e.value.title),
                            value: categoryVisible[e.key],
                            onChanged: (v) {
                              setModal(
                                () => categoryVisible[e.key] = v ?? true,
                              );
                              setState(() {});
                            },
                            secondary: Icon(
                              e.value.categoryIcon,
                              color: e.value.allColor,
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _saveLog() {
    final manager = context.read<SymptomManager>();
    final dateKey = DateFormat('yyyy-MM-dd').format(selectedDate);

    final Map<String, List<String>> categorySelections = {};
    for (final entry in selections.entries) {
      if (entry.value.isNotEmpty) {
        categorySelections[allCategories[entry.key].title] = entry.value
            .toList();
      }
    }

    manager.saveLog(dateKey, categorySelections);

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.teal),
              SizedBox(width: 8),
              Text(
                'Log Saved!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          content: Text(
            'Your health log for $today has been saved.',
            style: TextStyle(fontSize: 13, height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Done',
                style: TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<MapEntry<int, SymptomCategory>> filtered = allCategories
        .asMap()
        .entries
        .where((e) {
          if (!categoryVisible[e.key]) return false;
          if (searchQuery.isEmpty) return true;
          return e.value.title.toLowerCase().contains(searchQuery) ||
              e.value.options.any(
                (o) => o.label.toLowerCase().contains(searchQuery),
              );
        })
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFD6E2EB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD6E2EB),
        shadowColor: Colors.black,
        elevation: 2,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          children: [
            Text(
              today,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Tracking Day $_trackingDay',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.chevron_left_rounded),
            color: Colors.black87,
            iconSize: 26,
            tooltip: 'Previous day',
            onPressed: _goToPreviousDay,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right_rounded),
            color: _isToday ? Colors.grey[400] : Colors.black87,
            iconSize: 26,
            tooltip: 'Next day',
            onPressed: _isToday ? null : _goToNextDay,
          ),
        ],
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SizedBox(
          width: double.infinity,
          child: FloatingActionButton.extended(
            onPressed: _saveLog,
            backgroundColor: const Color.fromARGB(255, 0, 135, 165),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            icon: const Icon(Icons.edit_note, color: Colors.white, size: 26),
            label: Text(
              'Save ${totalSelections > 0 ? '$totalSelections ' : ''}log${totalSelections > 1 ? 's' : ''}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HoverCard(
              onTap: () {
                Navigator.pushNamed(context, '/symptoms_history');
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  SizedBox(width: 16),
                  Text(
                    'History',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: const Icon(Icons.history_rounded),
                    color: Colors.black87,
                    tooltip: 'History',
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            HoverCard(
              onTap: () {},
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search symptoms, habits…',
                  hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: Colors.teal),
                  suffixIcon: searchQuery.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            searchController.clear();
                            FocusScope.of(context).unfocus();
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),

            SizedBox(height: 16),

            Row(
              children: [
                Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: _showEditDialog,
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined, size: 16, color: Colors.black),
                      SizedBox(width: 4),
                      Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),

            if (filtered.isEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: [
                      Icon(
                        Icons.search_off_rounded,
                        size: 48,
                        color: Colors.white54,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'No results for "$searchQuery"',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...filtered.map((entry) {
                return _CategoryCard(
                  category: entry.value,
                  catIndex: entry.key,
                  selections: selections[entry.key] ?? {},
                  durations: durations,
                  searchQuery: searchQuery,
                  onToggle: _toggleOption,
                  onDurationSelected: (label, duration) {
                    setState(() => durations[label] = duration);
                  },
                );
              }),

            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final SymptomCategory category;
  final int catIndex;
  final Set<String> selections;
  final Map<String, String> durations;
  final String searchQuery;
  final void Function(int catIndex, String label) onToggle;
  final void Function(String label, String duration) onDurationSelected;

  const _CategoryCard({
    required this.category,
    required this.catIndex,
    required this.selections,
    required this.durations,
    required this.searchQuery,
    required this.onToggle,
    required this.onDurationSelected,
  });

  @override
  Widget build(BuildContext context) {
    List<SymptomOption> visibleOptions = searchQuery.isEmpty
        ? category.options
        : category.options
              .where((o) => o.label.toLowerCase().contains(searchQuery))
              .toList();

    return Column(
      children: [
        HoverCard(
          onTap: () {},
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadowColor: category.accentColor,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: category.bgColor,
                      child: Icon(
                        category.categoryIcon,
                        color: category.allColor,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        category.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (selections.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: category.bgColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${selections.length} selected',
                          style: TextStyle(
                            fontSize: 11,
                            color: category.allColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: visibleOptions.map((opt) {
                    bool selected = selections.contains(opt.label);
                    final showDuration =
                        selected &&
                        durationEligibleSymptoms.contains(opt.label);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Symptom chip
                        GestureDetector(
                          onTap: () => onToggle(catIndex, opt.label),
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 180),
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: selected
                                  ? category.bgColor
                                  : Color(0xFFF5F7FA),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: selected
                                    ? category.allColor
                                    : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  opt.icon,
                                  size: 16,
                                  color: category.allColor,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  opt.label,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: selected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                    color: selected
                                        ? category.allColor
                                        : Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Duration chips — only for acute/physical symptoms
                        if (showDuration) ...[
                          SizedBox(height: 6),
                          Wrap(
                            spacing: 6,
                            children: durationLabels.map((d) {
                              final isChosen = durations[opt.label] == d;
                              return GestureDetector(
                                onTap: () => onDurationSelected(opt.label, d),
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 150),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isChosen
                                        ? category.allColor
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: category.allColor.withOpacity(0.5),
                                    ),
                                  ),
                                  child: Text(
                                    d,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isChosen
                                          ? Colors.white
                                          : category.allColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 4),
                        ],
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
