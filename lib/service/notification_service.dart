import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:reminder/model/reminder.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> scheduleReminderNotification(Reminder reminder) async {
    final DateTime scheduledDateTime = DateTime(
      reminder.date.year,
      reminder.date.month,
      reminder.date.day,
      reminder.time.hour,
      reminder.time.minute,
    );

    final tz.TZDateTime tzScheduledDateTime =
        tz.TZDateTime.from(scheduledDateTime, tz.getLocation('Asia/Kolkata'));

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'CHANNEL_ID 1',
      'CHANNEL_NAME 1',
      importance: Importance.max,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      reminder.title,
      reminder.description,
      tzScheduledDateTime,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  static Future<void> cancelReminderNotification(Reminder reminder) async {
    int uniqueId = _generateUniqueId(reminder);

    await _flutterLocalNotificationsPlugin.cancel(uniqueId);
  }

  static int _generateUniqueId(Reminder reminder) {
    String uniqueString = "${reminder.title}_${reminder.date}_${reminder.time}";

    return uniqueString.hashCode;
  }
}
