import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings settings = InitializationSettings(
    android: androidSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(settings);
}

Future<void> showTargetReminderNotification(int remaining) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'daily_target_channel', 'Daily Target Reminder',
      importance: Importance.max, priority: Priority.high);

  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    0,
    'Daily Target Reminder',
    'You have $remaining applications left to hit today\'s goal!',
    notificationDetails,
  );
}
