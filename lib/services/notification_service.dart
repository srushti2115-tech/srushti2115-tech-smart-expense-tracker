import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  // =========================
  // 🔔 INIT NOTIFICATIONS
  // =========================
  static Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
        InitializationSettings(android: androidSettings);

    await _notifications.initialize(settings);

    // Request permission (Android 13+ / iOS)
    await FirebaseMessaging.instance.requestPermission();
  }

  // =========================
  // 🚨 SHOW NOTIFICATION
  // =========================
  static Future<void> showNotification(
    String title,
    String body,
  ) async {
    // 🔐 Extra safety: only for verified users
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || !user.emailVerified) return;

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'budget_channel',
      'Budget Alerts',
      channelDescription: 'Alerts for budget overspending',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await _notifications.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }
}
