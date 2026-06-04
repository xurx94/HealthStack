import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart'; // <--- Added for kIsWeb check
import 'package:test/symptompages/symptoms.dart';
import 'package:test/symptompages/symptoms_history.dart';
import 'package:test/symptompages/symptoms_log.dart';
import 'package:test/symptompages/symptoms_manager.dart';
import 'doctor_visit.dart';
import 'notification_helper.dart';
import 'splash.dart';
import 'main_layout.dart';
import 'home.dart';
import 'medicine tracker pages/medicine_list.dart';
import 'medicine tracker pages/adder_form.dart';
import 'medicine tracker pages/medi_manager.dart';
import 'medicine tracker pages/medicine.dart';
import 'database/hive_adapters.dart';
import 'report_ui/upload_report.dart';
import 'report_ui/reports_screen.dart';
import 'profile_ui/profile.dart';
import 'profile_ui/profileManager.dart';
import 'profile_ui/profile_page.dart';
import 'app_state.dart';
import 'status_screen.dart';
import 'visit_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    await dotenv.load(
      fileName: ".env",
    ); // Load environment variables from .env file

    //NOtIFICATION
    final notifHelper = NotificationHelper();
    await notifHelper.init();
    await notifHelper.requestPermissions();

    // 2. Initialize Hive
    await Hive.initFlutter();

    // 3. Register ALL Adapters
    Hive.registerAdapter(TimeOfDayAdapter());
    Hive.registerAdapter(medicineAdapter());
    Hive.registerAdapter(ContactAdapter());
    Hive.registerAdapter(ProfileAdapter());
    Hive.registerAdapter(MedicalReportAdapter());
    Hive.registerAdapter(HealthStatRecordAdapter());
    Hive.registerAdapter(SymptomLogAdapter());

    // 4. Secure Storage (Bypassed on Web to prevent browser crashes)
    List<int>? encryptionKeyUint8List;

    if (!kIsWeb) {
      const secureStorage = FlutterSecureStorage();
      final encryptionKeyString = await secureStorage.read(key: 'key');
      if (encryptionKeyString == null) {
        final key = Hive.generateSecureKey();
        await secureStorage.write(key: 'key', value: base64UrlEncode(key));
      }
      final key = await secureStorage.read(key: 'key');
      encryptionKeyUint8List = base64Url.decode(key!);
    }

    final secureCipher = kIsWeb ? null : HiveAesCipher(encryptionKeyUint8List!);

    // 5. Open Secure Vaults
    await Hive.openBox<medicine>('medicineBox', encryptionCipher: secureCipher);
    await Hive.openBox<Profile>('profileBox', encryptionCipher: secureCipher);
    await Hive.openBox<HealthStatRecord>(
      'healthStatsBox',
      encryptionCipher: secureCipher,
    );
    await Hive.openBox<MedicalReport>(
      'reportsBox',
      encryptionCipher: secureCipher,
    );
    await Hive.openBox<SymptomLog>(
      'symptomBox',
      encryptionCipher: secureCipher,
    );
    await Hive.openBox('settingsBox', encryptionCipher: secureCipher);

    runApp(const MyApp());
  } catch (e, stack) {
    // IF ANYTHING FAILS, SHOW THIS RED SCREEN INSTEAD OF A BLACK SCREEN!
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.red[900],
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Text(
                "CRASH LOG:\n\n$e\n\n$stack",
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// I wrapped your MultiProvider in a clean MyApp widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MediManager()),
        ChangeNotifierProvider(create: (context) => AppState()),
        ChangeNotifierProvider(create: (context) => Profilemanager()),
        ChangeNotifierProvider(create: (context) => SymptomManager()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/main': (context) => const MainLayout(),
          '/home': (context) => const home(),
          '/medilist': (context) => const medilist(),
          '/adderform': (context) => const adderform(),
          '/reports': (context) => const ReportsScreen(),
          '/upload': (context) => const UploadReportScreen(),
          '/profile': (context) => const ProfilePage(),
          '/status': (context) => const StatusScreen(),
          '/doctor_visit': (context) => const DoctorVisitScreen(),
          '/visit_summary': (context) => const VisitSummaryScreen(),
          '/symptoms': (context) => const Symptoms(),
          '/symptoms_history': (context) => const SymptomsHistoryPage(),
        },
      ),
    );
  }
}
