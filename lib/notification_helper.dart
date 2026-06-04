import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:flutter/foundation.dart';

class NotificationHelper {
  static final NotificationHelper _instance = NotificationHelper._internal();
  factory NotificationHelper() => _instance;
  NotificationHelper._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    if (kIsWeb) return; // Prevents the white screen crash on Web

    tz.initializeTimeZones();

    try {
      // The final fix: Extracting the identifier from the TimezoneInfo object
      final TimezoneInfo info = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(info.identifier));
    } catch (error, stackTrace) {
      debugPrint('NotificationHelper timezone init failed: $error');
      tz.setLocalLocation(tz.UTC);
    }

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    try {
      await _notificationsPlugin.initialize(settings: initSettings);
    } catch (error, stackTrace) {
      debugPrint('NotificationHelper initialize failed: $error');
    }
  }

  Future<void> requestPermissions() async {
    if (kIsWeb) return;

    if (defaultTargetPlatform == TargetPlatform.android) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _notificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();

      await androidImplementation?.requestNotificationsPermission();
      await androidImplementation?.requestExactAlarmsPermission();
    }
  }

  Future<void> scheduleDailyMedicineReminder({
    required int notificationId,
    required String medicineName,
    required TimeOfDay timeOfDay,
  }) async {
    if (kIsWeb) return;

    final details = NotificationDetails(
      android: const AndroidNotificationDetails(
        'daily_meds_channel',
        'Daily Medication Reminders',
        channelDescription: 'Reminds you to take your daily scheduled pills.',
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        enableVibration: true,
        playSound: true,
      ),
      iOS: const DarwinNotificationDetails(),
    );

    final tz.TZDateTime nextSchedule = _nextInstanceOfTime(timeOfDay);

    await _notificationsPlugin.zonedSchedule(
      id: notificationId,
      title: 'Time for your medicine!',
      body: 'Don\'t forget to take your $medicineName.',
      scheduledDate: nextSchedule,
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelReminder(int notificationId) async {
    if (kIsWeb) return;
    await _notificationsPlugin.cancel(id: notificationId);
  }

  Future<void> cancelAllReminders() async {
    if (kIsWeb) return;
    await _notificationsPlugin.cancelAll();
  }

  tz.TZDateTime _nextInstanceOfTime(TimeOfDay time) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
